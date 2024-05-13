using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace RedHouse_Server.Models
{
    public class IdentityFile
    {
        [Key]
        public int Id { get; set; }
        [ForeignKey(nameof(IdentityUser))]
        public int IdentityUserId { get; set; }
        public string DownloadUrls { get; set; }

    }
}
