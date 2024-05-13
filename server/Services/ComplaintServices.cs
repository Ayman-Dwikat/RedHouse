using System;
using System.Net;
using Cooking_School.Dtos;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RedHouse_Server.Dtos.ComplainDtos;
using RedHouse_Server.Dtos.ContractDtos;
using RedHouse_Server.Models;
using server.Dtos;
using server.Models;

namespace server.Services
{
    public class ComplaintServices : IComplaintServices
    {
        private RedHouseDbContext _redHouseDbContext;
        public ComplaintServices(RedHouseDbContext blueHouseDbContext)
        {
            _redHouseDbContext = blueHouseDbContext;
        }

        public async Task<ResponsDto<Complaint>> CreateComplain(ComplaintDto complainDto)
        {
            var customer = await _redHouseDbContext.Users.FindAsync(complainDto.UserId);
            if (customer == null)
            {
                return new ResponsDto<Complaint>
                {
                    Exception = new Exception("User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            Complaint complain = new Complaint
            {
                UserId = complainDto.UserId,
                Description = complainDto.Description,
                ComplainDate = DateTime.Now,
            };
            var offerRes = await _redHouseDbContext.Complaints.AddAsync(complain);
            _redHouseDbContext.SaveChanges();

            return new ResponsDto<Complaint>
            {
                Dto = offerRes.Entity,
                Message = "Complain Created Successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Complaint>> GetComplain(int complainId)
        {
            var complain = await _redHouseDbContext.Complaints.FindAsync(complainId);
            if (complain == null)
            {
                return new ResponsDto<Complaint>
                {
                    Exception = new Exception("Complain Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            return new ResponsDto<Complaint>
            {
                Dto = complain,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Complaint>> GetComplaints(int userId)
        {
            var user = await _redHouseDbContext.Users.FindAsync(userId);
            if (user == null)
            {
                return new ResponsDto<Complaint>
                {
                    Exception = new Exception($"User with {userId} Id Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            // Define a separate method without optional arguments

            var complains = await _redHouseDbContext.Complaints.Where(c => c.UserId == userId).ToArrayAsync();

            return new ResponsDto<Complaint>
            {
                ListDto = complains,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<IActionResult> GetComplaintsForDay(DateTime day)
        {
            var complaints = await _redHouseDbContext.Complaints.Include(c => c.User).Where(x => x.ComplainDate.Date == day.Date).ToArrayAsync();

            return new ObjectResult(new
            {
                ListDto = complaints,
                StatusCode = HttpStatusCode.OK,
            });

        }

        public async Task<IActionResult> GetNumberOfComplaintsPerDay(SearchDto searchDto)
        {
            searchDto.Page = searchDto.Page < 1 ? 1 : searchDto.Page;
            searchDto.Limit = searchDto.Limit < 1 ? 10 : searchDto.Limit;

            var query = _redHouseDbContext.Complaints.Include(c => c.User)
                .GroupBy(c => c.ComplainDate.Date)
                .AsQueryable();


            var complaintsGroups = query
                .Select(group => new
                {
                    ComplainDate = group.Key,
                    Complaints = group.ToArray().Length
                })
                .Skip((int)((searchDto.Page - 1) * searchDto.Limit))
                .Take((int)(searchDto.Limit))
                .ToArray();
            var totalItems = await query.CountAsync();

            var totalPages = (int)Math.Ceiling((double)totalItems / (int)(searchDto.Limit));

            if (complaintsGroups == null || !complaintsGroups.Any())
            {
                return new ObjectResult(new
                {
                    Exception = new Exception("Complaints Not Found"),
                    StatusCode = HttpStatusCode.NotFound,
                })
                {
                    StatusCode = (int)HttpStatusCode.NotFound,
                };
            }

            return new ObjectResult(new
            {
                ListDto = complaintsGroups.Reverse(),
                Pagination = new Pagination
                {
                    PageNumber = searchDto.Page,
                    PageSize = searchDto.Limit,
                    TotalRows = totalItems,
                    TotalPages = totalPages
                },
                StatusCode = HttpStatusCode.OK,
            });
        }


    }
}
