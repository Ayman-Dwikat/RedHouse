using RedHouse_Server.Dtos.AuthDtos;
using RedHouse_Server.Services;
using Cooking_School.Core.ModelUsed;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using server.Services;
using Cooking_School.Dtos;
using server.Dtos.UpdateUserDto;
namespace RedHouse_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private IUserServices _userServices;
        public UserController(IUserServices userServices)
        {
            _userServices = userServices;
        }

        [HttpGet("/users/{id}")]
        public async Task<IActionResult> GetUser(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userServices.GetUser(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpPut("/users/{id}")]
        public async Task<IActionResult> UpdateUser(int id, [FromBody] UpdateUserDto userDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userServices.UpdateUser(userDto, id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }

        [HttpGet("/users")]
        public async Task<IActionResult> FilterUsers([FromQuery] SearchDto searchDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userServices.FilterUsers(searchDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }

        [HttpGet("/users/{id}/lawyer-contacts")]
        public async Task<IActionResult> GetAllLawyersForUser(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userServices.GetAllLawyersForUser(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }

        [HttpGet("/lawyers/{id}/basic-contacts")]
        public async Task<IActionResult> GetAllContactsForLawer(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userServices.GetAllUsersForLawyer(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }

        [HttpGet("/agents")]
        public async Task<IActionResult> FilterAgents([FromQuery] SearchDto searchDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userServices.FilterAgents(searchDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }

        [HttpGet("/lawyers")]
        public async Task<IActionResult> FilterLawyers([FromQuery] SearchDto searchDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userServices.FilterLawyers(searchDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }



        [HttpGet("/users/number")]
        public async Task<IActionResult> NumberOfVisits()
        {
            var result = await _userServices.NumberOfUsers();
            // Set the token value in the cookie
            return Ok(result);
        }

        [HttpGet("/users/users-numbers-in-last-ten-year")]
        public async Task<IActionResult> GetNumberOfPropertiesInLastTenYears()
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _userServices.GetNumberOfUsersInLastTenYears();
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

    }
}
