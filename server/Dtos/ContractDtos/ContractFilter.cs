using RedHouse_Server.Models;
using Property = RedHouse_Server.Models.Property;

namespace RedHouse_Server.Dtos.ContractDtos
{
   public class ContractFilter
    {
        public string ContractType { get; set; }
        public string ContractStatus { get; set; }
        public string? ContractTo { get; set; }

    }
}
