using System;
using Cooking_School.Dtos;
using RedHouse_Server.Dtos.ApplicationDtos;
using RedHouse_Server.Dtos.NeighborhoodDtos;
using RedHouse_Server.Models;

namespace server.Services
{
    public interface INeighborhoodServices
    {
        // public Task<ResponsDto<Neighborhood>> AddNeighborhood(NeighborhoodDto neighborhoodDto);
        // public Task<ResponsDto<Neighborhood>> AddRangeNeighborhood(ListNeighborhoodDto listNeighborhoodDto);
        public Task<ResponsDto<Neighborhood>> GetNeighborhoods(int propertyId);
        
    }
}
