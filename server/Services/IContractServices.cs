using System;
using Cooking_School.Dtos;
using RedHouse_Server.Dtos.ContractDtos;
using RedHouse_Server.Models;

namespace server.Services
{
    public interface IContractServices
    {
        public Task<ResponsDto<Contract>> CreateContract(ContractDto contractDto);
        public Task<ResponsDto<Contract>> GetAllContracts();
        public Task<ResponsDto<Contract>> GetAllContractsForLawer(int userId, ContractFilter contractFilter);
        public Task<ResponsDto<Contract>> AddLawerToContract(int contractId, int lawerId);
        public Task<ResponsDto<Contract>> GetAllContractsForUser(int userId, ContractFilter contractFilter);
        public Task<ResponsDto<Contract>> GetContractForOffer(int offerId);
        public Task<ResponsDto<Contract>> GetContract(int contractId);
        public Task<ResponsDto<Contract>> DeleteContract(int contractId);
        public Task<ResponsDto<Contract>> UpdateContract(UpdateContractDto contractDto, int contractId);
        public Task<int> NumberOfContracts();
        public Task<ResponsDto<Contract>> FilterContracts(SearchDto searchDto);

    }
}
