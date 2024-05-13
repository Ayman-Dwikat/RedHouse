using System;
using Cooking_School.Dtos;
using RedHouse_Server.Dtos.UserHistoryDtos;
using server.Dtos.UserHistoryDtos;
using server.Models;

namespace server.Services
{
    public interface IUserHistoryServices
    {
        public Task<ResponsDto<UserHistory>> CreateUserHistory(CreateUserHistoryDto createHistoryDto);
        public Task<ResponsDto<UserHistory>> GetUserHistory(int userId);
        public Task<ResponsDto<UserHistory>> GetPropertyHistory(int propertyId);

        public Task<ResponsDto<UserHistory>> DeleteUserHistory(int userId);
        public Task<ResponsDto<UserHistory>> UpdateUserHistory(UserHistoryDto userHistoryDto, int userId);
    }
}
