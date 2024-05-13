using System.Net;

namespace Cooking_School.Core.ModelUsed
{
    public class StatusCodeException : Exception
    {
        public StatusCodeException(HttpStatusCode statusCode, Exception exception)
        {
            StatusCode = statusCode;
            Exception = exception;
        }
        public HttpStatusCode StatusCode { get; set; }
        public Exception Exception { get; set; }

    }
}