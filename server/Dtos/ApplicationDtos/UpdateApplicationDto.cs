using System;
using System.Collections.Generic;

namespace RedHouse_Server.Dtos.ApplicationDtos
{
    public class UpdateApplicationDto
    {
        public DateTime? ApplicationDate { get; set; }
        public string? ApplicationStatus { get; set; }
        public string? Message { get; set; }
        public int? PropertyId { get; set; }
        public int? UserId { get; set; }
    }
}
