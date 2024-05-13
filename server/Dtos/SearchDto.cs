
using System.Net;

namespace Cooking_School.Dtos
{
    public class SearchDto
    {
        public string? SearchQuery { get; set; }
        public int? Page { get; set; } = 1;
        public int? Limit { get; set; } = 10;

    }
}
