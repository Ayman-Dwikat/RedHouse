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

namespace RedHouse_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ApplicationController : ControllerBase
    {
        private IApplicationServices _applicationServices;

        public ApplicationController(IApplicationServices applicationServices)
        {
            _applicationServices = applicationServices;
        }

        // [Authorize]
        [HttpPost("/applications")]
        public async Task<IActionResult> CreateAppication([FromBody] ApplicationDto applicationDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _applicationServices.CreateApplication(applicationDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/applications/{id}")]
        public async Task<IActionResult> GetProperty(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _applicationServices.GetApplication(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }

        [HttpGet("/users/{id}/applications")]
        public async Task<IActionResult> GetAllProperties(int id, [FromQuery] ApplicationFilter applicationFilter)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _applicationServices.GetApplications(id, applicationFilter);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpDelete("/applications/{id}")]
        public async Task<IActionResult> DeleteApplication(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _applicationServices.DeleteApplication(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }


        [HttpPut("/applications/{id}")]
        public async Task<IActionResult> UpdateApplication([FromBody] UpdateApplicationDto applicationDto, int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _applicationServices.UpdateApplication(applicationDto, id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpPost("/applications/{id}/approve")]
        public async Task<IActionResult> ApproveApplication(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _applicationServices.ApproveApplication(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpPost("/applications/{id}/ignore")]
        public async Task<IActionResult> IgnoreApplication(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _applicationServices.IgnoreApplication(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/applications/number")]
        public async Task<IActionResult> NumberOfVisits()
        {
            var result = await _applicationServices.NumberOfApplications();
            // Set the token value in the cookie
            return Ok(result);
        }

        [HttpGet("/users/{id}/approved-applications")]
        public async Task<IActionResult> GetApprovedApplicationsForUser(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _applicationServices.GetApprovedApplicationsForUser(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);


        }

        [HttpGet("//is-application-approved")]
        public async Task<IActionResult> IsApplicationApproved([FromQuery] int propertyId, int userId)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _applicationServices.IsApplicationApproved(propertyId, userId);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);


        }

        [HttpGet("/applications/is-created")]
        public async Task<IActionResult> IsApplicationCreatedFor([FromQuery] int propertyId, int customerId)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _applicationServices.IsApplicationCreated(propertyId, customerId);
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
