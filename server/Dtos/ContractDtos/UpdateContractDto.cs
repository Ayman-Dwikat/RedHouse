using RedHouse_Server.Models;
using Property = RedHouse_Server.Models.Property;

namespace RedHouse_Server.Dtos.ContractDtos
{
   public class UpdateContractDto
    {
        public string? ContractStatus { get; set; }
        public double? Earnings { get; set; }
        public int? IsShouldPay { get; set; }
    }
}
