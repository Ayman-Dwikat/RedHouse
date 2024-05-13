using RedHouse_Server.Dtos.AuthDtos;
using RedHouse_Server.Services;
using Cooking_School.Core.ModelUsed;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
// using Newtonsoft.Json.Linq;
using System.Reflection.PortableExecutable;
using System.Security.Policy;

namespace RedHouse_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private IAuthServices _authServices;
        public AuthController(IAuthServices authServices)
        {
            _authServices = authServices;
        }

        // /api/auth/register
        [HttpPost("/auth/register")]
        public async Task<IActionResult> Register([FromBody] RegisterDto registerDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _authServices.RegisterUser(registerDto);
            // if (result.Exception != null)
            // {
            //     var code = result.StatusCode;
            //     throw new StatusCodeException(code!.Value, result.Exception);
            // }
            return Ok(result);

        }

        [HttpPost("/auth/login")]
        public async Task<IActionResult> Login([FromBody] LoginDto loginDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _authServices.LoginUser(loginDto);
            // if (result.Exception != null)
            // {
            //     var code = result.StatusCode;
            //     throw new StatusCodeException(code!.Value, result.Exception);
            // }

            // var cookieOptions = new CookieOptions
            // {
            //     Expires = DateTime.Now.AddDays(1), // Expires in 1 day
            //     HttpOnly = true, // Make the cookie accessible only through HTTP (not JavaScript)
            //     Secure = true, // Require HTTPS to send the cookie
            //     SameSite = SameSiteMode.Strict // Enforce same-site cookie policy
            // };

            // // Set the token value in the cookie
            // Response.Cookies.Append("AuthToken", result.Message!, cookieOptions);
            return Ok(result);
        }

        [HttpPost("/auth/logout")]
        public async Task<IActionResult> LogOut(LoginDto loginDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            var result = await _authServices.Logout();
            if (result.Exception != null)
            {
                var code = result.StatusCode;
                throw new StatusCodeException(code!.Value, result.Exception);

            }
            // Set the token value in the cookie
            return Ok(result);
        }


        [HttpGet("/visits-number")]
        public async Task<IActionResult> NumberOfVisits()
        {
            var result = await _authServices.NumberOfVisits();
            // Set the token value in the cookie
            return Ok(result);
        }


    }
}


//const url = 'https://your-api-url.com/api/some-endpoint';
//const token = 'your-auth-token';

//// Create headers with the Authorization header
//const headers = {
//  'Authorization': `Bearer ${token}`,
//  'Content-Type': 'application/json', // adjust content type as needed
//};

//// Make the API request with fetch
//fetch(url, {
//method: 'GET', // or 'POST', 'PUT', etc.
//  headers: headers,
//})
//  .then((response) => {
//       if (!response.ok)
//       {
//           throw new Error('Network response was not ok');
//       }
//       return response.json();
//   })
//  .then((data) => {
//      // Handle the response data
//      console.log(data);
//  })
//  .catch((error) => {
//      // Handle errors
//      console.error(error);
//  });
