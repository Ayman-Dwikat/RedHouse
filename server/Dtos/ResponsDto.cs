
using System.Net;
using server.Dtos;

namespace Cooking_School.Dtos
{
    public class ResponsDto<T> where T : class
    {
        public T? Dto { get; set; }
        public IList<T>? ListDto { get; set; }
        public string? Message { get; set; }
        public Exception? Exception { get; set; }
        public IList<Exception>? Exceptions { get; set; }
        public Pagination? Pagination { get; set; }
  
        public HttpStatusCode? StatusCode { get; set; }

    }
}