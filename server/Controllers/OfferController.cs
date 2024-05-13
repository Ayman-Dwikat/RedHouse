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

namespace RedHouse_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OfferController : ControllerBase
    {
        private IOfferServices _offerServices;

        public OfferController(IOfferServices offerServices)
        {
            _offerServices = offerServices;
        }

        // [Authorize]
        [HttpPost("/offers")]
        public async Task<IActionResult> CreateOffer([FromBody] OfferDto offerDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _offerServices.CreateOffer(offerDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/offers/{id}")]
        public async Task<IActionResult> GetOffer(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _offerServices.GetOfferFor(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/offers")]
        public async Task<IActionResult> GetAllOffer()
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _offerServices.GetAllOffers();
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/offers/is-created")]
        public async Task<IActionResult> IsOfferCreatedFor([FromQuery] int propertyId, int landlordId, int customerId)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _offerServices.GetOffer(propertyId, landlordId, customerId);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }




        [HttpGet("/users/{id}/offers")]
        public async Task<IActionResult> GetAllOfferForUser([FromQuery] OfferFilter offerFilter, int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _offerServices.GetAllOffersForUser(id, offerFilter);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }


        [HttpDelete("/offers/{id}")]
        public async Task<IActionResult> DeleteOffer(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _offerServices.DeleteOffer(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpPut("/offers/{id}")]
        public async Task<IActionResult> UpdateOffer([FromBody] UpdateOfferDto offerDto, int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _offerServices.UpdateOffer(offerDto, id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpPost("/offers/{id}/accept")]
        public async Task<IActionResult> AcceptOffer(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _offerServices.AcceptOffer(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/offers/number")]
        public async Task<IActionResult> NumberOfVisits()
        {
            var result = await _offerServices.NumberOfOffers();
            // Set the token value in the cookie
            return Ok(result);
        }

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



