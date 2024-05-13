using System.ComponentModel.DataAnnotations;

namespace RedHouse_Server.Dtos.AuthDtos
{
    public class LoginDto
    {
        [Required]
        // [StringLength(100)]
        // [DataType(DataType.EmailAddress)]
        public string Email { get; set; }


        [Required]
        // [StringLength(100, MinimumLength = 5)]
        // [DataType(DataType.Password)]
        public string Password { get; set; }
    }
}
