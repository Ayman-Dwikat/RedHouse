
using RedHouse_Server.Models;

namespace RedHouse_Server.Dtos.ApplicationDtos
{
    public class BookingDto
    {
        public int UserId { get; set; }
        public int PropertyId { get; set; }
        public List<DateTime> BookingDays { get; set; }
    }
}
