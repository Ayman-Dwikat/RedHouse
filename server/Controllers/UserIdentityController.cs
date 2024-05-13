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
    public class UserIdentityController : ControllerBase
    {
        private IUserIdentityServices _userIdentityServices;

        public UserIdentityController(IUserIdentityServices userIdentityServices)
        {
            _userIdentityServices = userIdentityServices;
        }
        
        // [Authorize]
        [HttpPost("/userIdentities")]
        public async Task<IActionResult> CreateUserIdentity([FromBody] UserIdentityDto userIdentityDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userIdentityServices.CreateUserIdentity(userIdentityDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/userIdentities/{id}")]
        public async Task<IActionResult> GetUserIdentity(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userIdentityServices.GetUserIdentity(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/userIdentities")]
        public async Task<IActionResult> GetRequestsVerifyUserIdentities([FromQuery] SearchDto searchDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userIdentityServices.GetRequestsVerifyUserIdentities(searchDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpPost("/userIdentities/{id}/verify")]
        public async Task<IActionResult> VerifyUserIdentity(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userIdentityServices.VerifyUserIdentity(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }


        [HttpPost("/userIdentities/{id}/reject")]
        public async Task<IActionResult> RejectUserIdentity(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userIdentityServices.RejectUserIdentity(id);
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



