using RedHouse_Server.Dtos.PropertyDtos;
using RedHouse_Server.Models;
using Cooking_School.Dtos;
using System.Net;
using server.Dtos.PropertyDtos;
using Microsoft.EntityFrameworkCore;
using server.Models;
using Microsoft.IdentityModel.Tokens;
using RedHouse_Server.Dtos.LocationDtos;
using server.Dtos;

namespace RedHouse_Server.Services
{
    public class PropertyServices : IPropertyServices
    {
        private RedHouseDbContext _redHouseDbContext;
        public PropertyServices(RedHouseDbContext blueHouseDbContext)
        {
            _redHouseDbContext = blueHouseDbContext;
        }
        public async Task<ResponsDto<Property>> AddProperty(PropertyDto propertyDto)
        {
            var user = await _redHouseDbContext.Users.FindAsync(propertyDto.UserId);
            if (user == null)
            {
                return new ResponsDto<Property>
                {
                    Exception = new Exception("User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            Location location = new Location
            {
                City = propertyDto.LocationDto.City,
                Country = propertyDto.LocationDto.Country,
                Region = propertyDto.LocationDto.Region,
                PostalCode = propertyDto.LocationDto.PostalCode,
                StreetAddress = propertyDto.LocationDto.StreetAddress,
                Latitude = propertyDto.LocationDto.Latitude,
                Longitude = propertyDto.LocationDto.Longitude,
            };
            var locationRes = await _redHouseDbContext.Locations.AddAsync(location);
            await _redHouseDbContext.SaveChangesAsync();

            Random random = new Random();
            // Generate four random 3-digit numbers and concatenate them to form a 12-digit number
            int firstPart = random.Next(100, 999);
            int secondPart = random.Next(100, 999);
            int thirdPart = random.Next(100, 999);
            int fourthPart = random.Next(100, 999);

            string random_number_str = $"{firstPart:D4}{secondPart:D4}{thirdPart:D4}{fourthPart:D4}";

            Property property = new Property
            {
                AvailableOn = propertyDto.AvailableOn,
                BuiltYear = propertyDto.BuiltYear,
                IsAvailableBasement = propertyDto.IsAvailableBasement,
                ListingBy = propertyDto.ListingBy,
                ListingType = propertyDto.ListingType,
                LocationId = locationRes.Entity.Id,
                PropertyCode = random_number_str,
                ListingDate = DateTime.Now,
                // NeighborhoodId = 0,
                NumberOfBathRooms = propertyDto.NumberOfBathRooms,
                NumberOfBedRooms = propertyDto.NumberOfBedRooms,
                NumberOfUnits = propertyDto.NumberOfUnits,
                ParkingSpots = propertyDto.ParkingSpots,
                Price = propertyDto.Price,
                PropertyDescription = propertyDto.PropertyDescription,
                PropertyStatus = propertyDto.PropertyStatus,
                PropertyType = propertyDto.PropertyType,
                SquareMetersArea = propertyDto.SquareMeter,
                UserId = propertyDto.UserId,
                View = propertyDto.View,
            };
            var propertyRes = await _redHouseDbContext.Properties.AddAsync(property);
            await _redHouseDbContext.SaveChangesAsync();
            int propertyId = propertyRes.Entity.Id;
            foreach (var file in propertyDto.PropertyFiles)
            {
                PropertyFile propertyFile = new PropertyFile
                {
                    PropertyId = propertyId,
                    DownloadUrls = file
                };
                await _redHouseDbContext.PropertyFiles.AddAsync(propertyFile);
                await _redHouseDbContext.SaveChangesAsync();
            }
            foreach (var neighborhoodDto in propertyDto.NeighborhoodDtos)
            {
                Location locationN = new Location
                {
                    City = neighborhoodDto.Location.City,
                    Country = neighborhoodDto.Location.Country,
                    Region = neighborhoodDto.Location.Region,
                    PostalCode = neighborhoodDto.Location.PostalCode,
                    StreetAddress = neighborhoodDto.Location.StreetAddress,
                    Latitude = neighborhoodDto.Location.Latitude,
                    Longitude = neighborhoodDto.Location.Longitude,
                };
                var locationResN = await _redHouseDbContext.Locations.AddAsync(locationN);
                await _redHouseDbContext.SaveChangesAsync();

                Neighborhood neighborhood = new Neighborhood
                {
                    PropertyId = propertyId,
                    NeighborhoodType = neighborhoodDto.NeighborhoodType,
                    NeighborhoodName = neighborhoodDto.NeighborhoodName,
                    LocationId = locationResN.Entity.Id
                };
                await _redHouseDbContext.Neighborhoods.AddAsync(neighborhood);
                await _redHouseDbContext.SaveChangesAsync();
            }
            return new ResponsDto<Property>
            {
                Dto = propertyRes.Entity,
                Message = "Proprety Added Successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Property>> DeleteProperty(int propertyId)
        {
            var property = await _redHouseDbContext.Properties.FindAsync(propertyId);
            if (property == null)
            {
                return new ResponsDto<Property>
                {
                    Exception = new Exception($"Property with {propertyId} Dose Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            _redHouseDbContext.Properties.Remove(property);
            _redHouseDbContext.SaveChanges();
            return new ResponsDto<Property>
            {
                Exception = new Exception($"Property with {propertyId} Deleted succussfuly"),
                StatusCode = HttpStatusCode.OK,
            };
        }


        public async Task<ResponsDto<Property>> GetProperties(FilterDto filterDto)
        {
            // Create a queryable variable based on the DbSet
            var query = _redHouseDbContext.Properties.AsQueryable();

            query = query.Where(p => p.Id >= 0);
            query = _redHouseDbContext.Properties
                                .Include(p => p.propertyFiles).Include(p => p.User);
            // Apply filtering based on the filterDto, if provided

            if (!string.IsNullOrEmpty(filterDto.MinPrice))
            {
                int minPrice;

                if (int.TryParse(filterDto.MinPrice, out minPrice))
                {
                    query = query.Where(p => p.Price >= minPrice);
                }
            }

            if (!string.IsNullOrEmpty(filterDto.MaxPrice))
            {
                int maxPrice;

                if (int.TryParse(filterDto.MaxPrice, out maxPrice))
                {
                    query = query.Where(p => p.Price <= maxPrice);
                }
            }

            if (!string.IsNullOrEmpty(filterDto.MinPropertySize))
            {
                int minSize;

                if (int.TryParse(filterDto.MinPropertySize, out minSize))
                {
                    query = query.Where(p => p.SquareMetersArea >= minSize);
                }
            }

            if (!string.IsNullOrEmpty(filterDto.MaxPropertySize))
            {
                int maxSize;

                if (int.TryParse(filterDto.MaxPropertySize, out maxSize))
                {
                    query = query.Where(p => p.SquareMetersArea <= maxSize);
                }
            }



            if (!string.IsNullOrEmpty(filterDto.MinBuiltYear))
            {
                int minBuiltYear;

                if (int.TryParse(filterDto.MinBuiltYear, out minBuiltYear))
                {
                    query = query.Where(p => p.BuiltYear.Year >= minBuiltYear);
                }
            }

            if (!string.IsNullOrEmpty(filterDto.MaxBuiltYear))
            {
                int maxBuiltYear;

                if (int.TryParse(filterDto.MaxBuiltYear, out maxBuiltYear))
                {
                    query = query.Where(p => p.BuiltYear.Year <= maxBuiltYear);
                }
            }

            if (!string.IsNullOrEmpty(filterDto.NumberOfBedRooms))
            {
                if (int.TryParse(filterDto.NumberOfBedRooms, out int numberOfBedRooms))
                {
                    query = query.Where(p => p.NumberOfBedRooms == numberOfBedRooms);
                }
            }

            if (!string.IsNullOrEmpty(filterDto.NumberOfBathRooms))
            {
                if (int.TryParse(filterDto.NumberOfBathRooms, out int numberOfBathRooms))
                {
                    query = query.Where(p => p.NumberOfBathRooms == numberOfBathRooms);
                }
            }

            if (!string.IsNullOrEmpty(filterDto.View))
            {
                query = query.Where(p => p.View == filterDto.View);
            }

            if (!string.IsNullOrEmpty(filterDto.ListingBy))
            {
                query = query.Where(p => p.User.UserRole == filterDto.ListingBy);
            }

            if (!string.IsNullOrEmpty(filterDto.ListingType))
            {
                if (filterDto.ListingType == "For rent")
                {
                    if (filterDto.RentType == "All")
                    {
                        query = query.Where(p => p.ListingType.Equals("For daily rent") || p.ListingType.Equals("For monthly rent"));
                    }
                    else if (filterDto.RentType == "For monthly")
                    {
                        query = query.Where(p => p.ListingType.Equals("For monthly rent"));
                    }
                    else
                    {
                        query = query.Where(p => p.ListingType.Equals("For daily rent"));
                    }
                }
                else
                {
                    query = query.Where(p => p.ListingType.Equals(filterDto.ListingType));
                }
            }

            if (!string.IsNullOrEmpty(filterDto.HasBasement))
            {

                query = query.Where(p => p.IsAvailableBasement == filterDto.HasBasement);

            }

            if (!string.IsNullOrEmpty(filterDto.ParkingSpots))
            {
                int parkingSpots;

                if (int.TryParse(filterDto.ParkingSpots, out parkingSpots))
                {
                    query = query.Where(p => p.ParkingSpots == parkingSpots);
                }
            }


            if (!filterDto.PropertyTypes.IsNullOrEmpty())
            {
                foreach (var propertyType in filterDto.PropertyTypes)
                {
                    query.Union(query.Where(p => propertyType == p.PropertyType));
                }

            }
            else
            {
                return new ResponsDto<Property>
                {
                    ListDto = new List<Property>(),
                    StatusCode = HttpStatusCode.OK,
                };

            }


            if (!filterDto.PropertyStatus.IsNullOrEmpty())
            {
                foreach (var propertyStatus in filterDto.PropertyStatus)
                {
                    query.Union(query.Where(p => propertyStatus == p.PropertyStatus));
                }
            }
            else
            {
                return new ResponsDto<Property>
                {
                    ListDto = new List<Property>(),
                    StatusCode = HttpStatusCode.OK,
                };
            }
            // Execute the query and return the results
            var properties = await query.ToArrayAsync();

            foreach (var property in properties)
            {
                var locationRes = await _redHouseDbContext.Locations.FirstOrDefaultAsync(l => l.Id == property.LocationId);
                property.Location = locationRes;
            }

            if (filterDto.LocationDto != null)
            {
                if (!string.IsNullOrEmpty(filterDto.LocationDto.City))
                {
                    properties = properties.Where(p => p.Location.City == filterDto.LocationDto.City).ToArray();
                }

                if (!string.IsNullOrEmpty(filterDto.LocationDto.Region))
                {
                    properties = properties.Where(p => p.Location.Region == filterDto.LocationDto.Region).ToArray();
                }

                if (!string.IsNullOrEmpty(filterDto.LocationDto.Country))
                {
                    properties = properties.Where(p => p.Location.Country == filterDto.LocationDto.Country).ToArray();
                }

                if (!string.IsNullOrEmpty(filterDto.LocationDto.StreetAddress))
                {
                    properties = properties.Where(p => p.Location.StreetAddress == filterDto.LocationDto.StreetAddress).ToArray();
                }

                if (!string.IsNullOrEmpty(filterDto.LocationDto.PostalCode))
                {
                    properties = properties.Where(p => p.Location.PostalCode == filterDto.LocationDto.PostalCode).ToArray();
                }

                if (!string.IsNullOrEmpty(filterDto.LocationDto.Latitude) && !string.IsNullOrEmpty(filterDto.LocationDto.Longitude))
                {
                    double latitude;
                    double longitude;

                    if (double.TryParse(filterDto.LocationDto.Latitude, out latitude) && double.TryParse(filterDto.LocationDto.Longitude, out longitude))
                    {
                        properties = properties.Where(p => p.Location.Latitude == latitude && p.Location.Longitude == longitude).ToArray();
                    }
                }
            }



            return new ResponsDto<Property>
            {
                ListDto = properties,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Property>> GetAllPropertiesForUser(int userId, MyPropertiesFilterDto myPropertiesFilterDto)
        {
            // Create a queryable variable based on the DbSet
            var query = _redHouseDbContext.Properties.AsQueryable();

            query = query.Where(p => p.UserId == userId);
            query = query.Include(p => p.propertyFiles).Include(p => p.User).Include(p => p.Location);
            var postedProperties = query.ToArray();

            if (myPropertiesFilterDto.PropertiesFilter != "Posted properties")
            {
                if (myPropertiesFilterDto.PropertiesFilter == "All properties")
                {
                    var unionQuery = from property in _redHouseDbContext.Properties.Include(p => p.propertyFiles).Include(p => p.User).Include(p => p.Location)
                                     join offer in _redHouseDbContext.Offers on property.Id equals offer.PropertyId
                                     join contract in _redHouseDbContext.Contracts on offer.Id equals contract.OfferId
                                     where offer.CustomerId == userId || offer.LandlordId == userId
                                     select property;

                    var allProperties = unionQuery.ToList();
                    allProperties.AddRange(postedProperties);
                    return new ResponsDto<Property>
                    {
                        ListDto = allProperties.Distinct().ToList(),
                        StatusCode = HttpStatusCode.OK,
                    };
                }
                else
                {
                    query = (from property in _redHouseDbContext.Properties.Include(p => p.propertyFiles).Include(p => p.User).Include(p => p.Location)
                             join offer in _redHouseDbContext.Offers
                                 on property.Id equals offer.PropertyId
                             join contract in _redHouseDbContext.Contracts
                                 on offer.Id equals contract.OfferId
                             where offer.CustomerId == userId
                             select property);
                    if (myPropertiesFilterDto.PropertiesFilter == "Rented properties")
                    {
                        query = (from property in _redHouseDbContext.Properties.Include(p => p.propertyFiles).Include(p => p.User).Include(p => p.Location)
                                 join offer in _redHouseDbContext.Offers
                                     on property.Id equals offer.PropertyId
                                 join contract in _redHouseDbContext.Contracts
                                     on offer.Id equals contract.OfferId
                                 where offer.CustomerId == userId
                                 where property.ListingType == "For monthly rent" || property.ListingType == "For daily rent"
                                 select property);

                    }
                    else if (myPropertiesFilterDto.PropertiesFilter == "Purchased properties")
                    {
                        query = (from property in _redHouseDbContext.Properties.Include(p => p.propertyFiles).Include(p => p.User).Include(p => p.Location)
                                 join offer in _redHouseDbContext.Offers
                                     on property.Id equals offer.PropertyId
                                 join contract in _redHouseDbContext.Contracts
                                     on offer.Id equals contract.OfferId
                                 where offer.CustomerId == userId
                                 where property.ListingType == "For sell"
                                 select property);
                    }
                    else if (myPropertiesFilterDto.PropertiesFilter == "Properties that have been sold")
                    {
                        query = (from property in _redHouseDbContext.Properties.Include(p => p.propertyFiles).Include(p => p.User).Include(p => p.Location)
                                 join offer in _redHouseDbContext.Offers
                                     on property.Id equals offer.PropertyId
                                 join contract in _redHouseDbContext.Contracts
                                     on offer.Id equals contract.OfferId
                                 where offer.LandlordId == userId
                                 where property.ListingType == "For sell"
                                 select property);
                    }
                    else if (myPropertiesFilterDto.PropertiesFilter == "Properties that have been rented")
                    {
                        query = (from property in _redHouseDbContext.Properties.Include(p => p.propertyFiles).Include(p => p.User).Include(p => p.Location)
                                 join offer in _redHouseDbContext.Offers
                                     on property.Id equals offer.PropertyId
                                 join contract in _redHouseDbContext.Contracts
                                     on offer.Id equals contract.OfferId
                                 where offer.LandlordId == userId
                                 where property.ListingType == "For monthly rent" || property.ListingType == "For daily rent"
                                 select property);
                    }
                }

            }
            else
            {
                return new ResponsDto<Property>
                {
                    ListDto = postedProperties,
                    StatusCode = HttpStatusCode.OK,
                };
            }

            var properties = query.ToArray();

            return new ResponsDto<Property>
            {
                ListDto = properties,
                StatusCode = HttpStatusCode.OK,
            };
        }



        public async Task<ResponsDto<Property>> GetProperty(int propertyId)
        {
            var property = await _redHouseDbContext.Properties.FindAsync(propertyId);
            if (property == null)
            {
                return new ResponsDto<Property>
                {
                    Message = $"Property with {propertyId} Id Dose Not Exist",
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            return new ResponsDto<Property>
            {
                Dto = property,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Property>> UpdateProperty(UpdatePropertyDto propertyDto, int propertyId)
        {
            var property = await _redHouseDbContext.Properties.FindAsync(propertyId);
            if (property == null)
            {
                return new ResponsDto<Property>
                {
                    Exception = new Exception($"Property with {propertyId} Dose Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            if (propertyDto.AvailableOn != null)
            {
                property.AvailableOn = (DateTime)propertyDto.AvailableOn;
            }
            else
            {
                property.AvailableOn = property.AvailableOn;
            }

            if (propertyDto.BuiltYear != null)
            {
                property.BuiltYear = (DateTime)propertyDto.BuiltYear;
            }
            else
            {
                property.BuiltYear = property.BuiltYear;
            }

            if (propertyDto.SquareMeter != null)
            {
                property.SquareMetersArea = (float)propertyDto.SquareMeter;
            }
            else
            {
                property.SquareMetersArea = property.SquareMetersArea;
            }

            if (propertyDto.UserId != null)
            {
                property.UserId = (int)propertyDto.UserId;
            }
            else
            {
                property.UserId = property.UserId;
            }

            if (propertyDto.PropertyStatus != null)
            {
                property.PropertyStatus = propertyDto.PropertyStatus;
            }
            else
            {
                property.PropertyStatus = property.PropertyStatus;
            }


            _redHouseDbContext.Properties.Update(property);
            _redHouseDbContext.SaveChanges();
            return new ResponsDto<Property>
            {
                Message = $"Property with {propertyId} Id Updated succssfully",
                StatusCode = HttpStatusCode.OK,
            };
        }



        public async Task<List<int>> GetPricePropertyHistoryAsRent(int propertyId)
        {
            var property = await _redHouseDbContext.Properties.FindAsync(propertyId);
            if (property == null)
            {
                throw new Exception($"Property with {propertyId} Id Does Not Exist");
            }


            var acceptedOffers = _redHouseDbContext.Offers
                .Where(o => o.PropertyId == propertyId && o.OfferStatus == "Accepted" && o.Property.ListingType == "For rent")
                .Include(o => o.Property) // Include the Property navigation property
                .Include(o => o.Landlord) // Include the Landlord navigation property
                .Include(o => o.Customer) // Include the Customer navigation property
                .ToList();
            var offersOfTheLastTenYears = acceptedOffers.Where(a => (DateTime.Now.Year - a.OfferDate.Year) < 10).ToArray();
            List<int> avgPropertiesPricePerYearInLastTenYears = Enumerable.Repeat(0, 10).ToList();

            for (int i = 0; i < avgPropertiesPricePerYearInLastTenYears.Count; i++)
            {
                int pricePerYear = avgPropertiesPricePerYearInLastTenYears[i];

                List<Offer> offersInThisYear = offersOfTheLastTenYears.Where(o => o.OfferDate.Year == (DateTime.Now.Year - i)).ToList();
                if (offersInThisYear.Count() > 0)
                {
                    int sum = 0, j = 0;
                    for (j = 0; j < offersInThisYear.Count(); j++)
                    {
                        sum = sum + (int)offersInThisYear[j].Price;
                    }
                    pricePerYear = sum / offersInThisYear.Count();
                    avgPropertiesPricePerYearInLastTenYears[i] = pricePerYear;
                }

            }
            return avgPropertiesPricePerYearInLastTenYears;

        }

        public async Task<int> NumberOfProperties()
        {
            return await _redHouseDbContext.Users.CountAsync();

        }

        public async Task<List<int>> GetPricePropertyHistoryAsSell(int propertyId)
        {
            var property = await _redHouseDbContext.Properties.FindAsync(propertyId);
            if (property == null)
            {
                throw new Exception($"Property with {propertyId} Id Does Not Exist");
            }


            var acceptedOffers = _redHouseDbContext.Offers
                .Where(o => o.PropertyId == propertyId && o.OfferStatus == "Accepted" && o.Property.ListingType == "For sell")
                .Include(o => o.Property) // Include the Property navigation property
                .Include(o => o.Landlord) // Include the Landlord navigation property
                .Include(o => o.Customer) // Include the Customer navigation property
                .ToList();
            var offersOfTheLastTenYears = acceptedOffers.Where(a => (DateTime.Now.Year - a.OfferDate.Year) < 10).ToArray();
            List<int> avgPropertiesPricePerYearInLastTenYears = Enumerable.Repeat(0, 10).ToList();

            for (int i = 0; i < avgPropertiesPricePerYearInLastTenYears.Count; i++)
            {
                int pricePerYear = avgPropertiesPricePerYearInLastTenYears[i];

                List<Offer> offersInThisYear = offersOfTheLastTenYears.Where(o => o.OfferDate.Year == (DateTime.Now.Year - i)).ToList();
                if (offersInThisYear.Count() > 0)
                {
                    int sum = 0, j = 0;
                    for (j = 0; j < offersInThisYear.Count(); j++)
                    {
                        sum = sum + (int)offersInThisYear[j].Price;
                    }
                    pricePerYear = sum / offersInThisYear.Count();
                    avgPropertiesPricePerYearInLastTenYears[i] = pricePerYear;
                }

            }
            return avgPropertiesPricePerYearInLastTenYears;
        }

        public async Task<List<int>> GetNumberOfPropertiesInLastTenYears()
        {
            var propertiesOfTheLastTenYears = _redHouseDbContext.Properties.Where(a => (DateTime.Now.Year - a.ListingDate.Year) < 10).ToArray();
            List<int> avgPropertiesNumberPerYearInLastTenYears = Enumerable.Repeat(0, 10).ToList();

            for (int i = 0; i < avgPropertiesNumberPerYearInLastTenYears.Count; i++)
            {
                int numberPerYear = avgPropertiesNumberPerYearInLastTenYears[i];

                List<Property> propertiesInThisYear = propertiesOfTheLastTenYears.Where(o => o.ListingDate.Year == (DateTime.Now.Year - i)).ToList();

                avgPropertiesNumberPerYearInLastTenYears[i] = propertiesInThisYear.Count();

            }
            avgPropertiesNumberPerYearInLastTenYears.Reverse();
            return avgPropertiesNumberPerYearInLastTenYears.ToList();
        }

        public async Task<ResponsDto<Property>> FilterProperties(SearchDto searchDto)
        {
            searchDto.Page = searchDto.Page < 1 ? 1 : searchDto.Page;
            searchDto.Limit = searchDto.Limit < 1 ? 10 : searchDto.Limit;
            var query = _redHouseDbContext.Properties.Include(u => u.Location).Include(u => u.User).Include(u => u.propertyFiles).AsQueryable();
            if (searchDto.SearchQuery != null)
                query = query.Where(p => p.PropertyCode == searchDto.SearchQuery);
            if (query == null)
                query = query.Where(p => p.Location.City == searchDto.SearchQuery
                || p.Location.City == searchDto.SearchQuery
                || p.Location.Country == searchDto.SearchQuery
                || p.Location.Region == searchDto.SearchQuery
                || p.Location.PostalCode == searchDto.SearchQuery);

            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling((double)totalItems / (int)(searchDto.Limit));

            var properties = await query
                .Skip((int)((searchDto.Page - 1) * searchDto.Limit))
                .Take((int)searchDto.Limit)
                .ToArrayAsync();

            if (properties == null || !properties.Any())
            {
                return new ResponsDto<Property>
                {
                    Exception = new Exception("Users Not Found"),
                    StatusCode = HttpStatusCode.NotFound,
                };
            }

            return new ResponsDto<Property>
            {
                ListDto = properties,
                Pagination = new Pagination
                {
                    PageNumber = searchDto.Page,
                    PageSize = searchDto.Limit,
                    TotalRows = totalItems,
                    TotalPages = totalPages
                },
                StatusCode = HttpStatusCode.OK,
            };
        }



        public async Task<ResponsDto<Location>> GetListAutoCompleteLocation(string query)
        {
            if (query == "")
                return new ResponsDto<Location>
                {
                    ListDto = _redHouseDbContext.Locations.Take(20).ToList(),
                    // PageNumber = pageNumber,
                    // PageSize = pageSize,
                    // TotalItems = totalItems,
                    // TotalPages = totalPages,
                    StatusCode = HttpStatusCode.OK,
                };

            var locations = await _redHouseDbContext.Locations.Where(u => u.Country.Contains(query)
                                                                       || u.City.Contains(query)
                                                                       || u.PostalCode.Contains(query)
                                                                       || u.Region.Contains(query)
                                                                       || u.StreetAddress.Contains(query)).ToListAsync();



            return new ResponsDto<Location>
            {
                ListDto = locations.Take(20).ToList(),
                // PageNumber = pageNumber,
                // PageSize = pageSize,
                // TotalItems = totalItems,
                // TotalPages = totalPages,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Property>> GetClosestPropertiesToTheCurrentLocation(double latitude, double longitude)
        {
            var properties = await _redHouseDbContext.Properties.Include(p => p.Location).Include(p => p.User).Include(p => p.propertyFiles).ToListAsync();
            properties = properties.Where(p => CalculateDistance((double)p.Location.Latitude, (double)p.Location.Longitude,
               (double)latitude, (double)longitude) <= 25).ToList();
            return new ResponsDto<Property>
            {
                ListDto = properties,
                // PageNumber = pageNumber,
                // PageSize = pageSize,
                // TotalItems = totalItems,
                // TotalPages = totalPages,
                StatusCode = HttpStatusCode.OK,
            };
        }


        public double CalculateDistance(double lat1, double lon1, double lat2, double lon2)
        {
            const double EarthRadiusKm = 6371;

            // Convert latitude and longitude from degrees to radians
            lat1 = DegreeToRadian(lat1);
            lon1 = DegreeToRadian(lon1);
            lat2 = DegreeToRadian(lat2);
            lon2 = DegreeToRadian(lon2);

            // Calculate differences
            double dLat = lat2 - lat1;
            double dLon = lon2 - lon1;

            // Haversine formula
            double a = Math.Sin(dLat / 2) * Math.Sin(dLat / 2) +
                       Math.Cos(lat1) * Math.Cos(lat2) * Math.Sin(dLon / 2) * Math.Sin(dLon / 2);
            double c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));

            // Distance in kilometers
            double distance = EarthRadiusKm * c;

            return distance;
        }

        private static double DegreeToRadian(double angle)
        {
            return Math.PI * angle / 180.0;
        }
    }
}
