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
using server.Dtos.UserHistoryDtos;

namespace RedHouse_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserHistoryController : ControllerBase
    {
        private IUserHistoryServices _userHistoryServices;
        private IUserServices _userServices;


        public UserHistoryController(IUserHistoryServices userHistoryServices, IUserServices userServices)
        {
            _userHistoryServices = userHistoryServices;
            _userServices = userServices;
        }
        
        // [Authorize]
        [HttpPost("/userHistories")]
        public async Task<IActionResult> CreateUserHistory([FromBody] CreateUserHistoryDto createUserHistoryDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userHistoryServices.CreateUserHistory(createUserHistoryDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        // [HttpGet("/applications/{id}")]
        // public async Task<IActionResult> GetProperty(int id)
        // {
        //     if (!ModelState.IsValid)
        //     {
        //         return BadRequest(ModelState);
        //     }
        //     var result = await _userHistoryServices.GetApplication(id);
        //     if (result.Exception != null)
        //     {
        //         var code = result.StatusCode;
        //         throw new StatusCodeException(code.Value, result.Exception);
        //     }
        //     // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
        //     return Ok(result);

        // }



        [HttpGet("/user-history")]
        public async Task<IActionResult> GetAllProperties([FromQuery] string userId)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userHistoryServices.GetUserHistory(int.Parse(userId));
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }


        [HttpGet("/properties/{id}/property-history")]
        public async Task<IActionResult> GetPropertyHistory(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userHistoryServices.GetPropertyHistory(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }
        // [HttpDelete("/applications/{id}")]
        // public async Task<IActionResult> DeleteApplication(int id)
        // {
        //     if (!ModelState.IsValid)
        //     {
        //         return BadRequest(ModelState);
        //     }
        //     var result = await _userHistoryServices.DeleteApplication(id);
        //     if (result.Exception != null)
        //     {
        //         var code = result.StatusCode;
        //         throw new StatusCodeException(code.Value, result.Exception);
        //     }
        //     // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
        //     return Ok(result);

        // }


        // [HttpPut("/applications/{id}")]
        // public async Task<IActionResult> UpdateApplication([FromBody] ApplicationDto applicationDto, int id)
        // {
        //     if (!ModelState.IsValid)
        //     {
        //         return BadRequest(ModelState);
        //     }
        //     var result = await _userHistoryServices.UpdateApplication(applicationDto, id);
        //     if (result.Exception != null)
        //     {
        //         var code = result.StatusCode;
        //         throw new StatusCodeException(code.Value, result.Exception);
        //     }
        //     // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
        //     return Ok(result);

        // }
    }
}



