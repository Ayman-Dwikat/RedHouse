using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace server.Models
{
    public class BookingDay
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey(nameof(Booking))]
        public int BookingId { get; set; }
        public Booking Booking { get; set; }
        public DateTime DayDate { get; set; }    // max value for this field is 30
    }
}
