using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using RedHouse_Server.Models;

namespace server.Models
{
    public class Complaint
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey(nameof(User))]
        public int UserId { get; set; }
        public User User { get; set; }
        public DateTime ComplainDate { get; set; }
        public string Description { get; set; }
    }
}
