using System;
using Cooking_School.Dtos;
using RedHouse_Server.Dtos.ApplicationDtos;
using RedHouse_Server.Dtos.ComplainDtos;
using RedHouse_Server.Models;
using server.Models;

namespace server.Services
{
    public interface IUserIdentityServices
    {
        public Task<ResponsDto<UserIdentity>> CreateUserIdentity(UserIdentityDto userIdentityDto);
        public Task<ResponsDto<UserIdentity>> GetRequestsVerifyUserIdentities(SearchDto searchDto);
        public Task<ResponsDto<UserIdentity>> GetUserIdentity(int userIdentityId);
        public Task<ResponsDto<UserIdentity>> VerifyUserIdentity(int userIdentityId);
        public Task<ResponsDto<UserIdentity>> RejectUserIdentity(int userIdentityId);
    }
}
