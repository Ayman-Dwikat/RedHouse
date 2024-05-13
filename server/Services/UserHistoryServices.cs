using System;
using System.Net;
using Cooking_School.Dtos;
using Microsoft.EntityFrameworkCore;
using RedHouse_Server.Dtos.UserHistoryDtos;
using RedHouse_Server.Models;
using server.Dtos.UserHistoryDtos;
using server.Models;

namespace server.Services
{
    public class UserHistoryServices : IUserHistoryServices
    {
        private RedHouseDbContext _redHouseDbContext;
        public UserHistoryServices(RedHouseDbContext blueHouseDbContext)
        {
            _redHouseDbContext = blueHouseDbContext;
        }
        public async Task<ResponsDto<UserHistory>> CreateUserHistory(CreateUserHistoryDto createHistoryDto)
        {
            var contract = await _redHouseDbContext.Contracts.Include(c => c.Offer).FirstOrDefaultAsync(c => c.Id == createHistoryDto.ContractId);
            if (contract == null)
            {
                return new ResponsDto<UserHistory>
                {
                    Exception = new Exception("You can't send feedback"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            var userHistory = await _redHouseDbContext.UserHistoryRecords.FirstOrDefaultAsync(h => h.ContractId == createHistoryDto.ContractId);
            if (userHistory == null)
            {
                UserHistory newUserHistory = new UserHistory
                {
                    ContractId = contract.Id,
                    FeedbackToLandlord = createHistoryDto.userId == contract.Offer.LandlordId ? createHistoryDto.Feedback : null,
                    FeedbackToCustomer = createHistoryDto.userId == contract.Offer.CustomerId ? createHistoryDto.Feedback : null,
                    LandlordRating = createHistoryDto.userId == contract.Offer.LandlordId ? createHistoryDto.Rating : null,
                    CustomerRating = createHistoryDto.userId == contract.Offer.CustomerId ? createHistoryDto.Rating : null,
                };
                _redHouseDbContext.UserHistoryRecords.Add(newUserHistory);
                await _redHouseDbContext.SaveChangesAsync();
                return new ResponsDto<UserHistory>
                {
                    Message = "Done",
                    StatusCode = HttpStatusCode.OK,
                };
            }

            UserHistory updatedUserHistory = new UserHistory
            {
                ContractId = contract.Id,
                FeedbackToLandlord = createHistoryDto.userId == contract.Offer.LandlordId ? createHistoryDto.Feedback : null,
                FeedbackToCustomer = createHistoryDto.userId == contract.Offer.CustomerId ? createHistoryDto.Feedback : null,
                LandlordRating = createHistoryDto.userId == contract.Offer.LandlordId ? createHistoryDto.Rating : null,
                CustomerRating = createHistoryDto.userId == contract.Offer.CustomerId ? createHistoryDto.Rating : null,
            };
            var userHistories = _redHouseDbContext.UserHistoryRecords.Update(updatedUserHistory);
            await _redHouseDbContext.SaveChangesAsync();
            return new ResponsDto<UserHistory>
            {
                Message = "Done",
                StatusCode = HttpStatusCode.OK,
            };
        }

        public Task<ResponsDto<UserHistory>> DeleteUserHistory(int userId)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponsDto<UserHistory>> GetUserHistory(int userId)
        {
            var user = await _redHouseDbContext.Users.FindAsync(userId);
            if (user == null)
            {
                return new ResponsDto<UserHistory>
                {
                    Exception = new Exception("User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }



            var contracts = _redHouseDbContext.Contracts
            .Where(c => c.Offer.CustomerId == userId || c.Offer.LandlordId == userId)
            .Include(c => c.Offer.Property).ThenInclude(p => p.Location)
            .Include(p => p.Offer.Property.propertyFiles)
            .Include(c => c.Offer.Landlord)
            .Include(c => c.Offer.Customer)
            .ToList();

            var userHistories = _redHouseDbContext.UserHistoryRecords
                .ToList().Join(
                    contracts,
                    uh => uh.ContractId,
                    c => c.Id,
                    (uh, c) => new UserHistory
                    {
                        Id = uh.Id,
                        ContractId = uh.ContractId,
                        FeedbackToLandlord = uh.FeedbackToLandlord,
                        FeedbackToCustomer = uh.FeedbackToCustomer,
                        CustomerRating = uh.CustomerRating,
                        LandlordRating = uh.LandlordRating,
                        Contract = c
                    }
                )
                .ToList();


            return new ResponsDto<UserHistory>
            {
                ListDto = userHistories,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public Task<ResponsDto<UserHistory>> UpdateUserHistory(UserHistoryDto userHistoryDto, int userId)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponsDto<UserHistory>> GetPropertyHistory(int propertyId)
        {

            var property = await _redHouseDbContext.Properties.FindAsync(propertyId);
            if (property == null)
            {
                return new ResponsDto<UserHistory>
                {
                    Message = $"Property with {propertyId} Id Dose Not Exist",
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }


            var contracts = _redHouseDbContext.Contracts
                .Where(c => c.Offer.PropertyId == propertyId)
                .Include(c => c.Offer.Property) // Include the Property navigation property
                .Include(c => c.Offer.Landlord) // Include the Landlord navigation property
                .Include(c => c.Offer.Customer) // Include the Customer navigation property
                .ToList();

            var userHistories = _redHouseDbContext.UserHistoryRecords
                .ToList()
                .Join(
                    contracts,
                    uh => uh.ContractId,
                    c => c.Id,
                    (uh, c) => new UserHistory
                    {
                        Id = uh.Id,
                        ContractId = uh.ContractId,
                        FeedbackToLandlord = uh.FeedbackToLandlord,
                        FeedbackToCustomer = uh.FeedbackToCustomer,
                        CustomerRating = uh.CustomerRating,
                        LandlordRating = uh.LandlordRating,
                        Contract = c
                    }
                )
                .ToList();

            return new ResponsDto<UserHistory>
            {
                ListDto = userHistories,
                StatusCode = HttpStatusCode.OK,
            };
        }
    }
}
