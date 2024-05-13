using System;
using Cooking_School.Dtos;
using RedHouse_Server.Dtos.ApplicationDtos;
using RedHouse_Server.Models;
using System.Net;
using Microsoft.EntityFrameworkCore;

namespace server.Services
{
    public class ApplicationServices : IApplicationServices
    {
        private RedHouseDbContext _redHouseDbContext;
        public ApplicationServices(RedHouseDbContext blueHouseDbContext)
        {
            _redHouseDbContext = blueHouseDbContext;
        }
        public async Task<ResponsDto<Application>> CreateApplication(ApplicationDto applicationDto)
        {
            var user = await _redHouseDbContext.Users.FindAsync(applicationDto.UserId);
            if (user == null)
            {
                return new ResponsDto<Application>
                {
                    Exception = new Exception("User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var property = await _redHouseDbContext.Properties.FindAsync(applicationDto.PropertyId);
            if (user == null)
            {
                return new ResponsDto<Application>
                {
                    Exception = new Exception("Property Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            var applications = await _redHouseDbContext.Applications.Where(o => o.UserId == applicationDto.UserId
                                                                                && o.PropertyId == applicationDto.PropertyId).ToArrayAsync();

            var searchedApplication = applications.FirstOrDefault();
            if (searchedApplication != null)
            {
                return new ResponsDto<Application>
                {
                    Exception = new Exception("You can't send more than one request for the same property"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }


            Application application = new Application
            {
                UserId = applicationDto.UserId,
                Message = applicationDto.Message,
                PropertyId = applicationDto.PropertyId,
                ApplicationDate = DateTime.Now,
                ApplicationStatus = "Pending",
                SuggestedPrice = applicationDto.SuggestedPrice,
            };
            var applicationRes = await _redHouseDbContext.Applications.AddAsync(application);
            await _redHouseDbContext.SaveChangesAsync();

            return new ResponsDto<Application>
            {
                Dto = applicationRes.Entity,
                Message = "Sent Successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Application>> GetApplication(int applicationId)
        {
            var property = await _redHouseDbContext.Properties.FindAsync(applicationId);
            if (property == null)
            {
                return new ResponsDto<Application>
                {
                    Exception = new Exception("Property Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var application = await _redHouseDbContext.Applications.FindAsync(applicationId);
            var user = await _redHouseDbContext.Users.FirstOrDefaultAsync(u => u.Id == application.UserId);

            application.User = user;
            application.Property = property;

            return new ResponsDto<Application>
            {
                Dto = application,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Application>> GetApplications(int userId, ApplicationFilter applicationFilter)
        {
            var user = await _redHouseDbContext.Users.FindAsync(userId);
            if (user == null)
            {
                return new ResponsDto<Application>
                {
                    Exception = new Exception("User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var query = _redHouseDbContext.Applications
                .Include(a => a.User)
                .Include(a => a.Property)
                .ThenInclude(p => p.Location)
                .Include(a => a.Property)
                .ThenInclude(p => p.User)
                .Include(a => a.Property)
                .ThenInclude(p => p.propertyFiles)
                .AsQueryable();


            if (applicationFilter.ApplicationTo.Trim() == "Landlord")
            {
                query = from p in _redHouseDbContext.Properties
                        join a in query on p.Id equals a.PropertyId
                        where p.UserId == userId
                        select a;
            }

            if (applicationFilter.ApplicationTo.Trim() == "Customer")
            {
                query = query.Where(a => a.UserId == userId);
            }

            if (applicationFilter.ApplicationType.Trim() != "All")
            {
                query = query.Where(a => a.Property.ListingType == applicationFilter.ApplicationType.Trim());
            }

            if (applicationFilter.ApplicationStatus.Trim() != "All")
            {
                query = query.Where(c => c.ApplicationStatus == applicationFilter.ApplicationStatus.Trim());
            }

            var applications = query.ToList();

            return new ResponsDto<Application>
            {
                ListDto = applications,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Application>> DeleteApplication(int applicationId)
        {
            var application = await _redHouseDbContext.Applications.FindAsync(applicationId);
            if (application == null)
            {
                return new ResponsDto<Application>
                {
                    Exception = new Exception($"Application with {applicationId} Dose Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            _redHouseDbContext.Applications.Remove(application);
            _redHouseDbContext.SaveChanges();
            return new ResponsDto<Application>
            {
                Exception = new Exception($"Application with {applicationId} Deleted succussfuly"),
                StatusCode = HttpStatusCode.OK,
            };
        }


        public async Task<ResponsDto<Application>> UpdateApplication(UpdateApplicationDto applicationDto, int applicationId)
        {
            var application = await _redHouseDbContext.Applications.FindAsync(applicationId);

            if (application == null)
            {
                return new ResponsDto<Application>
                {
                    Exception = new Exception($"Application with {applicationId} Does Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            if (applicationDto.ApplicationDate != null)
            {
                application.ApplicationDate = (DateTime)applicationDto.ApplicationDate;
            }

            if (applicationDto.ApplicationStatus != null)
            {
                application.ApplicationStatus = applicationDto.ApplicationStatus;
            }

            if (applicationDto.Message != null)
            {
                application.Message = applicationDto.Message;
            }

            if (applicationDto.PropertyId != null)
            {
                application.PropertyId = (int)applicationDto.PropertyId;
            }

            if (applicationDto.UserId != null)
            {
                application.UserId = (int)applicationDto.UserId;
            }

            _redHouseDbContext.SaveChanges();

            return new ResponsDto<Application>
            {
                Message = $"Application with {applicationId} Id Updated successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }


        public async Task<ResponsDto<Application>> ApproveApplication(int applicationId)
        {
            var application = await _redHouseDbContext.Applications.FindAsync(applicationId);
            if (application == null)
            {
                return new ResponsDto<Application>
                {
                    Exception = new Exception($"Application with {applicationId} Dose Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            application.ApplicationStatus = "Approved";
            _redHouseDbContext.Applications.Update(application);
            _redHouseDbContext.SaveChanges();
            return new ResponsDto<Application>
            {
                Dto = application,
                Exception = new Exception($"Application with {applicationId} Approved succussfuly"),
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Application>> IgnoreApplication(int applicationId)
        {
            var application = await _redHouseDbContext.Applications.FindAsync(applicationId);
            if (application == null)
            {
                return new ResponsDto<Application>
                {
                    Exception = new Exception($"Application with {applicationId} Dose Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            application.ApplicationStatus = "Ignored";
            _redHouseDbContext.Applications.Update(application);
            _redHouseDbContext.SaveChanges();
            return new ResponsDto<Application>
            {
                Dto = application,
                Exception = new Exception($"Application with {applicationId} Ignored succussfuly"),
                StatusCode = HttpStatusCode.OK,
            };
        }


        public async Task<ResponsDto<Application>> GetApprovedApplicationsForUser(int userId)
        {
            var user = await _redHouseDbContext.Users.FindAsync(userId);
            if (user == null)
            {
                return new ResponsDto<Application>
                {
                    Exception = new Exception("User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var customerApplications = await _redHouseDbContext.Applications
                .Include(a => a.User)
                .Include(a => a.Property)
                .ThenInclude(p => p.Location)
                .Include(a => a.Property)
                .ThenInclude(p => p.User)
                .Include(a => a.Property)
                .ThenInclude(p => p.propertyFiles)
                .AsQueryable()
                .Where(a => a.Property.UserId == userId && a.ApplicationStatus == "Approved")
                .ToArrayAsync();

            var landlordApplications = await _redHouseDbContext.Applications
                .Include(a => a.User)
                .Include(a => a.Property)
                .ThenInclude(p => p.Location)
                .Include(a => a.Property)
                .ThenInclude(p => p.User)
                .Include(a => a.Property)
                .ThenInclude(p => p.propertyFiles)
                .AsQueryable()
                .Where(a => a.ApplicationStatus == "Approved" && a.UserId == userId)
                .ToArrayAsync();

            List<Application> applications = new List<Application>();
            applications.AddRange(customerApplications);
            applications.AddRange(landlordApplications);


            return new ResponsDto<Application>
            {
                ListDto = applications.Distinct().ToList(),
                StatusCode = HttpStatusCode.OK,
            };

        }

        public async Task<int> NumberOfApplications()
        {
            return await _redHouseDbContext.Applications.CountAsync();

        }

        public Task<ResponsDto<Application>> RejectApplication(int applicationId)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponsDto<Application>> IsApplicationApproved(int propertyId, int userId)
        {
            var property = await _redHouseDbContext.Properties.FindAsync(propertyId);
            if (property == null)
            {
                return new ResponsDto<Application>
                {
                    Exception = new Exception($"property Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            var application = await _redHouseDbContext.Applications.FirstOrDefaultAsync(a => a.PropertyId == propertyId && a.UserId == userId);
            if (application.ApplicationStatus == "Approved")
            {
                return new ResponsDto<Application>
                {
                    Message = "Approved",
                    StatusCode = HttpStatusCode.OK,
                };
            }
            else
            {
                return new ResponsDto<Application>
                {
                    Message = "Rejected",
                    StatusCode = HttpStatusCode.OK,
                };
            }

        }

        public async Task<ResponsDto<Application>> IsApplicationCreated(int propertyId, int customerId)
        {
            var property = await _redHouseDbContext.Properties.FindAsync(propertyId);
            if (property == null)
            {
                return new ResponsDto<Application>
                {
                    Exception = new Exception($"property Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var customer = await _redHouseDbContext.Users.FindAsync(customerId);
            if (customer == null)
            {
                return new ResponsDto<Application>
                {
                    Exception = new Exception($"User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var applications = await _redHouseDbContext.Applications.FirstOrDefaultAsync(a => a.PropertyId == propertyId && a.UserId == customerId);

            var query = _redHouseDbContext.Applications
                .Include(a => a.User)
                .Include(a => a.Property)
                .ThenInclude(p => p.Location)
                .Include(a => a.Property)
                .ThenInclude(p => p.User)
                .Include(a => a.Property)
                .ThenInclude(p => p.propertyFiles)
                .AsQueryable();

            var application = await _redHouseDbContext.Applications
            .Include(a => a.User)
            .Include(a => a.Property)
            .ThenInclude(p => p.Location)
            .Include(a => a.Property)
            .ThenInclude(p => p.User)
            .Include(a => a.Property)
           .ThenInclude(p => p.propertyFiles).FirstOrDefaultAsync(o => o.PropertyId == propertyId && o.UserId == customerId);

            if (application == null)
            {
                return new ResponsDto<Application>
                {
                    Message = "Not Created",
                    Dto = null,
                    StatusCode = HttpStatusCode.OK,
                };
            }
            else
            {
                return new ResponsDto<Application>
                {
                    Message = "Created",
                    Dto = application,
                    StatusCode = HttpStatusCode.OK,
                };
            }

        }
    }



}