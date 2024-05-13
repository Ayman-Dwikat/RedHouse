using RedHouse_Server.Models;

namespace RedHouse_Server.Dtos.MilestoneDtos
{
    public class MilestoneDto
    {
        public int ContractId { get; set; }
        public string MilestoneName { get; set; }
        public string Description { get; set; }
        public string MilestoneStatus { get; set; }
        public DateTime MilestoneDate { get; set; }
        public int Amount { get; set; }
    }
}
