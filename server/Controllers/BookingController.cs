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
    public class BookingController : ControllerBase
    {
        private IBookingServices _bookingServices;

        public BookingController(IBookingServices bookingServices)
        {
            _bookingServices = bookingServices;
        }

        // [Authorize]
        [HttpPost("/bookings")]
        public async Task<IActionResult> Book([FromBody] BookingDto bookingDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _bookingServices.Book(bookingDto);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/bookings/{id}")]
        public async Task<IActionResult> GetBooking(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _bookingServices.GetBooking(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        [HttpGet("/bookings")]
        public async Task<IActionResult> GetAllBookings()
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _bookingServices.GetAllBookings();
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }


        [HttpGet("/users/{id}/bookings")]
        public async Task<IActionResult> GetAllOfferForUser(int id, [FromQuery] string bookingsTo, [FromQuery] string bookingStatus)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _bookingServices.GetAllBookingsForUser(id, bookingsTo, bookingStatus);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }


        [HttpGet("/properties/{id}/booking-days")]
        public async Task<IActionResult> GetBookingDaysForProperty(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _bookingServices.GetBookingDaysForProperty(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);
        }


        [HttpDelete("/bookings/{id}")]
        public async Task<IActionResult> DeleteBooking(int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _bookingServices.DeleteBooking(id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }


        [HttpPut("/bookings/{id}")]
        public async Task<IActionResult> UpdateOffer([FromBody] BookingDto bookingDto, int id)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _bookingServices.UpdateBooking(bookingDto, id);
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code.Value, result.Exception);
            }
            // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
            return Ok(result);

        }

        // [HttpPost("/offers/{id}/accept")]
        // public async Task<IActionResult> AcceptOffer(int id)
        // {
        //     if (!ModelState.IsValid)
        //     {
        //         return BadRequest(ModelState);
        //     }
        //     var result = await _offerServices.AcceptOffer(id);
        //     if (result.Exception != null)
        //     {
        //         var code = result.StatusCode;
        //         throw new StatusCodeException(code.Value, result.Exception);
        //     }
        //     // else if(result.StatusCode == System.Net.HttpStatusCode.OK)
        //     return Ok(result);

        // }

        [HttpGet("/bookings/number")]
        public async Task<IActionResult> NumberOfBookings()
        {
            var result = await _bookingServices.NumberOfBookings();
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



