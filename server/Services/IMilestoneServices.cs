using System;
using Cooking_School.Dtos;
using RedHouse_Server.Dtos.ContractDtos;
using RedHouse_Server.Dtos.MilestoneDtos;
using RedHouse_Server.Dtos.OfferDtos;
using RedHouse_Server.Models;
using server.Models;

namespace server.Services
{
    public interface IMilestoneServices
    {
        public Task<ResponsDto<Milestone>> CreateMilestone(MilestoneDto milestoneDto);
        public Task<ResponsDto<Milestone>> CreateMonthlyMilestone(int contractId);
        public Task<ResponsDto<Milestone>> GetAllMilestones();
        public Task<ResponsDto<Milestone>> GetAllMilestonesForContract(int contractId);
        public Task<ResponsDto<Milestone>> GetMilestone(int milestoneId);
        public Task<ResponsDto<Milestone>> DeleteMilestone(int contractId);
        public Task<ResponsDto<Milestone>> ApproveMilestone(int milestoneId);
        public Task<ResponsDto<Contract>> UpdateMilestone(UpdateMilestoneDto milestoneDto, int milestoneId);
    }
}
