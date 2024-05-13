using RedHouse_Server.Dtos.AuthDtos;
using RedHouse_Server.Dtos.PropertyDtos;
using RedHouse_Server.Services;
using Cooking_School.Core.ModelUsed;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using server.Dtos.PropertyDtos;
using Microsoft.AspNetCore.Authorization;
using server.Services;
using RedHouse_Server.Dtos.ApplicationDtos;
using Hangfire;
using Cooking_School.Dtos;
using RedHouse_Server.Models;

namespace RedHouse_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class BackgroundProcessingController : ControllerBase
    {
        private IMilestoneServices _milestoneServices;
        private IContractServices _contractServices;


        public BackgroundProcessingController(IMilestoneServices milestoneServices, IContractServices contractServices)
        {
            _milestoneServices = milestoneServices;
            _contractServices = contractServices;
        }

        // [Authorize]
        [HttpPost("/contracts/{Id}/create-monthly-milestone")]
        public async Task<IActionResult> CreateMonthlyMilestone(int Id)
        {
            ResponsDto<Contract> result = await _contractServices.GetContract(Id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }

            var contract = result.Dto;
            var dayOfMonth = contract.Offer.OfferDate.Day;

            // Validate that dayOfMonth is between 1 and 31
            if (dayOfMonth < 1 || dayOfMonth > 31)
            {
                // Handle the error, for example, return BadRequest
                return BadRequest("Invalid day of the month");
            }

            Console.WriteLine(dayOfMonth);
            var jobId = $"RecurringJob_{Id}";
            var cronExpression = $"0 0 {dayOfMonth} * *";

            // Remove the existing recurring job if it exists
            RecurringJob.RemoveIfExists(jobId);

            // Schedule the new recurring job
            RecurringJob.AddOrUpdate(jobId, () => _milestoneServices.CreateMonthlyMilestone(Id), cronExpression);
            return Ok();
        }


        [HttpDelete("/contracts/{Id}/create-monthly-milestone")]
        public async Task<IActionResult> TurnOffCreateMonthlyMilestone(int Id)
        {
            ResponsDto<Contract> result = await _contractServices.GetContract(Id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }

            var jobId = $"RecurringJob_{Id}";

            // Remove the existing recurring job if it exists
            RecurringJob.RemoveIfExists(jobId);

            return Ok();
        }


    }
}



