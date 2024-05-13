using RedHouse_Server.Models;
using Property = RedHouse_Server.Models.Property;

namespace RedHouse_Server.Dtos.ContractDtos
{
   public class ContractDto
    {
        public int Id { get; set; }
        public int PropertyId { get; set; }
        public Property? Property { get; set; }
        public int LandlordId { get; set; }
        public User? Landlord { get; set; }
        public int CustomerId { get; set; }
        public User? Customer { get; set; }        
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string Description { get; set; }
        public double Price { get; set; }
        public string ContractType { get; set; }
        public string ContractStatus { get; set; }
        public double Earnings { get; set; }
        public int IsShouldPay { get; set; }

    }
}
