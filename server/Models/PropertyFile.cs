using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RedHouse_Server.Models
{
    public class PropertyFile
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey(nameof(Property))]
        public int PropertyId { get; set; }
        public string DownloadUrls { get; set; }

    }
}
