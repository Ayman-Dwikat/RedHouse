using System;
using System.Net;
using Cooking_School.Dtos;
using Microsoft.EntityFrameworkCore;
using RedHouse_Server.Dtos.ContractDtos;
using RedHouse_Server.Models;

namespace server.Services
{
    public class ContractServices : IContractServices
    {
        private RedHouseDbContext _redHouseDbContext;
        public ContractServices(RedHouseDbContext blueHouseDbContext)
        {
            _redHouseDbContext = blueHouseDbContext;
        }
        public Task<ResponsDto<Contract>> CreateContract(ContractDto contractDto)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponsDto<Contract>> DeleteContract(int contractId)
        {
            var contract = await _redHouseDbContext.Contracts.FindAsync(contractId);

            if (contract == null)
            {
                return new ResponsDto<Contract>
                {
                    Exception = new Exception($"Contract with {contractId} Does Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            _redHouseDbContext.Contracts.Remove(contract);
            _redHouseDbContext.SaveChanges();

            return new ResponsDto<Contract>
            {
                Exception = new Exception($"Contract with {contractId} Deleted successfully"),
                StatusCode = HttpStatusCode.OK,
            };
        }


        public Task<ResponsDto<Contract>> GetAllContracts()
        {
            throw new NotImplementedException();
        }

        public async Task<ResponsDto<Contract>> GetAllContractsForUser(int userId, ContractFilter contractFilter)
        {
            var query = _redHouseDbContext.Contracts.Include(c => c.Lawyer).Include(c => c.Offer.Landlord).Include(c => c.Offer.Customer).Include(c => c.Offer.Property).Include(c => c.Offer.Property.User).Include(c => c.Offer.Property.propertyFiles).Include(c => c.Offer.Property.Location).AsQueryable();

            if (contractFilter.ContractTo.Trim() == "Landlord")
            {
                query = query.Where(c => c.Offer.LandlordId == userId);
            }
            if (contractFilter.ContractTo.Trim() == "Customer")
            {
                query = query.Where(c => c.Offer.CustomerId == userId);
            }
            if (contractFilter.ContractType.Trim() != "All")
            {
                query = query.Where(c => c.ContractType == contractFilter.ContractType.Trim());
            }
            if (contractFilter.ContractStatus.Trim() != "All")
            {
                query = query.Where(c => c.ContractStatus == contractFilter.ContractStatus.Trim());
            }
            var contracts = query.ToArray();

            return new ResponsDto<Contract>
            {
                ListDto = contracts,
                StatusCode = HttpStatusCode.OK,
            };
        }


        public async Task<ResponsDto<Contract>> GetContract(int contractId)
        {
            var contract = await _redHouseDbContext.Contracts
                .Include(c => c.Offer)
                .FirstOrDefaultAsync(c => c.Id == contractId);
            if (contract == null)
            {
                return new ResponsDto<Contract>
                {
                    Exception = new Exception("Contract Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            return new ResponsDto<Contract>
            {
                Dto = contract,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<int> NumberOfContracts()
        {
            return await _redHouseDbContext.Contracts.CountAsync();
        }

        public async Task<ResponsDto<Contract>> UpdateContract(UpdateContractDto contractDto, int contractId)
        {
            var contract = await _redHouseDbContext.Contracts
                .FirstOrDefaultAsync(c => c.Id == contractId);

            if (contract == null)
            {
                return new ResponsDto<Contract>
                {
                    Exception = new Exception("Contract Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            if (contractDto.ContractStatus != null)
            {
                contract.ContractStatus = contractDto.ContractStatus;
            }

            if (contractDto.Earnings != null)
            {
                contract.Earnings = (double)contractDto.Earnings;
            }

            if (contractDto.IsShouldPay != null)
            {
                contract.IsShouldPay = (int)contractDto.IsShouldPay;
            }

            _redHouseDbContext.SaveChanges();

            return new ResponsDto<Contract>
            {
                Dto = contract,
                Message = "Contract updated successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }


        public async Task<ResponsDto<Contract>> FilterContracts(SearchDto searchDto)
        {
            searchDto.Page = searchDto.Page < 1 ? 1 : searchDto.Page;
            searchDto.Limit = searchDto.Limit < 1 ? 10 : searchDto.Limit;
            var query = _redHouseDbContext.Contracts.Include(u => u.Milestones)
                                                    .Include(u => u.Offer)
                                                    .Include(o => o.Offer.Property)
                                                    .Include(o => o.Offer.Landlord)
                                                    .Include(o => o.Offer.Customer).AsQueryable();
            if (searchDto.SearchQuery != null)
                query = query.Where(p => p.Offer.PropertyId == int.Parse(searchDto.SearchQuery)
                                    || p.Offer.LandlordId == int.Parse(searchDto.SearchQuery)
                                    || p.Offer.CustomerId == int.Parse(searchDto.SearchQuery));

            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling((double)totalItems / (int)(searchDto.Limit));

            var contracts = await query
                .Skip((int)((searchDto.Page - 1) * searchDto.Limit))
                .Take((int)searchDto.Limit)
                .ToArrayAsync();

            if (contracts == null || !contracts.Any())
            {
                return new ResponsDto<Contract>
                {
                    Exception = new Exception("Contracts Not Found"),
                    StatusCode = HttpStatusCode.NotFound,
                };
            }

            return new ResponsDto<Contract>
            {
                ListDto = contracts,
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

        public async Task<ResponsDto<Contract>> GetContractForOffer(int offerId)
        {
            var offer = await _redHouseDbContext.Offers.Include(o => o.Customer)
                                            .Include(o => o.Landlord)
                                            .Include(o => o.UserCreated)
                                            .Include(a => a.Property)
                                            .ThenInclude(p => p.Location)
                                            .Include(a => a.Property)
                                            .ThenInclude(p => p.User)
                                            .Include(a => a.Property)
                                            .ThenInclude(p => p.propertyFiles)
                                           .FirstOrDefaultAsync(o => o.Id == offerId);

            if (offer == null)
            {
                return new ResponsDto<Contract>
                {
                    Exception = new Exception($"Offer Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var contract = await _redHouseDbContext.Contracts.Include(o => o.Milestones).Include(o => o.ContractActivities).FirstOrDefaultAsync(o => o.OfferId == offerId);

            if (contract == null)
            {
                return new ResponsDto<Contract>
                {
                    Message = "Not Created",
                    Dto = null,
                    StatusCode = HttpStatusCode.OK,
                };
            }
            else
            {
                return new ResponsDto<Contract>
                {
                    Message = "Created",
                    Dto = contract,
                    StatusCode = HttpStatusCode.OK,
                };
            }
        }

        public async Task<ResponsDto<Contract>> GetAllContractsForLawer(int userId, ContractFilter contractFilter)
        {
            var user = await _redHouseDbContext.Users.FindAsync(userId);
            if (user == null)
            {
                return new ResponsDto<Contract>
                {
                    Exception = new Exception($"User with {userId} Does Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var query = _redHouseDbContext.Contracts
                .Include(c => c.Lawyer)
                .Include(c => c.Offer)
                .Include(c => c.Offer.Landlord)
                .Include(c => c.Offer.Customer)
                .Include(c => c.Offer.Property)
                .Include(c => c.Offer.Property.User)
                .Include(c => c.Offer.Property.propertyFiles)
                .Include(c => c.Offer.Property.Location)
                .Where(c => c.LawyerId == userId)
                .AsQueryable();

            // Apply filters directly on the query
            if (contractFilter.ContractType.Trim() != "All")
            {
                query = query.Where(c => c.ContractType == contractFilter.ContractType.Trim());
            }

            if (contractFilter.ContractStatus.Trim() != "All")
            {
                query = query.Where(c => c.ContractStatus == contractFilter.ContractStatus.Trim());
            }

            var contracts = await query.ToArrayAsync();

            return new ResponsDto<Contract>
            {
                ListDto = contracts,
                StatusCode = HttpStatusCode.OK,
            };
        }


        public async Task<ResponsDto<Contract>> AddLawerToContract(int contractId, int lawerId)
        {
            var contract = await _redHouseDbContext.Contracts.FindAsync(contractId);
            if (contract == null)
            {
                return new ResponsDto<Contract>
                {
                    Exception = new Exception($"Contract with {contractId} Dose Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            if (lawerId == 0)
            {
                contract.LawyerId = null;
                _redHouseDbContext.Contracts.Update(contract);
                await _redHouseDbContext.SaveChangesAsync();

                return new ResponsDto<Contract>
                {
                    Message = "Lawyer deleted successfully",
                    StatusCode = HttpStatusCode.OK,
                };
            }

            var user = await _redHouseDbContext.Users.FindAsync(lawerId);
            if (user == null)
            {
                return new ResponsDto<Contract>
                {
                    Exception = new Exception($"User with {lawerId} Dose Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            contract.LawyerId = lawerId;
            _redHouseDbContext.Contracts.Update(contract);
            await _redHouseDbContext.SaveChangesAsync();
            return new ResponsDto<Contract>
            {
                Message = "Lawer added successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }

        //         public async Task<ResponsDto<Contract>> AddLawerToContract(int contractId, int lawerId)
        // {
        //     if (lawerId == 0)
        //     {
        //         var contract = await _redHouseDbContext.Contracts.FindAsync(contractId);
        //         if (contract == null)
        //         {
        //             return new ResponsDto<Contract>
        //             {
        //                 Exception = new Exception($"Contract with {contractId} Does Not Exist"),
        //                 StatusCode = HttpStatusCode.BadRequest,
        //             };
        //         }

        //         contract.LawyerId = null;
        //         _redHouseDbContext.Contracts.Update(contract);
        //         await _redHouseDbContext.SaveChangesAsync();

        //         return new ResponsDto<Contract>
        //         {
        //             Message = "Lawyer added successfully",
        //             StatusCode = HttpStatusCode.OK,
        //         };
        //     }

        //     var user = await _redHouseDbContext.Users.FindAsync(lawerId);
        //     if (user == null)
        //     {
        //         return new ResponsDto<Contract>
        //         {
        //             Exception = new Exception($"User with {lawerId} Does Not Exist"),
        //             StatusCode = HttpStatusCode.BadRequest,
        //         };
        //     }

        //     var contractWithSameLawyer = await _redHouseDbContext.Contracts.FirstOrDefaultAsync(c => c.LawyerId == lawerId);
        //     if (contractWithSameLawyer != null)
        //     {
        //         return new ResponsDto<Contract>
        //         {
        //             Exception = new Exception($"User with ID {lawerId} is already associated with another contract"),
        //             StatusCode = HttpStatusCode.BadRequest,
        //         };
        //     }

        //     var contract = await _redHouseDbContext.Contracts.FindAsync(contractId);
        //     if (contract == null)
        //     {
        //         return new ResponsDto<Contract>
        //         {
        //             Exception = new Exception($"Contract with {contractId} Does Not Exist"),
        //             StatusCode = HttpStatusCode.BadRequest,
        //         };
        //     }

        //     contract.LawyerId = lawerId;
        //     _redHouseDbContext.Contracts.Update(contract);
        //     await _redHouseDbContext.SaveChangesAsync();

        //     return new ResponsDto<Contract>
        //     {
        //         Message = "Lawyer added successfully",
        //         StatusCode = HttpStatusCode.OK,
        //     };
        // }

    }
}
