using AutoMapper;
using RedHouse_Server.Dtos.AuthDtos;
using RedHouse_Server.Models;
using Cooking_School.Dtos;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Net;
using System.Security.Claims;
using System.Text;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;

namespace RedHouse_Server.Services
{
    public class AuthServices : IAuthServices
    {
        private UserManager<IdentityUser> _userManager;
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly RedHouseDbContext _redHouseDbContext;
        private IConfiguration _configuration;
        private readonly IMapper _mapper;
        public AuthServices(UserManager<IdentityUser> userManager, IMapper mapper, RedHouseDbContext redHouseDbContext, IConfiguration configuration, SignInManager<IdentityUser> signInManager)
        {
            _userManager = userManager;
            _mapper = mapper;
            _redHouseDbContext = redHouseDbContext;
            _configuration = configuration;
            _signInManager = signInManager;
        }

        public async Task<ResponsDto<User>> RegisterUser(RegisterDto registerDto)
        {
            var res = await _userManager.FindByEmailAsync(registerDto.Email!);
            if (res != null)
            {
                return new ResponsDto<User>
                {
                    Exception = new Exception("User Already Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            if (registerDto == null)
            {
                return new ResponsDto<User>
                {
                    Exception = new Exception("Rigister user is null"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }


            var identityUser = new IdentityUser
            {
                Email = registerDto.Email,
                UserName = registerDto.Email,

            };


            var result = await _userManager.CreateAsync(identityUser, registerDto.Password!);
            if (result.Succeeded)
            {
                var location = new Location();
                location.PostalCode = registerDto.ZipCode;

                var resLocation = await _redHouseDbContext.Locations.AddAsync(location);
                await _redHouseDbContext.SaveChangesAsync(); // Persist changes to the database

                User user = new User
                {
                    Email = registerDto.Email,
                    IsVerified = false,
                    Created = DateTime.Now,
                    LocationId = resLocation.Entity.Id,
                    Name = registerDto.Name,
                    PhoneNumber = registerDto.PhoneNumber,
                    UserRole = registerDto.UserRole,
                };
                await _redHouseDbContext.Users.AddAsync(user);
                await _redHouseDbContext.SaveChangesAsync();
                return new ResponsDto<User>
                {
                    Message = "User created successfuly!",
                    StatusCode = HttpStatusCode.OK,
                    Dto = user,
                };
            }
            else
            {
                return new ResponsDto<User>
                {
                    Exception = new Exception(string.Join(", ", result.Errors.Select(e => e.Description))),
                    StatusCode = HttpStatusCode.BadRequest,
                    Message = string.Join(", ", result.Errors.Select(e => e.Description))
                };
            };
        }


        public async Task<ResponsDto<User>> LoginUser(LoginDto loginDto)
        {
            var userRes = await _redHouseDbContext.Users.Where(x => x.Email == loginDto.Email).ToListAsync();

            var user = await _userManager.FindByEmailAsync(loginDto.Email);

            if (user == null)
            {
                return new ResponsDto<User>
                {
                    Exception = new Exception("User Not found"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var result = await _signInManager.CheckPasswordSignInAsync(user, loginDto.Password, lockoutOnFailure: false);
            if (result.Succeeded)
            {
                var token = GenerateJwtToken(user);

                return new ResponsDto<User>
                {
                    Message = token,
                    StatusCode = HttpStatusCode.OK,
                    Dto = userRes[0]
                };
            }

            return new ResponsDto<User>
            {
                Exception = new Exception("Invalid login attempt."),
                StatusCode = HttpStatusCode.BadRequest,
            };

        }

        public string GenerateJwtToken(IdentityUser user)
        {
            var tokenExpiration = DateTime.UtcNow.AddDays(2); // Token expires in 1 hour (adjust as needed).

            // Generate a strong, random key of sufficient length
            var securityKey = GenerateStrongSecurityKey();

            var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

            var claims = new List<Claim>
    {
        new Claim(ClaimTypes.Name, user.UserName),        // Add other claims as needed
    };

            var token = new JwtSecurityToken(
                issuer: "your-issuer",
                audience: "your-audience",
                claims: claims,
                expires: tokenExpiration,
                signingCredentials: credentials
            );

            var tokenString = new JwtSecurityTokenHandler().WriteToken(token);

            return tokenString;
        }

        public SymmetricSecurityKey GenerateStrongSecurityKey()
        {
            // Generate a strong, random key
            var keyBytes = new byte[32]; // 256 bits
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(keyBytes);
            }

            return new SymmetricSecurityKey(keyBytes);
        }





        public async Task<ResponsDto<User>> Logout()
        {
            await _signInManager.SignOutAsync();
            return new ResponsDto<User>
            {
                Message = "You are logOut sucssefully",
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<int> NumberOfVisits()
        {
            var firstVisitor = await _redHouseDbContext.Visitors.FirstOrDefaultAsync();

            if (firstVisitor != null)
            {
                return firstVisitor.NumberOfVisitors;
            }

            // Handle the case where the Visitors table is empty
            // You can return a default value or throw an exception, depending on your requirements.
            // For example, you might return 0 if there are no visitors yet.
            return 0;
        }

    }

}
