using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using RedHouse_Server.Models;

namespace server.Models
{
    public class SavedProperties
    {
        [Key]
        public int Id { get; set; }

        [ForeignKey(nameof(User))]

        public int UserId { get; set; }
        
        [ForeignKey(nameof(Property))]

        public int PropertyId { get; set; }
    }
}
