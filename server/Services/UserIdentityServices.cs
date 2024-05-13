using System;
using System.Net;
using Cooking_School.Dtos;
using Microsoft.EntityFrameworkCore;
using RedHouse_Server.Dtos.ApplicationDtos;
using RedHouse_Server.Dtos.ComplainDtos;
using RedHouse_Server.Dtos.ContractDtos;
using RedHouse_Server.Models;
using server.Models;

namespace server.Services
{
    public class UserIdentityServices : IUserIdentityServices
    {
        private RedHouseDbContext _redHouseDbContext;
        public UserIdentityServices(RedHouseDbContext blueHouseDbContext)
        {
            _redHouseDbContext = blueHouseDbContext;
        }

        public async Task<ResponsDto<UserIdentity>> CreateUserIdentity(UserIdentityDto userIdentityDto)
        {
            var user = await _redHouseDbContext.Users.FindAsync(userIdentityDto.UserId);
            if (user == null)
            {
                return new ResponsDto<UserIdentity>
                {
                    Exception = new Exception("User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            UserIdentity userIdentity = new UserIdentity
            {
                UserId = userIdentityDto.UserId,
                RequestDate = DateTime.Now,
                RequestStatus = userIdentityDto.RequestStatus,
            };


            var userIdentityRes = await _redHouseDbContext.UserIdentities.AddAsync(userIdentity);
            _redHouseDbContext.SaveChanges();


            foreach (var file in userIdentityDto.IdentityFiles)
            {
                IdentityFile identityFile = new IdentityFile
                {
                    IdentityUserId = userIdentityRes.Entity.Id,
                    DownloadUrls = file
                };
                var identityFileRes = await _redHouseDbContext.IdentityFiles.AddAsync(identityFile);
                _redHouseDbContext.SaveChanges();
            }

            return new ResponsDto<UserIdentity>
            {
                Dto = userIdentityRes.Entity,
                Message = "UserIdentity Created Successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }



        public async Task<ResponsDto<UserIdentity>> GetUserIdentity(int userIdentityId)
        {
            var userIdentity = await _redHouseDbContext.UserIdentities
                .Include(u => u.IdentityFiles)
                .Include(u => u.User)
                .FirstOrDefaultAsync(u => u.Id == userIdentityId);
            if (userIdentity == null)
            {
                return new ResponsDto<UserIdentity>
                {
                    Exception = new Exception("UserIdentity Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            return new ResponsDto<UserIdentity>
            {
                Dto = userIdentity,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<UserIdentity>> GetRequestsVerifyUserIdentities(SearchDto searchDto)
        {
            var totalItems = await _redHouseDbContext.UserIdentities.CountAsync();
            var totalPages = (int)Math.Ceiling((double)totalItems / (int)(searchDto.Limit));


            var userIdentities = await _redHouseDbContext.UserIdentities
            .Where(u => u.RequestStatus == "Pending")
            .Include(u => u.IdentityFiles)
            .Include(u => u.User)
            .Skip((int)((searchDto.Page - 1) * searchDto.Limit))
            .Take((int)searchDto.Limit)
            .ToArrayAsync();

            if (userIdentities == null || !userIdentities.Any())
            {
                return new ResponsDto<UserIdentity>
                {
                    Exception = new Exception("Contracts Not Found"),
                    StatusCode = HttpStatusCode.NotFound,
                };
            }

            return new ResponsDto<UserIdentity>
            {
                ListDto = userIdentities,
                Pagination = new Dtos.Pagination
                {
                    PageNumber = searchDto.Page,
                    PageSize = searchDto.Limit,
                    TotalRows = totalItems,
                    TotalPages = totalPages
                },
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<UserIdentity>> RejectUserIdentity(int userIdentityId)
        {
            var userIdentity = await _redHouseDbContext.UserIdentities.FindAsync(userIdentityId);
            if (userIdentity == null)
            {
                return new ResponsDto<UserIdentity>
                {
                    Exception = new Exception("UserIdentity Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            userIdentity.RequestStatus = "Rejected";
            _redHouseDbContext.Update(userIdentity);
            _redHouseDbContext.SaveChanges();


            return new ResponsDto<UserIdentity>
            {
                Message = "UserIdentity rejected successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<UserIdentity>> VerifyUserIdentity(int userIdentityId)
        {
            var userIdentity = await _redHouseDbContext.UserIdentities.FindAsync(userIdentityId);
            if (userIdentity == null)
            {
                return new ResponsDto<UserIdentity>
                {
                    Exception = new Exception("UserIdentity Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            userIdentity.RequestStatus = "Accepted";
            _redHouseDbContext.Update(userIdentity);
            _redHouseDbContext.SaveChanges();


            return new ResponsDto<UserIdentity>
            {
                Message = "UserIdentity Accepted successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }
    }
}
