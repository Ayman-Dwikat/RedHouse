using System;
using Cooking_School.Dtos;
using RedHouse_Server.Dtos.ApplicationDtos;
using RedHouse_Server.Models;

namespace server.Services
{
    public interface IApplicationServices
    {
        public Task<ResponsDto<Application>> GetApprovedApplicationsForUser(int userId);
        public Task<ResponsDto<Application>> CreateApplication(ApplicationDto applicationDto);
        public Task<ResponsDto<Application>> GetApplications(int userId, ApplicationFilter applicationFilter);
        public Task<ResponsDto<Application>> GetApplication(int applicationId);
        public Task<ResponsDto<Application>> DeleteApplication(int applicationId);
        public Task<ResponsDto<Application>> UpdateApplication(UpdateApplicationDto applicationDto, int applicationId);
        public Task<ResponsDto<Application>> ApproveApplication(int applicationId);
        public Task<ResponsDto<Application>> IgnoreApplication(int applicationId);
        public Task<ResponsDto<Application>> IsApplicationApproved(int propertyId, int userId);

        public Task<int> NumberOfApplications();

        public Task<ResponsDto<Application>> IsApplicationCreated(int propertyId, int customerId);
    }
}
