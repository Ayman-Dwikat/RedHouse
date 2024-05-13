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
using RedHouse_Server.Dtos.MilestoneDtos;

namespace RedHouse_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class MilestoneController : ControllerBase
    {
        private IMilestoneServices _milestoneServices;

        public MilestoneController(IMilestoneServices milestoneServices)
        {
            _milestoneServices = milestoneServices;
        }

        // [Authorize]
        [HttpPost("/milestones")]
        public async Task<IActionResult> CreateMilestone([FromBody] MilestoneDto milestoneDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _milestoneServices.CreateMilestone(milestoneDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/milestones/{id}")]
        public async Task<IActionResult> GetMilestone(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _milestoneServices.GetMilestone(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/milestones")]
        public async Task<IActionResult> GetAllMilestones()
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _milestoneServices.GetAllMilestones();
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }


        [HttpGet("/contracts/{id}/milestones")]
        public async Task<IActionResult> GetAllMilestonesForContract(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _milestoneServices.GetAllMilestonesForContract(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }


        [HttpDelete("/milestones/{id}")]
        public async Task<IActionResult> DeleteMilestone(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _milestoneServices.DeleteMilestone(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }


        [HttpPut("/milestones/{id}")]
        public async Task<IActionResult> UpdateMilestone([FromBody] UpdateMilestoneDto milestoneDto, int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _milestoneServices.UpdateMilestone(milestoneDto, id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpPost("/milestones/{id}/approve")]
        public async Task<IActionResult> ApproveMilestone(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _milestoneServices.ApproveMilestone(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }





    }
}



