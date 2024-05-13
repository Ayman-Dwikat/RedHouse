using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.Contracts;

namespace server.Models
{
    public class ContractActivity
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey(nameof(Contract))]
        public int ContractId { get; set; }
        public string ActivityType { get; set; }
        public DateTime ActivityDate { get; set; }
        public string ActivityDescription { get; set; }
    }
}
