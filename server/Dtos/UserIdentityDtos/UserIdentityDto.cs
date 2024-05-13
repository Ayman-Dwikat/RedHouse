
using RedHouse_Server.Models;

namespace RedHouse_Server.Dtos.ApplicationDtos
{
    public class UserIdentityDto
    {
       public int UserId { get; set; }
        public DateTime RequestDate { get; set; }
        public string RequestStatus { get; set; }
        public List<string> IdentityFiles { get; set; }
    }
}
