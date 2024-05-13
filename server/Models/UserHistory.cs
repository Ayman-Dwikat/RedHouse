using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using RedHouse_Server.Models;

namespace server.Models
{
    public class UserHistory
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(Contract))]
        public int ContractId { get; set; }
        public Contract Contract { get; set; }

        public string? FeedbackToLandlord { get; set; }
        public string? FeedbackToCustomer { get; set; }

        public int? CustomerRating { get; set; }
        public int? LandlordRating { get; set; }

    }
}

// INSERT INTO UserHistoryRecords(ContractId, FeedbackToLandlord, FeedbackToCustomer, CustomerRating, LandlordRating)
// VALUES (7, 'Feedback to Landlord Text', 'Feedback to Customer Text', 5, 4);
