using System;
using System.Net;
using Cooking_School.Dtos;
using Microsoft.EntityFrameworkCore;
using RedHouse_Server.Dtos.ContractDtos;
using RedHouse_Server.Dtos.MilestoneDtos;
using RedHouse_Server.Models;
using server.Models;

namespace server.Services
{
    public class MilestoneServices : IMilestoneServices
    {
        private RedHouseDbContext _redHouseDbContext;
        public MilestoneServices(RedHouseDbContext redHouseDbContext)
        {
            _redHouseDbContext = redHouseDbContext;
        }
        public async Task<ResponsDto<Milestone>> ApproveMilestone(int milestoneId)
        {
            var milestone = await _redHouseDbContext.Milestones.FindAsync(milestoneId);
            if (milestone == null)
            {
                return new ResponsDto<Milestone>
                {
                    Exception = new Exception("Offer Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            milestone.MilestoneStatus = "Paid";
            _redHouseDbContext.Milestones.Update(milestone);
            _redHouseDbContext.SaveChanges();


            return new ResponsDto<Milestone>
            {
                Dto = milestone,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Milestone>> CreateMilestone(MilestoneDto milestoneDto)
        {
            var contract = await _redHouseDbContext.Contracts.FindAsync(milestoneDto.ContractId);
            if (contract == null)
            {
                return new ResponsDto<Milestone>
                {
                    Exception = new Exception("Contract Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            Milestone milestone = new Milestone
            {
                ContractId = milestoneDto.ContractId,
                Description = milestoneDto.Description,
                Amount = milestoneDto.Amount,
                MilestoneDate = milestoneDto.MilestoneDate,
                MilestoneName = milestoneDto.MilestoneName,
                MilestoneStatus = milestoneDto.MilestoneStatus
            };
            var milestoneRes = await _redHouseDbContext.Milestones.AddAsync(milestone);
            _redHouseDbContext.SaveChanges();

            return new ResponsDto<Milestone>
            {
                Dto = milestoneRes.Entity,
                Message = "Milestone Created Successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Milestone>> CreateMonthlyMilestone(int contractId)
        {
            var contract = await _redHouseDbContext.Contracts
                .Include(c => c.Offer)
                .FirstOrDefaultAsync(c => c.Id == contractId);
            if (contract == null)
            {
                return new ResponsDto<Milestone>
                {
                    Exception = new Exception("Contract Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            // if (DateTime.Now.Day == contract.Offer.OfferDate.Day)
            // {

            Milestone milestone = new Milestone
            {
                ContractId = contractId,
                Description = contract.Offer.Description,
                Amount = contract.Offer.Price,
                MilestoneDate = contract.Offer.OfferDate,
                MilestoneName = "Monthly Bills",
                MilestoneStatus = "Pending"
            };
            var milestoneRes = await _redHouseDbContext.Milestones.AddAsync(milestone);
            _redHouseDbContext.SaveChanges();

            return new ResponsDto<Milestone>
            {
                Dto = milestoneRes.Entity,
                Message = "Milestone Created Successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Milestone>> DeleteMilestone(int contractId)
        {
            var milestone = await _redHouseDbContext.Milestones.FindAsync(contractId);
            if (milestone == null)
            {
                return new ResponsDto<Milestone>
                {
                    Exception = new Exception($"Milestone with {contractId} Dose Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            _redHouseDbContext.Milestones.Remove(milestone);
            _redHouseDbContext.SaveChanges();
            return new ResponsDto<Milestone>
            {
                Exception = new Exception($"Milestone with {contractId} Deleted succussfuly"),
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Milestone>> GetAllMilestones()
        {

            var milestons = await _redHouseDbContext.Milestones.ToArrayAsync();

            return new ResponsDto<Milestone>
            {
                ListDto = milestons,
                StatusCode = HttpStatusCode.OK,

            };
        }

        public async Task<ResponsDto<Milestone>> GetAllMilestonesForContract(int contractId)
        {
            var contract = await _redHouseDbContext.Contracts
                 .Include(c => c.Offer)
                 .FirstOrDefaultAsync(c => c.Id == contractId);
            if (contract == null)
            {
                return new ResponsDto<Milestone>
                {
                    Exception = new Exception("Contract Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var milestons = await _redHouseDbContext.Milestones.Where(m => m.ContractId == contractId).ToArrayAsync();

            return new ResponsDto<Milestone>
            {
                ListDto = milestons,
                StatusCode = HttpStatusCode.OK,

            };
        }

        public async Task<ResponsDto<Milestone>> GetMilestone(int milestoneId)
        {
            var mileston = await _redHouseDbContext.Milestones
                 .FirstOrDefaultAsync(c => c.Id == milestoneId);
            if (mileston == null)
            {
                return new ResponsDto<Milestone>
                {
                    Exception = new Exception("Milestone Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }


            return new ResponsDto<Milestone>
            {
                Dto = mileston,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Contract>> UpdateMilestone(UpdateMilestoneDto milestoneDto, int milestoneId)
        {
            var milestoneWithContractAndOffer = await _redHouseDbContext.Milestones
                .Join(
                    _redHouseDbContext.Contracts,
                    milestone => milestone.ContractId,
                    contract => contract.Id,
                    (milestone, contract) => new { Milestone = milestone, Contract = contract }
                )
                .Join(
                    _redHouseDbContext.Offers,
                    result => result.Contract.OfferId,
                    offer => offer.Id,
                    (result, offer) => new { Milestone = result.Milestone, Contract = result.Contract, Offer = offer }
                )
                .Where(joinResult => joinResult.Milestone.Id == milestoneId)
                .FirstOrDefaultAsync();

            var milestone = milestoneWithContractAndOffer.Milestone;
            var contract = milestoneWithContractAndOffer.Contract;
            var offer = milestoneWithContractAndOffer.Offer;

            if (milestone == null)
            {
                return new ResponsDto<Contract>
                {
                    Exception = new Exception("Milestone Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            if (milestoneDto.MilestoneDate != null)
            {
                milestone.MilestoneDate = (DateTime)milestoneDto.MilestoneDate;
            }

            if (milestoneDto.MilestoneName != null)
            {
                milestone.MilestoneName = milestoneDto.MilestoneName;
            }

            if (milestoneDto.Description != null)
            {
                milestone.Description = milestoneDto.Description;
            }

            if (milestoneDto.Amount != null)
            {
                milestone.Amount = (int)milestoneDto.Amount;
            }

            if (milestoneDto.MilestoneStatus != null)
            {
                if (milestoneDto.MilestoneStatus == "Paid")
                {
                    // Update Earnings of the associated Contract
                    contract.Earnings += (double)milestone.Amount;

                    // Check if Earnings of the Contract reach the Offer Price
                    if (contract.Earnings >= offer.Price)
                    {
                        contract.ContractStatus = "Closed";
                        contract.EndDate = DateTime.Now;
                    }
                }
                milestone.MilestoneStatus = milestoneDto.MilestoneStatus;
            }


            _redHouseDbContext.SaveChanges();
            return new ResponsDto<Contract>
            {
                Dto = contract,
                Message = "Milestone updated successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }


    }
}
