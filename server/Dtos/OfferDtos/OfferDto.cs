using RedHouse_Server.Models;

namespace RedHouse_Server.Dtos.OfferDtos
{
   public class OfferDto
    {
        public int LandlordId { get; set; }
        public int CustomerId { get; set; }
        public int PropertyId { get; set; }
        public int UserCreatedId { get; set; }
        public DateTime? OfferDate { get; set; } = DateTime.Now;
        public DateTime OfferExpires { get; set; }
        public string? Description { get; set; }
        public double Price { get; set; }
        public string OfferStatus { get; set; }
    }
}
