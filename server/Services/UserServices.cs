using System;
using System.Net;
using Cooking_School.Dtos;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using RedHouse_Server.Models;
using server.Dtos.UpdateUserDto;
namespace server.Services
{
    public class UserServices : IUserServices
    {
        private UserManager<IdentityUser> _userManager;

        private RedHouseDbContext _redHouseDbContext;
        public UserServices(RedHouseDbContext refHouseDbContext)
        {
            _redHouseDbContext = refHouseDbContext;
        }

        public async Task<ResponsDto<User>> FilterAgents(SearchDto searchDto)
        {

            var query = _redHouseDbContext.Users.Where(u => u.UserRole == "Agent").Include(u => u.Location).AsQueryable();
            if (searchDto.SearchQuery != null)
                query = query.Where(u => u.Name.Contains(searchDto.SearchQuery));

            var users = await query.ToArrayAsync();

            if (users == null || !users.Any())
            {
                return new ResponsDto<User>
                {
                    Exception = new Exception("Users Not Found"),
                    StatusCode = HttpStatusCode.NotFound,
                };
            }

            return new ResponsDto<User>
            {
                ListDto = users,
                StatusCode = HttpStatusCode.OK,
            };
        }



        public async Task<ResponsDto<User>> FilterLawyers(SearchDto searchDto)
        {

            var query = _redHouseDbContext.Users.Where(u => u.UserRole == "Lawyer").Include(u => u.Location).AsQueryable();
            if (searchDto.SearchQuery != null)
                query = query.Where(u => u.Name.Contains(searchDto.SearchQuery));

            var users = await query.ToArrayAsync();

            if (users == null || !users.Any())
            {
                return new ResponsDto<User>
                {
                    Exception = new Exception("Users Not Found"),
                    StatusCode = HttpStatusCode.NotFound,
                };
            }

            return new ResponsDto<User>
            {
                ListDto = users,
                StatusCode = HttpStatusCode.OK,
            };
        }



        public async Task<ResponsDto<User>> FilterUsers(SearchDto searchDto)
        {
            searchDto.Page = searchDto.Page < 1 ? 1 : searchDto.Page;
            searchDto.Limit = searchDto.Limit < 1 ? 10 : searchDto.Limit;
            var query = _redHouseDbContext.Users.Include(u => u.Location).AsQueryable();
            if (searchDto.SearchQuery != null)
                query = query.Where(u => u.Name.Contains(searchDto.SearchQuery));
            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling((double)totalItems / (int)(searchDto.Limit));

            var users = await query
                .Skip((int)((searchDto.Page - 1) * searchDto.Limit))
                .Take((int)searchDto.Limit)
                .ToArrayAsync();

            if (users == null || !users.Any())
            {
                return new ResponsDto<User>
                {
                    Exception = new Exception("Users Not Found"),
                    StatusCode = HttpStatusCode.NotFound,
                };
            }

            return new ResponsDto<User>
            {
                ListDto = users,
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

        public async Task<ResponsDto<User>> UpdateUser(UpdateUserDto userDto, int userId)
        {
            var user = await _redHouseDbContext.Users.FindAsync(userId);
            if (user == null)
            {
                return new ResponsDto<User>
                {
                    Exception = new Exception($"User with {userId} Dose Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            if (userDto.Name != null)
            {
                user.Name = userDto.Name;
            }
            if (userDto.Email != null)
            {
                user.Email = userDto.Email;
            }
            if (userDto.PhoneNumber != null)
            {
                user.PhoneNumber = (int)userDto.PhoneNumber;
            }
            if (userDto.IsVerified != null)
            {
                user.IsVerified = (bool)userDto.IsVerified;
            }
            if (userDto.UserRole != null)
            {
                user.UserRole = userDto.UserRole;
            }
            if (userDto.CustomerScore != null)
            {
                user.CustomerScore = (int)userDto.CustomerScore;
            }
            if (userDto.LandlordScore != null)
            {
                user.LandlordScore = (int)userDto.LandlordScore;
            }

            _redHouseDbContext.Users.Update(user);
            _redHouseDbContext.SaveChanges();
            return new ResponsDto<User>
            {
                Message = $"User data with {userId} Id Updated succssfully",
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<List<int>> GetNumberOfUsersInLastTenYears()
        {
            var uersOfTheLastTenYears = _redHouseDbContext.Users.Where(a => (DateTime.Now.Year - a.Created.Year) < 10).ToArray();
            List<int> avgUsersNumberPerYearInLastTenYears = Enumerable.Repeat(0, 10).ToList();

            for (int i = 0; i < avgUsersNumberPerYearInLastTenYears.Count; i++)
            {
                int numberPerYear = avgUsersNumberPerYearInLastTenYears[i];

                List<User> usersInThisYear = uersOfTheLastTenYears.Where(o => o.Created.Year == (DateTime.Now.Year - i)).ToList();

                avgUsersNumberPerYearInLastTenYears[i] = usersInThisYear.Count();
            }

            avgUsersNumberPerYearInLastTenYears.Reverse();
            return avgUsersNumberPerYearInLastTenYears.ToList(); // Convert it back to a list
        }

        public async Task<ResponsDto<User>> GetUser(int userId)
        {
            var user = await _redHouseDbContext.Users.Where(u => u.Id == userId).Include(u => u.Location).FirstOrDefaultAsync();
            if (user == null)
            {
                return new ResponsDto<User>
                {
                    Exception = new Exception("User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            return new ResponsDto<User>
            {
                Dto = user,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<User>> GetUsersOfApprovedApplications(int userId)
        {
            var user = await _redHouseDbContext.Users.FindAsync(userId);
            if (user == null)
            {
                return new ResponsDto<User>
                {
                    Exception = new Exception("User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var applications = await _redHouseDbContext.Applications.Include(a => a.Property).AsQueryable()
                                    .Where(a => a.Property.UserId == userId && a.ApplicationStatus == "Approved").ToArrayAsync();
            List<User> users = new List<User>();

            foreach (var application in applications)
            {
                users.Add(await _redHouseDbContext.Users.FindAsync(application.UserId));
            }
            return new ResponsDto<User>
            {
                ListDto = users,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<int> NumberOfUsers()
        {
            return await _redHouseDbContext.Users.CountAsync();
        }


        public async Task<ResponsDto<User>> GetAllLawyersForUser(int userId)
        {
            var user = await _redHouseDbContext.Users.FindAsync(userId);
            if (user == null)
            {
                return new ResponsDto<User>
                {
                    Exception = new Exception("User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }




            var lawyers = from contract in _redHouseDbContext.Contracts
             .Include(c => c.Lawyer)
                          where (contract.Offer != null &&
                                 (contract.Offer.CustomerId == userId || contract.Offer.LandlordId == userId)) &&
                                 contract.Lawyer != null
                          select contract.Lawyer;



            return new ResponsDto<User>
            {
                ListDto = lawyers.Distinct().ToList(),
                StatusCode = HttpStatusCode.OK,
            };

        }

        public async Task<ResponsDto<User>> GetAllUsersForLawyer(int userId)
        {
            var user = await _redHouseDbContext.Users.FindAsync(userId);
            if (user == null)
            {
                return new ResponsDto<User>
                {
                    Exception = new Exception("User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }



            var landlords = from contract in _redHouseDbContext.Contracts
             .Include(c => c.Lawyer)
                            where (contract.Offer != null) &&
                                   contract.LawyerId == userId
                            select contract.Offer.Landlord;

            var customers = from contract in _redHouseDbContext.Contracts
            .Include(c => c.Lawyer)
                            where (contract.Offer != null) &&
                                   contract.LawyerId == userId
                            select contract.Offer.Customer;


            List<User> users = new List<User>();
            users.AddRange(customers);
            users.AddRange(landlords);


            return new ResponsDto<User>
            {
                ListDto = users.Distinct().ToList(),
                StatusCode = HttpStatusCode.OK,
            };

        }
    }
}
