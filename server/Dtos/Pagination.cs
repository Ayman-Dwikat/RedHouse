using System;

namespace server.Dtos
{
    public class Pagination
    {
        public int? PageNumber { get; set; }
        public int? PageSize { get; set; }
        public int? TotalRows { get; set; }
        public int? TotalPages { get; set; }
    }
}
