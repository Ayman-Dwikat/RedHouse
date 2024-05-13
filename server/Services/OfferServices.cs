using System;
using System.Net;
using Cooking_School.Dtos;
using Microsoft.EntityFrameworkCore;
using RedHouse_Server.Dtos.ContractDtos;
using RedHouse_Server.Dtos.OfferDtos;
using RedHouse_Server.Models;
using server.Models;

namespace server.Services
{
    public class OfferServices : IOfferServices
    {
        private RedHouseDbContext _redHouseDbContext;
        public OfferServices(RedHouseDbContext redHouseDbContext)
        {
            _redHouseDbContext = redHouseDbContext;
        }

        public async Task<ResponsDto<Contract>> AcceptOffer(int offerId)
        {
            var offer = await _redHouseDbContext.Offers.FindAsync(offerId);
            if (offer == null)
            {
                return new ResponsDto<Contract>
                {
                    Exception = new Exception("Offer Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            offer.OfferStatus = "Accepted";
            var property = await _redHouseDbContext.Properties.FindAsync(offer.PropertyId);

            _redHouseDbContext.Offers.Update(offer);
            _redHouseDbContext.SaveChanges();
            Contract contract = new Contract
            {
                OfferId = offer.Id,
                ContractStatus = "Active",
                ContractType = property.ListingType,
                Earnings = 0,
                IsShouldPay = 1,
                StartDate = DateTime.Now,
            };

            var contractRes = await _redHouseDbContext.Contracts.AddAsync(contract);
            _redHouseDbContext.SaveChanges();

            Milestone milestone = new Milestone
            {
                ContractId = contractRes.Entity.Id,
                Description = contract.Offer.Description,
                Amount = contract.Offer.Price,
                MilestoneDate = contract.StartDate,
                MilestoneName = contract.ContractType == "For rent" ? "Monthly Bills" : "Total Price",
                MilestoneStatus = "Pending"
            };


            User customer = await _redHouseDbContext.Users.FindAsync(offer.CustomerId);
            User landlord = await _redHouseDbContext.Users.FindAsync(offer.LandlordId);

            customer.CustomerScore++;
            landlord.LandlordScore++;

            if (customer.UserRole != "Agent" && customer.CustomerScore >= 5 && customer.LandlordScore >= 5)
            {
                customer.UserRole = "Agent";
            }
            else if (customer.UserRole != "Customer" && customer.CustomerScore >= 5 && customer.LandlordScore < 5)
            {
                customer.UserRole = "Customer";
            }
            else if (customer.UserRole != "Landlord" && customer.CustomerScore < 5 && customer.LandlordScore >= 5)
            {
                customer.UserRole = "Landlord";
            }
            _redHouseDbContext.Users.Update(customer);
            _redHouseDbContext.SaveChanges();

            if (landlord.UserRole != "Agent" && landlord.CustomerScore >= 5 && landlord.LandlordScore >= 5)
            {
                landlord.UserRole = "Agent";
            }
            else if (landlord.UserRole != "Customer" && landlord.CustomerScore >= 5 && landlord.LandlordScore < 5)
            {
                landlord.UserRole = "Customer";
            }
            else if (landlord.UserRole != "Landlord" && landlord.CustomerScore < 5 && landlord.LandlordScore >= 5)
            {
                landlord.UserRole = "Landlord";
            }
            _redHouseDbContext.Users.Update(landlord);
            _redHouseDbContext.SaveChanges();


            var milestoneRes = await _redHouseDbContext.Milestones.AddAsync(milestone);
            _redHouseDbContext.SaveChanges();

            return new ResponsDto<Contract>
            {
                Dto = contractRes.Entity,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Offer>> CreateOffer(OfferDto offerDto)
        {
            var customer = await _redHouseDbContext.Users.FindAsync(offerDto.CustomerId);
            if (customer == null)
            {
                return new ResponsDto<Offer>
                {
                    Exception = new Exception("Customer Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var landlord = await _redHouseDbContext.Users.FindAsync(offerDto.LandlordId);
            if (landlord == null)
            {
                return new ResponsDto<Offer>
                {
                    Exception = new Exception("Landlord Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var offers = await _redHouseDbContext.Offers.Where(o => o.CustomerId == offerDto.CustomerId
                                                                    && o.LandlordId == offerDto.LandlordId
                                                                    && o.PropertyId == offerDto.PropertyId).ToArrayAsync();
            var searchedOffer = offers.FirstOrDefault();
            if (searchedOffer != null)
            {
                return new ResponsDto<Offer>
                {
                    Exception = new Exception("You can't create more than one offer for the same application"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }


            Offer offer = new Offer
            {
                CustomerId = offerDto.CustomerId,
                LandlordId = offerDto.LandlordId,
                PropertyId = offerDto.PropertyId,
                UserCreatedId = offerDto.UserCreatedId,
                Description = offerDto.Description!,
                OfferDate = DateTime.Now,
                OfferExpires = offerDto.OfferExpires,
                OfferStatus = offerDto.OfferStatus,
                Price = offerDto.Price,
            };
            var offerRes = await _redHouseDbContext.Offers.AddAsync(offer);
            _redHouseDbContext.SaveChanges();

            return new ResponsDto<Offer>
            {
                Dto = offerRes.Entity,
                Message = "Created Successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Offer>> DeleteOffer(int offerId)
        {
            var offer = await _redHouseDbContext.Offers.FindAsync(offerId);
            if (offer == null)
            {
                return new ResponsDto<Offer>
                {
                    Exception = new Exception($"Offer with {offerId} Does Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            _redHouseDbContext.Offers.Remove(offer);
            _redHouseDbContext.SaveChanges();

            return new ResponsDto<Offer>
            {
                Exception = new Exception($"Offer with {offerId} Deleted successfully"),
                StatusCode = HttpStatusCode.OK,
            };
        }


        public async Task<ResponsDto<Offer>> GetAllOffers()
        {
            var offers = await _redHouseDbContext.Offers.ToArrayAsync();

            return new ResponsDto<Offer>
            {
                ListDto = offers,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Offer>> GetAllOffersForUser(int userId, OfferFilter offerFilter)
        {

            var user = await _redHouseDbContext.Users.FindAsync(userId);
            if (user == null)
            {
                return new ResponsDto<Offer>
                {
                    Exception = new Exception($"User with {userId} Id Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            // Define a separate method without optional arguments
            string GetOfferStatus(string offerStatus)
            {
                // Logic to process offerStatus and return the desired value
                return offerStatus.Split(' ')[0];
            }

            var query = _redHouseDbContext.Offers.Where(o => o.CustomerId == userId || o.LandlordId == userId)
            .Include(o => o.Customer)
            .Include(o => o.Landlord)
            .Include(o => o.UserCreated)
            .Include(a => a.Property)
            .ThenInclude(p => p.Location)
            .Include(a => a.Property)
            .ThenInclude(p => p.User)
            .Include(a => a.Property)
            .ThenInclude(p => p.propertyFiles)
            .AsQueryable();

            if (offerFilter.OfferTo.Trim() == "Sent")
            {
                query = query.Where(c => c.UserCreatedId == userId);
            }

            if (offerFilter.OfferTo.Trim() == "Incoming")
            {
                query = query.Where(c => c.UserCreatedId != userId);
            }


            if (offerFilter.OfferType.Trim() != "All")
            {
                query = query.Where(a => a.Property.ListingType == offerFilter.OfferType.Trim());
            }

            if (offerFilter.OfferStatus.Trim() != "All")
            {
                query = query.Where(c => c.OfferStatus == offerFilter.OfferStatus.Trim());
            }

            var offers = query.ToArray();

            return new ResponsDto<Offer>
            {
                ListDto = offers,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Offer>> GetOfferFor(int offerId)
        {
            var offer = await _redHouseDbContext.Offers.FindAsync(offerId);
            if (offer == null)
            {
                return new ResponsDto<Offer>
                {
                    Exception = new Exception("Offer Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            return new ResponsDto<Offer>
            {
                Dto = offer,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Offer>> GetOffer(int propertyId, int landlordId, int customerId)
        {
            var property = await _redHouseDbContext.Properties.FindAsync(propertyId);
            if (property == null)
            {
                return new ResponsDto<Offer>
                {
                    Exception = new Exception($"property Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            var landlord = await _redHouseDbContext.Users.FindAsync(landlordId);
            if (landlord == null)
            {
                return new ResponsDto<Offer>
                {
                    Exception = new Exception($"User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            var customer = await _redHouseDbContext.Users.FindAsync(customerId);
            if (customer == null)
            {
                return new ResponsDto<Offer>
                {
                    Exception = new Exception($"User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            var offer = await _redHouseDbContext.Offers.Include(o => o.Customer).Include(o => o.Landlord).Include(o => o.Property).Include(o => o.UserCreated).FirstOrDefaultAsync(o => o.PropertyId == propertyId && o.LandlordId == landlordId && o.CustomerId == customerId);

            if (offer == null)
            {
                return new ResponsDto<Offer>
                {
                    Message = "Not Created",
                    Dto = null,
                    StatusCode = HttpStatusCode.OK,
                };
            }
            else
            {
                return new ResponsDto<Offer>
                {
                    Message = "Created",
                    Dto = offer,
                    StatusCode = HttpStatusCode.OK,
                };
            }

        }

        public async Task<int> NumberOfOffers()
        {
            return await _redHouseDbContext.Offers.CountAsync();
        }

        public async Task<ResponsDto<Offer>> UpdateOffer(UpdateOfferDto offerDto, int offerId)
        {
            var offer = await _redHouseDbContext.Offers
                .FirstOrDefaultAsync(c => c.Id == offerId);

            if (offer == null)
            {
                return new ResponsDto<Offer>
                {
                    Exception = new Exception("Offer Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            // Update only the properties that are not null in the DTO
            if (offerDto.CustomerId != null)
            {
                offer.CustomerId = (int)offerDto.CustomerId;
            }

            if (offerDto.LandlordId != null)
            {
                offer.LandlordId = (int)offerDto.LandlordId;
            }

            if (offerDto.PropertyId != null)
            {
                offer.PropertyId = (int)offerDto.PropertyId;
            }

            if (offerDto.Description != null)
            {
                offer.Description = offerDto.Description;
            }

            if (offerDto.OfferDate != null)
            {
                offer.OfferDate = (DateTime)offerDto.OfferDate;
            }

            if (offerDto.OfferExpires != null)
            {
                offer.OfferExpires = (DateTime)offerDto.OfferExpires;
            }

            if (offerDto.OfferStatus != null)
            {
                offer.OfferStatus = offerDto.OfferStatus;
            }

            if (offerDto.Price != null)
            {
                offer.Price = (double)offerDto.Price;
            }

            _redHouseDbContext.SaveChanges();

            return new ResponsDto<Offer>
            {
                Message = "Offer with {applicationId} Id Updated successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }

    }
}
