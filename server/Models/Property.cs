using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Diagnostics.Metrics;

namespace RedHouse_Server.Models
{
    public class Property
    {
        [Key]
        public int Id { get; set; }
        public string PropertyCode { get; set; }

        public string PropertyType { get; set; }
        [ForeignKey(nameof(User))]
        public int UserId { get; set; }
        public User User { get; set; }
        
        [ForeignKey(nameof(Location))]
        public int LocationId { get; set; }
        public Location Location { get; set; }

        // [ForeignKey(nameof(Neighborhood))]
        // public int NeighborhoodId { get; set; }
        public int Price { get; set; }
        public int NumberOfBedRooms { get; set; }
        public int NumberOfBathRooms { get; set; }
        public float SquareMetersArea { get; set; }
        public string PropertyDescription { get; set; }
        public DateTime ListingDate { get; set; } = DateTime.Now;
        public DateTime BuiltYear { get; set; } = DateTime.Now;
        public string View { get; set; }
        public DateTime AvailableOn { get; set; } = DateTime.Now;
        public string PropertyStatus { get; set; } = "Accepting offers";
        public int? NumberOfUnits { get; set; } = 1;
        public int ParkingSpots { get; set; }
        public string ListingType { get; set; }
        public string IsAvailableBasement { get; set; } = "false";
        public string ListingBy { get; set; } = "User";
        public ICollection<PropertyFile>? propertyFiles { get; set; }
    }
}
