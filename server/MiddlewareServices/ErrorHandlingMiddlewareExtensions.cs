using Cooking_School.Core.ModelUsed;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using System;
using System.Net;
using static System.Runtime.InteropServices.JavaScript.JSType;

namespace Cooking_School.Infrastructure.MiddlewareHandlingEx
{
    public class ErrorHandlingMiddlewareExtensions
    {
        private readonly RequestDelegate _next;
        public ErrorHandlingMiddlewareExtensions(RequestDelegate next)
        {
            _next = next;
        }
        public async Task Invoke(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (StatusCodeException ex)
            {
                await HandleExceptionAsync(context, ex);
            }
        }
        private static Task HandleExceptionAsync(HttpContext context, StatusCodeException exception)
        {
            var code = exception.StatusCode; // 500 if unexpected
            string message = exception.Exception.Message;
            if (exception.Message.Length == 0) message = "Internal Server Error";
            var result = JsonConvert.SerializeObject(new { message });
            context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)code;
            return context.Response.WriteAsync(result);
        }

    }
}