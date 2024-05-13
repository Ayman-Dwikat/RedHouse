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
using Cooking_School.Dtos;

namespace RedHouse_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ContractController : ControllerBase
    {
        private IContractServices _contractServices;

        public ContractController(IContractServices contractServices)
        {
            _contractServices = contractServices;
        }

        // [Authorize]
        [HttpPost("/contracts")]
        public async Task<IActionResult> CreateAppication([FromBody] ContractDto contractDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _contractServices.CreateContract(contractDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/contracts/{id}")]
        public async Task<IActionResult> GetContract(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _contractServices.GetContract(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/contracts")]
        public async Task<IActionResult> GetAllContract()
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _contractServices.GetAllContracts();
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }


        [HttpGet("/users/{id}/contracts")]
        public async Task<IActionResult> GetAllContractForUser(int id, [FromQuery] ContractFilter contractFilter)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _contractServices.GetAllContractsForUser(id, contractFilter);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }

        [HttpGet("/lawyers/{id}/contracts")]
        public async Task<IActionResult> GetAllContractsForLawer(int id, [FromQuery] ContractFilter contractFilter)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _contractServices.GetAllContractsForLawer(id, contractFilter);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }


        [HttpDelete("/contracts/{id}")]
        public async Task<IActionResult> DeleteContract(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _contractServices.DeleteContract(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }


        [HttpPut("/contracts/{contractId}/lawyers/{lawerId}")]
        public async Task<IActionResult> AddLawerToContract(int contractId, int lawerId)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _contractServices.AddLawerToContract(contractId, lawerId);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpPut("/contracts/{id}")]
        public async Task<IActionResult> UpdateContract([FromBody] UpdateContractDto contractDto, int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _contractServices.UpdateContract(contractDto, id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/contracts/number")]
        public async Task<IActionResult> NumberOfVisits()
        {
            var result = await _contractServices.NumberOfContracts();
            // Set the token value in the cookie
            return Ok(result);
        }

        [HttpGet("/contracts/offers/{offerId}")]
        public async Task<IActionResult> GetContractForOffer(int offerId)
        {

            var result = await _contractServices.GetContractForOffer(offerId);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // Set the token value in the cookie
            return Ok(result);
        }

        [HttpGet("/contracts/filter")]
        public async Task<IActionResult> FilterContracts([FromQuery] SearchDto searchDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _contractServices.FilterContracts(searchDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }

        // [HttpPost("/applications/{id}/approve")]
        // public async Task<IActionResult> ApproveApplication(int id)
        // {
        //     if (!ModelState.IsValid)
        //     {
        //         return BadRequest(ModelState);
        //     }
        //     var result = await _contractServices.ApproveApplication(id);
        //     if (result.Exception != null)
        //     {
        //         var code = result.StatusCode;
        //         throw new StatusCodeException(code.Value, result.Exception);
        //     }
        //     // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
        //     return Ok(result);

        // }

        // [HttpPost("/applications/{id}/reject")]
        // public async Task<IActionResult> RejectApplication(int id)
        // {
        //     if (!ModelState.IsValid)
        //     {
        //         return BadRequest(ModelState);
        //     }
        //     var result = await _contractServices.RejectApplication(id);
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



