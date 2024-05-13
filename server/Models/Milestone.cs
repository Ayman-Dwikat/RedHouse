using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.Contracts;

namespace server.Models
{
    public class Milestone
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey(nameof(Contract))]
        public int ContractId { get; set; }
        public string MilestoneName { get; set; }
        public string Description { get; set; }
        public string MilestoneStatus { get; set; }
        public DateTime MilestoneDate { get; set; }
        public double Amount { get; set; }
    }
}
