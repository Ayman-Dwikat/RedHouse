using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RedHouse_Server.Models
{
    public class Application
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey(nameof(Property))]
        public int PropertyId { get; set; }
        public Property Property {get; set;}

        [ForeignKey(nameof(User))]
        public int UserId { get; set; }
        public User User { get; set; }
        public DateTime ApplicationDate { get; set; }
        public string Message { get; set; }
        public string ApplicationStatus { get; set; }
        public double SuggestedPrice { get; set; }
        

    }
}
