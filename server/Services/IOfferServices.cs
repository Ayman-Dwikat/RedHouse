using System;
using Cooking_School.Dtos;
using RedHouse_Server.Dtos.ContractDtos;
using RedHouse_Server.Dtos.OfferDtos;
using RedHouse_Server.Models;
using server.Models;

namespace server.Services
{
    public interface IOfferServices
    {
        public Task<ResponsDto<Offer>> CreateOffer(OfferDto offerDto);
        public Task<ResponsDto<Offer>> GetAllOffers();
        public Task<ResponsDto<Offer>> GetAllOffersForUser(int userId, OfferFilter offerFilter);
        public Task<ResponsDto<Offer>> GetOfferFor(int offerId);
        public Task<ResponsDto<Offer>> DeleteOffer(int offerId);
        public Task<ResponsDto<Offer>> UpdateOffer(UpdateOfferDto offerDto, int offerId);
        public Task<ResponsDto<Offer>> GetOffer(int propertyId, int landlordId, int customerId);
        public Task<ResponsDto<Contract>> AcceptOffer(int offerId);
        public Task<int> NumberOfOffers();


    }
}
