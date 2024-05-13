using System;

namespace RedHouse_Server.Dtos.OfferDtos
{
    public class UpdateOfferDto
    {
        public DateTime? OfferDate { get; set; }
        public DateTime? OfferExpires { get; set; }
        public string? Description { get; set; }
        public double? Price { get; set; }
        public string? OfferStatus { get; set; }
        public int? LandlordId { get; set; }
        public int? CustomerId { get; set; }
        public int? PropertyId { get; set; }
        public int? UserCreatedId { get; set; }
    }
}
