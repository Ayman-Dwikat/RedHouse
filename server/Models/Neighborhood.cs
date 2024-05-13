using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RedHouse_Server.Models
{
    public class Neighborhood
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey(nameof(Property))]
        public int PropertyId { get; set; }
        public Property Property { get; set; }
        public string NeighborhoodType { get; set; }
        public string? NeighborhoodName { get; set; }

        [ForeignKey(nameof(Location))]
        public int LocationId { get; set; }
        public Location Location { get; set; }

    }
}
