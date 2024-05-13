using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RedHouse_Server.Models
{
    public class Visitors
    {
        [Key]
        public int Id { get; set; }
        public int NumberOfVisitors { get; set; }
    }
}
