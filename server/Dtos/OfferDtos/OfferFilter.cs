using RedHouse_Server.Models;
using Property = RedHouse_Server.Models.Property;

namespace RedHouse_Server.Dtos.OfferDtos
{
   public class OfferFilter
    {
        public string OfferType { get; set; }
        public string OfferStatus { get; set; }
        public string OfferTo { get; set; }

    }
}
