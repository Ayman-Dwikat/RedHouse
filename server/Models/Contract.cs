using Microsoft.EntityFrameworkCore;
using server.Models;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RedHouse_Server.Models
{
    public class Contract
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(Offer))]
        public int OfferId { get; set; }
        public Offer? Offer { get; set; }
        public int? LawyerId { get; set; }
        public User? Lawyer { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public string ContractType { get; set; }
        public string ContractStatus { get; set; }
        public double Earnings { get; set; }
        public int IsShouldPay { get; set; }
        public List<Milestone>? Milestones { get; set; }
        public List<ContractActivity>? ContractActivities { get; set; }


    }

}
