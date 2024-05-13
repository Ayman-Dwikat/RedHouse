using System;
using RedHouse_Server.Dtos.UserHistoryDtos;

namespace server.Dtos.UserHistoryDtos
{
    public class CreateUserHistoryDto
    {
        public int userId { get; set; } //
        public int ContractId { get; set; }
        public string Feedback { get; set; }
        public int Rating { get; set; }
    }
}
