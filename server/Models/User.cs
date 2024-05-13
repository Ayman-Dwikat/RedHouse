using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.OpenApi.Any;
using server.Models;
namespace RedHouse_Server.Models
{
    public class User
    {
        [Key]
        public int Id { get; set; }
        public string? Name { get; set; }
        public string? Email { get; set; }
        public bool IsVerified { get; set; }
        public int PhoneNumber { get; set; }
        public int LandlordScore { get; set; }
        public int CustomerScore { get; set; }

        [ForeignKey(nameof(Location))]
        public int LocationId { get; set; }
        public Location Location { get; set; }
        public string? UserRole { get; set; } = "Normal User"; // 1- Normal user 2- Landlord 3- Customer 4- Agent 
        public DateTime Created { get; set; } = DateTime.Now;


        // public List<Application>? Applications { get; set; }
        // public List<Property>? Properties { get; set; }
        // public List<SavedProperties>? SavedProperties { get; set; }


    }
}
