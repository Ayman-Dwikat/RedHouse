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
using RedHouse_Server.Dtos.ContractDtos;
using RedHouse_Server.Dtos.OfferDtos;
using RedHouse_Server.Dtos.ComplainDtos;
using Cooking_School.Dtos;

namespace RedHouse_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ComplainController : ControllerBase
    {
        private IComplaintServices _complainServices;

        public ComplainController(IComplaintServices complainServices)
        {
            _complainServices = complainServices;
        }
        
        // [Authorize]
        [HttpPost("/complaints")]
        public async Task<IActionResult> CreateComplain([FromBody] ComplaintDto complainDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _complainServices.CreateComplain(complainDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/complaints/{id}")]
        public async Task<IActionResult> GetComplain(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _complainServices.GetComplain(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/users/{id}/complaints")]
        public async Task<IActionResult> GetAllComplain(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _complainServices.GetComplaints(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }


        [HttpGet("/complaints/for-day")]
        public async Task<IActionResult> GetComplaintsForDay([FromQuery] DateTime day)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _complainServices.GetComplaintsForDay(day);
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/complaints/number-of-complaints-per-day")]
        public async Task<IActionResult> GetNumberOfComplaintsPerDay([FromQuery] SearchDto searchDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _complainServices.GetNumberOfComplaintsPerDay(searchDto);
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }


    }
}



