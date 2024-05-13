using System;
using RedHouse_Server.Dtos.LocationDtos;
using RedHouse_Server.Dtos.PropertyDtos;

namespace server.Dtos.PropertyDtos
{
    public class FilterDto
    {
        public List<string>? PropertyTypes { get; set; }
        public List<string>? PropertyStatus { get; set; }

        public string? MinPrice { get; set; }
        public string? MaxPrice { get; set; }

        public string? MinPropertySize { get; set; }
        public string? MaxPropertySize { get; set; }

        public string? MinBuiltYear { get; set; }
        public string? MaxBuiltYear { get; set; }

        public string? HasBasement { get; set; }

        public string? ParkingSpots { get; set; }

        public string? RentType { get; set; }

        public string? NumberOfBedRooms { get; set; }
        public string? NumberOfBathRooms { get; set; }

        public string? View { get; set; }

        public string? ListingBy { get; set; }

        public string? ListingType { get; set; }
        public LocationFilterDto? LocationDto { get; set; }
    }
}
