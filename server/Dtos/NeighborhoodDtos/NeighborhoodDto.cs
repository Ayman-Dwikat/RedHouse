using Mono.TextTemplating;
using RedHouse_Server.Dtos.LocationDtos;

namespace RedHouse_Server.Dtos.NeighborhoodDtos
{
    public class NeighborhoodDto
    {
        public int PropertyId { get; set; }
        public string NeighborhoodType { get; set; }
        public string? NeighborhoodName { get; set; }
        public LocationDto Location { get; set; }
    }
}
