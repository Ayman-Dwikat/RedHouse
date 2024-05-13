
namespace RedHouse_Server.Dtos.ApplicationDtos
{
    public class ApplicationDto
    {
        public int PropertyId { get; set; }
        public int UserId { get; set; }
        public DateTime ApplicationDate { get; set; }
        public string Message { get; set; }
        public string ApplicationStatus { get; set; }
        public double SuggestedPrice { get; set; }

    }
}
