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
using RedHouse_Server.Dtos.NeighborhoodDtos;

namespace RedHouse_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class NeighborhoodController : ControllerBase
    {
        private INeighborhoodServices _neighborhoodServices;

        public NeighborhoodController(INeighborhoodServices neighborhoodServices)
        {
            _neighborhoodServices = neighborhoodServices;
        }
        
        // [Authorize]
        // [HttpPost("/neighborhoods")]
        // public async Task<IActionResult> CreateAppication([FromBody] NeighborhoodDto neighborhoodDto)
        // {
        //     if (!ModelState.IsValid)
        //     {
        //         return BadRequest(ModelState);
        //     }
        //     var result = await _neighborhoodServices.GetNeighborhoods(neighborhoodDto);
        //     if (result.Exception != null)
        //     {
        //         var code = result.StatusCode;
        //         throw new StatusCodeException(code.Value, result.Exception);
        //     }
        //     // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
        //     return Ok(result);

        // }

        

        [HttpGet("/neighborhoods/{Id}")]
        public async Task<IActionResult> GetAllNeighborhood(int Id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _neighborhoodServices.GetNeighborhoods(Id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }
    


        // [HttpPost("/applications/range")]
        // public async Task<IActionResult> RejectApplication([FromBody] ListNeighborhoodDto listNeighborhoodDto)
        // {
        //     if (!ModelState.IsValid)
        //     {
        //         return BadRequest(ModelState);
        //     }
        //     var result = await _neighborhoodServices.AddRangeNeighborhood(listNeighborhoodDto);
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



