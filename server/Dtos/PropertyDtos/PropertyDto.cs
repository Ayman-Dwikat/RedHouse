using RedHouse_Server.Dtos.LocationDtos;
using RedHouse_Server.Dtos.NeighborhoodDtos;
using RedHouse_Server.Models;
using server.Dtos.FileDtos;
using System.ComponentModel.DataAnnotations.Schema;

namespace RedHouse_Server.Dtos.PropertyDtos
{
    public class PropertyDto
    {
        public string PropertyType { get; set; }
        public int UserId { get; set; }
        public List<string> PropertyFiles { get; set; }
        public LocationDto? LocationDto { get; set; }
        public List<NeighborhoodDto> NeighborhoodDtos { get; set; }
        public int Price { get; set; }
        public int NumberOfBedRooms { get; set; }
        public int NumberOfBathRooms { get; set; }
        public float SquareMeter { get; set; }
        public string PropertyDescription { get; set; }
        public DateTime BuiltYear { get; set; }
        public string View { get; set; }
        public DateTime AvailableOn { get; set; } = DateTime.Now;
        public string PropertyStatus { get; set; }
        public int? NumberOfUnits { get; set; } = 1;
        public int ParkingSpots { get; set; }
        public string ListingType { get; set; }
        public string IsAvailableBasement { get; set; }
        public string ListingBy { get; set; } 
    }
}
