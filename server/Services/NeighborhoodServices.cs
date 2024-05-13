using System;
using Cooking_School.Dtos;
using RedHouse_Server.Dtos.ApplicationDtos;
using RedHouse_Server.Models;
using System.Net;
using Microsoft.EntityFrameworkCore;
using RedHouse_Server.Dtos.NeighborhoodDtos;

namespace server.Services
{
    public class NeighborhoodServices : INeighborhoodServices
    {
        private RedHouseDbContext _redHouseDbContext;
        public NeighborhoodServices(RedHouseDbContext blueHouseDbContext)
        {
            _redHouseDbContext = blueHouseDbContext;
        }

        // public async Task<ResponsDto<Neighborhood>> AddNeighborhood(NeighborhoodDto neighborhoodDto)
        // {
        //     var porperty = await _redHouseDbContext.Neighborhoods.FindAsync(neighborhoodDto.PropertyId);
        //     if (porperty == null)
        //     {
        //         return new ResponsDto<Neighborhood>
        //         {
        //             Exception = new Exception("Property Not Exist"),
        //             StatusCode = HttpStatusCode.BadRequest,
        //         };
        //     }
        //     Location location = new Location
        //     {
        //         City = neighborhoodDto.Location.City,
        //         Country = neighborhoodDto.Location.Country,
        //         Region = neighborhoodDto.Location.Region,
        //         PostalCode = neighborhoodDto.Location.PostalCode,
        //         StreetAddress = neighborhoodDto.Location.StreetAddress,
        //         Latitude = neighborhoodDto.Location.Latitude,
        //         Longitude = neighborhoodDto.Location.Longitude,
        //     };

        //     var locationRes = await _redHouseDbContext.Locations.AddAsync(location);
        //     _redHouseDbContext.SaveChangesAsync();

        //     Neighborhood neighborhood = new Neighborhood
        //     {
        //         LocationId = locationRes.Entity.Id,
        //         NeighborhoodName = neighborhoodDto.NeighborhoodName,
        //         NeighborhoodType = neighborhoodDto.NeighborhoodType,
        //         PropertyId = neighborhoodDto.PropertyId,
        //     };
        //     var neighborhoodRes = await _redHouseDbContext.Neighborhoods.AddAsync(neighborhood);
        //     await _redHouseDbContext.SaveChangesAsync();

        //     return new ResponsDto<Neighborhood>
        //     {
        //         Dto = neighborhoodRes.Entity,
        //         Message = "Neighborhood Added Successfully",
        //         StatusCode = HttpStatusCode.OK,
        //     };
        // }

        // public async Task<ResponsDto<Neighborhood>> AddRangeNeighborhood(ListNeighborhoodDto listNeighborhoodDto)
        // {
        //     foreach (var neighborhoodDto in listNeighborhoodDto.NeighborhoodDtos)
        //     {
        //         var porperty = await _redHouseDbContext.Properties.FindAsync(neighborhoodDto.PropertyId);
        //         if (porperty == null)
        //         {
        //             return new ResponsDto<Neighborhood>
        //             {
        //                 Exception = new Exception("Property Not Exist"),
        //                 StatusCode = HttpStatusCode.BadRequest,
        //             };
        //         }
        //         Location location = new Location
        //         {
        //             City = neighborhoodDto.Location.City,
        //             Country = neighborhoodDto.Location.Country,
        //             Region = neighborhoodDto.Location.Region,
        //             PostalCode = neighborhoodDto.Location.PostalCode,
        //             StreetAddress = neighborhoodDto.Location.StreetAddress,
        //             Latitude = neighborhoodDto.Location.Latitude,
        //             Longitude = neighborhoodDto.Location.Longitude,
        //         };

        //         var locationRes = await _redHouseDbContext.Locations.AddAsync(location);
        //         await _redHouseDbContext.SaveChangesAsync();

        //         Neighborhood neighborhood = new Neighborhood
        //         {
        //             LocationId = locationRes.Entity.Id,
        //             NeighborhoodName = neighborhoodDto.NeighborhoodName,
        //             NeighborhoodType = neighborhoodDto.NeighborhoodType,
        //             PropertyId = neighborhoodDto.PropertyId,
        //         };
        //         var neighborhoodRes = await _redHouseDbContext.Neighborhoods.AddAsync(neighborhood);
        //         await _redHouseDbContext.SaveChangesAsync();


        //     }


        //     return new ResponsDto<Neighborhood>
        //     {
        //         Message = "Neighborhoods Added Successfully",
        //         StatusCode = HttpStatusCode.OK,
        //     };
        // }

        public async Task<ResponsDto<Neighborhood>> GetNeighborhoods(int propertyId)
        {
            var porperty = await _redHouseDbContext.Properties.FindAsync(propertyId);
            if (porperty == null)
            {
                return new ResponsDto<Neighborhood>
                {
                    Exception = new Exception("Property Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var query = from n in _redHouseDbContext.Neighborhoods
                        where n.PropertyId == propertyId
                        select n;

            var neighborhoods = query.Include(a => a.Location).Include(a => a.Property).ThenInclude(p => p.Location).ToList();


            return new ResponsDto<Neighborhood>
            {
                ListDto = neighborhoods,
                StatusCode = HttpStatusCode.OK,
            };
        }
    }
}


