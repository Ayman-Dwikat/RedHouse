using RedHouse_Server.Models;
using RedHouse_Server.Services;
using Cooking_School.Infrastructure.MiddlewareHandlingEx;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using AutoMapper;
using System.Reflection;
using Cooking_School_ASP.NET.Configurations;
using server.Services;
using server.Models;
using Hangfire;
using System.Text.Json.Serialization;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<RedHouseDbContext>(options =>
{
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection"));
});
builder.Services.AddIdentity<IdentityUser, IdentityRole>(options =>
{
    options.Password.RequireDigit = true;
    options.Password.RequireLowercase = true;
    options.Password.RequiredLength = 5;

}).AddEntityFrameworkStores<RedHouseDbContext>()
    .AddDefaultTokenProviders();
builder.Services.AddAuthentication(auth =>
{
    auth.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    auth.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    options.TokenValidationParameters = new Microsoft.IdentityModel.Tokens.TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        //ValidAudience = builder.Configuration["AuthSettings:Audience"],
        //ValidIssuer = builder.Configuration["AuthSettings:Issuer"],
        RequireExpirationTime = true,
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["AuthSettings:Key"]!)),
        ValidateIssuerSigningKey = true
    };
});
var mapperConfig = new MapperConfiguration(mc =>
{
    mc.AddProfile(new MapperInitilizer()); // Replace with your AutoMapper profile class
});

var mapper = mapperConfig.CreateMapper();
builder.Services.AddSingleton(mapper);
builder.Services.AddScoped<IAuthServices, AuthServices>();
builder.Services.AddScoped<IPropertyServices, PropertyServices>();
builder.Services.AddScoped<IApplicationServices, ApplicationServices>();
builder.Services.AddScoped<IUserHistoryServices, UserHistoryServices>();
builder.Services.AddScoped<IUserServices, UserServices>();
builder.Services.AddScoped<IContractServices, ContractServices>();
builder.Services.AddScoped<IComplaintServices, ComplaintServices>();
builder.Services.AddScoped<IUserIdentityServices, UserIdentityServices>();
builder.Services.AddScoped<IBookingServices, BookingServices>();
builder.Services.AddScoped<INeighborhoodServices, NeighborhoodServices>();
builder.Services.AddScoped<IMilestoneServices, MilestoneServices>();
builder.Services.AddScoped<IOfferServices, OfferServices>();
builder.Services.AddControllers().AddJsonOptions(options =>
{
    options.JsonSerializerOptions.ReferenceHandler = ReferenceHandler.IgnoreCycles;
    options.JsonSerializerOptions.WriteIndented = true;
});

builder.Services.AddHangfire((Span, config) =>
{
    config.UseSqlServerStorage(builder.Configuration.GetConnectionString("DefaultConnection"));
});

builder.Services.AddHangfireServer();

builder.Services.AddSwaggerGen(options =>
{
    options.ResolveConflictingActions(apiDescriptions => apiDescriptions.First());
    // other SwaggerGen configuration...
});
builder.Services.AddCors(options =>
        {
            options.AddDefaultPolicy(builder =>
            {
                builder.AllowAnyOrigin()
                       .AllowAnyMethod()
                       .AllowAnyHeader();
            });
        });


var app = builder.Build();
app.UseMiddleware<ErrorHandlingMiddlewareExtensions>();


// app.Use(async (context, next) =>
//     {
//         // Set Content Security Policy header
//         context.Response.Headers.Add("Content-Security-Policy", "connect-src 'self' http://localhost:7042");

//         await next();
//     });

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors(c => c.AllowAnyHeader().AllowAnyOrigin().AllowAnyMethod());


app.UseHangfireServer();

app.UseHangfireDashboard();
app.UseHttpsRedirection();

app.UseAuthentication();

app.UseAuthorization();

app.MapControllers();

app.Run();
