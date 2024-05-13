using System;
using RedHouse_Server.Dtos.LocationDtos;
namespace server.Dtos.UpdateUserDto
{
    public class UpdateUserDto
    {
        public string? Name { get; set; }
        public string? Email { get; set; }
        public int? PhoneNumber { get; set; }
        public bool? IsVerified { get; set; }
        public int? LandlordScore { get; set; }
        public int? CustomerScore { get; set; }
        public String? UserRole { get; set; }
    }
}
