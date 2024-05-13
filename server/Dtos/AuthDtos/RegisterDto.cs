using System.ComponentModel.DataAnnotations;

namespace RedHouse_Server.Dtos.AuthDtos
{
    public class RegisterDto
    {
        [Required]
        public string? Email { get; set; }

        [Required]
        public string? Name { get; set; }

        [Required]

        public string? Password { get; set; }

        [Required]
        public int PhoneNumber { get; set; }

        public string? ZipCode { get; set; }

        [Required]
        public string? UserRole { get; set; } 
    }
}
