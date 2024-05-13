using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using RedHouse_Server.Models;

namespace server.Models
{
    public class Offer
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(Landlord))]
        public int LandlordId { get; set; }
        public User Landlord { get; set; }

        [ForeignKey(nameof(Customer))]
        public int CustomerId { get; set; }
        public User Customer { get; set; }
        
        [ForeignKey(nameof(Property))]
        public int PropertyId { get; set; }
        public Property Property { get; set; }
        
        [ForeignKey(nameof(User))]
        public int UserCreatedId { get; set; }
        public User UserCreated { get; set; }
        public DateTime OfferDate { get; set; }
        public DateTime OfferExpires { get; set; }
        public string Description { get; set; }
        public double Price { get; set; }
        public string OfferStatus { get; set; }
    }

}
