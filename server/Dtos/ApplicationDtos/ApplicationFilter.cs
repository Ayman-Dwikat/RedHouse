using RedHouse_Server.Models;

namespace RedHouse_Server.Dtos.ApplicationDtos
{
   public class ApplicationFilter
    {
        public string? ApplicationType { get; set; }
        public string? ApplicationStatus { get; set; }
        public string? ApplicationTo { get; set; }

    }
}
