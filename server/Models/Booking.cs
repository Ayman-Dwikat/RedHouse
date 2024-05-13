using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using RedHouse_Server.Models;

namespace server.Models
{
    public class Booking
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey(nameof(User))]
        public int UserId { get; set; }
        public User User { get; set; }
        
        [ForeignKey(nameof(Property))]
        public int PropertyId { get; set; }
        public Property Property { get; set; }
        public string BookingCode { get; set; }
        public DateTime BookingDate { get; set; } = DateTime.Now;
        public string BookingStatus { get; set; }
        public  ICollection<BookingDay> BookingDays { get; set; }
    }
}
