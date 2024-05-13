using RedHouse_Server.Dtos.AuthDtos;
using RedHouse_Server.Dtos.PropertyDtos;
using RedHouse_Server.Services;
using Cooking_School.Core.ModelUsed;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using server.Dtos.PropertyDtos;
using Microsoft.AspNetCore.Authorization;
using Cooking_School.Dtos;
using RedHouse_Server.Dtos.LocationDtos;

namespace RedHouse_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PropertyController : ControllerBase
    {
        private IPropertyServices _propertyServices;

        public PropertyController(IPropertyServices propertyServices)
        {
            _propertyServices = propertyServices;
        }
        
        // [Authorize]
        [HttpPost("/properties")]
        public async Task<IActionResult> CreateProperty([FromBody] PropertyDto propertyDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _propertyServices.AddProperty(propertyDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/properties/{id}")]
        public async Task<IActionResult> GetProperty(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _propertyServices.GetProperty(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/properties")]
        public async Task<IActionResult> GetAllProperties([FromQuery] FilterDto filterDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _propertyServices.GetProperties(filterDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/properties/filter")]
        public async Task<IActionResult> FilterProperties([FromQuery] SearchDto searchDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _propertyServices.FilterProperties(searchDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }


        [HttpGet("/properties/closest")]
        public async Task<IActionResult> GetClosestPropertiesToTheCurrentLocation([FromQuery] double latitude, [FromQuery] double longitude)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _propertyServices.GetClosestPropertiesToTheCurrentLocation(latitude, longitude);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }


        [HttpGet("/properties/auto-complete-location/{query}")]
        public async Task<IActionResult> GetListAutoCompleteLocation(string query)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _propertyServices.GetListAutoCompleteLocation(query);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }

        [HttpDelete("/properties/{id}")]
        public async Task<IActionResult> DeleteProperty(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _propertyServices.DeleteProperty(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }


        [HttpPut("/properties/{id}")]
        public async Task<IActionResult> UpdateProperty([FromBody] UpdatePropertyDto propertyDto, int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _propertyServices.UpdateProperty(propertyDto, id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }


        [HttpGet("/users/{id}/properties")]
        public async Task<IActionResult> GetAllPropertiesForUser(int id, [FromQuery] MyPropertiesFilterDto myPropertiesFilterDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _propertyServices.GetAllPropertiesForUser(id, myPropertiesFilterDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/properties/{id}/property-history-price-as-rent")]
        public async Task<IActionResult> GetPricePropertyHistoryAsRent(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _propertyServices.GetPricePropertyHistoryAsRent(id);
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/properties/{id}/property-history-price-as-sell")]
        public async Task<IActionResult> GetPricePropertyHistoryAsSell(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _propertyServices.GetPricePropertyHistoryAsSell(id);
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/properties/property-numbers-in-last-ten-year")]
        public async Task<IActionResult> GetNumberOfPropertiesInLastTenYears()
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _propertyServices.GetNumberOfPropertiesInLastTenYears();
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/properties/number")]
        public async Task<IActionResult> NumberOfVisits()
        {
            var result = await _propertyServices.NumberOfProperties();
            // Set the token value in the cookie
            return Ok(result);
        }
    }
}



