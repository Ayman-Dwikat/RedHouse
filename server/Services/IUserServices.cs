using System;
using Cooking_School.Dtos;
using RedHouse_Server.Models;
using server.Dtos.UpdateUserDto;
namespace server.Services
{
    public interface IUserServices
    {
        public Task<ResponsDto<User>> GetAllLawyersForUser(int userId);
        public Task<ResponsDto<User>> GetAllUsersForLawyer(int userId);
        public Task<ResponsDto<User>> GetUsersOfApprovedApplications(int userId);
        public Task<int> NumberOfUsers();
        public Task<ResponsDto<User>> FilterAgents(SearchDto searchDto);
        public Task<ResponsDto<User>> FilterUsers(SearchDto searchDto);
        public Task<ResponsDto<User>> FilterLawyers(SearchDto searchDto);
        public Task<ResponsDto<User>> GetUser(int userId);
        public Task<ResponsDto<User>> UpdateUser(UpdateUserDto userDto, int userId);
        public Task<List<int>> GetNumberOfUsersInLastTenYears();
    }
}
