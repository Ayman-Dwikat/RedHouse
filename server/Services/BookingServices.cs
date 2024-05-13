using System;
using System.Net;
using Cooking_School.Dtos;
using Hangfire;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client.Extensibility;
using Microsoft.IdentityModel.Tokens;
using RedHouse_Server.Dtos.ApplicationDtos;
using RedHouse_Server.Dtos.ContractDtos;
using RedHouse_Server.Dtos.OfferDtos;
using RedHouse_Server.Models;
using server.Models;

namespace server.Services
{
    public class BookingServices : IBookingServices
    {
        private RedHouseDbContext _redHouseDbContext;
        public BookingServices(RedHouseDbContext redHouseDbContext)
        {
            _redHouseDbContext = redHouseDbContext;
        }

        public Task<ResponsDto<Booking>> AcceptBooking(int offerId)
        {
            throw new NotImplementedException();
        }

        public async Task<ResponsDto<Booking>> Book(BookingDto bookingDto)
        {
            var user = await _redHouseDbContext.Users.FindAsync(bookingDto.UserId);
            if (user == null)
            {
                return new ResponsDto<Booking>
                {
                    Exception = new Exception("User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var property = await _redHouseDbContext.Properties.FindAsync(bookingDto.PropertyId);


            DateTime dateNow = DateTime.Now;
            dateNow = dateNow.AddMinutes(-dateNow.Minute);
            dateNow = dateNow.AddHours(-dateNow.Hour);
            Console.WriteLine(dateNow);

            // Now 'modifiedDate' has the same date and time as 'dateNow', but with minutes set to 00


            var thirtyDaysAfter = dateNow.AddDays(30);


            foreach (var date in bookingDto.BookingDays)
            {
                if (date < dateNow || date > thirtyDaysAfter)
                    return new ResponsDto<Booking>
                    {
                        Exception = new Exception("You are trying booking not available day #"),
                        StatusCode = HttpStatusCode.BadRequest,
                    };

                var bookingDay = await _redHouseDbContext.BookingDays.Where(b => b.DayDate.Day == date.Day
                                                                              && b.DayDate.Month == date.Month
                                                                              && b.DayDate.Year == date.Year
                                                                              && b.Booking.PropertyId == bookingDto.PropertyId
                                                                              && b.Booking.BookingStatus != "Done").FirstOrDefaultAsync();
                if (bookingDay != null)
                    return new ResponsDto<Booking>
                    {
                        Exception = new Exception("You are trying booking not available day *"),
                        StatusCode = HttpStatusCode.BadRequest,
                    };
                _redHouseDbContext.SaveChanges();
            }


            Random random = new Random();

            // Generate four random 4-digit numbers and concatenate them to form a 16-digit number
            int firstPart = random.Next(1000, 9999);
            int secondPart = random.Next(1000, 9999);
            int thirdPart = random.Next(1000, 9999);
            int fourthPart = random.Next(1000, 9999);

            string random_number_str = $"{firstPart:D4}{secondPart:D4}{thirdPart:D4}{fourthPart:D4}";

            Booking booking = new Booking
            {
                UserId = bookingDto.UserId,
                PropertyId = bookingDto.PropertyId,
                BookingCode = random_number_str,
                BookingStatus = "Paused"
            };

            var bookingRes = await _redHouseDbContext.Bookings.AddAsync(booking);
            await _redHouseDbContext.SaveChangesAsync(); // Use async SaveChanges

            List<DateTime> EndingOfBookingDayIntervals = new List<DateTime>();

            foreach (var day in bookingDto.BookingDays)
            {
                BookingDay bookingDay = new BookingDay
                {
                    BookingId = bookingRes.Entity.Id,
                    DayDate = day
                };
                await _redHouseDbContext.BookingDays.AddAsync(bookingDay);


                await _redHouseDbContext.SaveChangesAsync(); // Move SaveChanges outside the loop

                if (!bookingDto.BookingDays.IsNullOrEmpty())
                {
                    for (int i = 0; i < bookingDto.BookingDays.Count - 1; i++)
                    {
                        if (i == 0)
                        {
                            // await ScheduleRecurringJob(bookingDto.BookingDays[i + 1], "11:59", EndBookingProcess); // Pause
                            var jobId = $"RecurringJob0_{bookingDto.BookingDays[i]}";

                            var cronExpression = $"{"12:01".Split(':')[1]} {"12:01".Split(':')[0]} {bookingDto.BookingDays[i].Day} {bookingDto.BookingDays[i].Month} ?";

                            RecurringJob.RemoveIfExists(jobId);

                            // Use AddOrUpdate overload for async methods
                            RecurringJob.AddOrUpdate(jobId, () => ResumeBookingProcess(bookingRes.Entity.Id), cronExpression);
                        }

                        if (i + 1 == bookingDto.BookingDays.Count - 1)
                        {
                            // await ScheduleRecurringJob(bookingDto.BookingDays[i + 1], "11:59", EndBookingProcess); // Pause
                            var jobId = $"RecurringJob1_{bookingDto.BookingDays[i + 1]}";

                            var cronExpression = $"{"11:59".Split(':')[1]} {"11:59".Split(':')[0]} {bookingDto.BookingDays[i + 1].Day} {bookingDto.BookingDays[i + 1].Month} ?";

                            RecurringJob.RemoveIfExists(jobId);

                            // Use AddOrUpdate overload for async methods
                            RecurringJob.AddOrUpdate(jobId, () => EndBookingProcess(bookingRes.Entity.Id), cronExpression);
                        }

                        if ((bookingDto.BookingDays[i + 1].Day - bookingDto.BookingDays[i].Day) > 1)
                        {
                            // await ScheduleRecurringJob(bookingDto.BookingDays[i + 1], "11:59", ResumeBookingProcess); // Resume
                            // await ScheduleRecurringJob(bookingDto.BookingDays[i], "12:01", PauseBookingProcess); // Pause
                            var jobId = $"RecurringJob0_{bookingDto.BookingDays[i + 1]}";

                            var cronExpression = $"{"12:01".Split(':')[1]} {"12:01".Split(':')[0]} {bookingDto.BookingDays[i + 1].Day} {bookingDto.BookingDays[i + 1].Month} ?";

                            RecurringJob.RemoveIfExists(jobId);

                            // Use AddOrUpdate overload for async methods
                            RecurringJob.AddOrUpdate(jobId, () => ResumeBookingProcess(bookingRes.Entity.Id), cronExpression);



                            var jobId1 = $"RecurringJob2_{bookingDto.BookingDays[i]}";

                            var cronExpression1 = $"{"11:59".Split(':')[1]} {"11:59".Split(':')[0]} {bookingDto.BookingDays[i].Day} {bookingDto.BookingDays[i].Month} ?";

                            RecurringJob.RemoveIfExists(jobId1);

                            // Use AddOrUpdate overload for async methods
                            RecurringJob.AddOrUpdate(jobId1, () => PauseBookingProcess(bookingRes.Entity.Id), cronExpression1);
                        }
                    }
                }

            }

            return new ResponsDto<Booking>
            {
                Dto = bookingRes.Entity,
                Message = "Booking Done Successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }
        public async Task EndBookingProcess(int bookingId)
        {
            // Your asynchronous code here
            var bookings = await _redHouseDbContext.Bookings
                .Where(b => b.Id == bookingId).ToListAsync();
            var booking = bookings.FirstOrDefault();
            if (booking != null)
            {
                booking.BookingStatus = "Done";
                _redHouseDbContext.Bookings.Update(booking);
                _redHouseDbContext.SaveChanges();
            }
            // Do something with 'booking' if needed
        }

        public async Task PauseBookingProcess(int bookingId)
        {
            // Your asynchronous code here
            var bookings = await _redHouseDbContext.Bookings
                .Where(b => b.Id == bookingId).ToListAsync();
            var booking = bookings.FirstOrDefault();
            if (booking != null)
            {
                booking.BookingStatus = "Paused";
                _redHouseDbContext.Bookings.Update(booking);
                _redHouseDbContext.SaveChanges();
            }

            // Do something with 'booking' if needed
        }
        public async Task ResumeBookingProcess(int bookingId)
        {
            // Your asynchronous code here
            var bookings = await _redHouseDbContext.Bookings
                .Where(b => b.Id == bookingId).ToListAsync();
            var booking = bookings.FirstOrDefault();
            if (booking != null)
            {
                booking.BookingStatus = "InProcess";
                _redHouseDbContext.Bookings.Update(booking);
                _redHouseDbContext.SaveChanges();
            }

            // Do something with 'booking' if needed
        }
        public async Task<ResponsDto<Booking>> DeleteBooking(int bookingId)
        {
            var booking = await _redHouseDbContext.Bookings.FindAsync(bookingId);
            if (booking == null)
            {
                return new ResponsDto<Booking>
                {
                    Exception = new Exception("Book Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }


            _redHouseDbContext.Bookings.Remove(booking);
            _redHouseDbContext.SaveChanges();

            return new ResponsDto<Booking>
            {
                Message = "Book Deleted Successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Booking>> GetAllBookings()
        {


            var bookings = await _redHouseDbContext.Bookings.Include(b => b.Property).ToArrayAsync();

            return new ResponsDto<Booking>
            {
                ListDto = bookings,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Booking>> GetAllBookingsForUser(int userId, string bookingsTo, string bookingStatus)
        {
            var user = await _redHouseDbContext.Users.FindAsync(userId);
            if (user == null)
            {
                return new ResponsDto<Booking>
                {
                    Exception = new Exception("User Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            var query = _redHouseDbContext.Bookings
                .Include(a => a.User)
                .Include(b => b.BookingDays)
                .Include(a => a.Property)
                .ThenInclude(p => p.Location)
                .Include(a => a.Property)
                .ThenInclude(p => p.User)
                .Include(a => a.Property)
                .ThenInclude(p => p.propertyFiles)
                .AsQueryable();


            if (bookingsTo.Trim() == "Landlord")
            {
                query = from p in _redHouseDbContext.Properties
                        join a in query on p.Id equals a.PropertyId
                        where p.UserId == userId
                        select a;
            }

            if (bookingsTo.Trim() == "Customer")
            {
                query = query.Where(a => a.UserId == userId);
            }

            if (bookingStatus.Trim() != "All")
            {
                query = query.Where(c => c.BookingStatus == bookingStatus.Trim());
            }

            var bookings = await query.ToArrayAsync();

            return new ResponsDto<Booking>
            {
                ListDto = bookings,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<BookingDay>> GetBookingDaysForProperty(int propertyId)
        {
            var property = await _redHouseDbContext.Properties.FindAsync(propertyId);
            if (property == null)
            {
                return new ResponsDto<BookingDay>
                {
                    Exception = new Exception($"Property with {propertyId} Id Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            // var booking = _redHouseDbContext.Bookings.FirstOrDefault(b => b.PropertyId == propertyId);
            List<BookingDay> bookingDays = new List<BookingDay>();
            // if (booking != null)
            // {
            var thirtyDaysAgo = DateTime.Now;
            var thirtyDaysAfter = DateTime.Now.AddDays(30);

            bookingDays = await _redHouseDbContext.BookingDays
               .Where(b => b.Booking.PropertyId == propertyId && b.Booking.BookingStatus != "Done")
               .ToListAsync();

            // Rest of your code
            // }

            return new ResponsDto<BookingDay>
            {
                ListDto = bookingDays,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Booking>> GetBooking(int bookingId)
        {
            var booking = await _redHouseDbContext.Bookings.Where(b => b.Id == bookingId).Include(b => b.User).Include(b => b.Property).Include(b => b.BookingDays).FirstOrDefaultAsync();
            if (booking == null)
            {
                return new ResponsDto<Booking>
                {
                    Exception = new Exception("Booking Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            return new ResponsDto<Booking>
            {
                Dto = booking,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<ResponsDto<Offer>> GetOffer(int offerId)
        {
            var offer = await _redHouseDbContext.Offers.FindAsync(offerId);
            if (offer == null)
            {
                return new ResponsDto<Offer>
                {
                    Exception = new Exception("Offer Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }

            return new ResponsDto<Offer>
            {
                Dto = offer,
                StatusCode = HttpStatusCode.OK,
            };
        }

        public async Task<int> NumberOfBookings()
        {
            return await _redHouseDbContext.Bookings.CountAsync();
        }





        public async Task<ResponsDto<Booking>> UpdateBooking(BookingDto bookingDto, int bookingId)
        {
            var booking = await _redHouseDbContext.Bookings
                 .FirstOrDefaultAsync(c => c.Id == bookingId);
            if (booking == null)
            {
                return new ResponsDto<Booking>
                {
                    Exception = new Exception("Booking Not Exist"),
                    StatusCode = HttpStatusCode.BadRequest,
                };
            }
            Booking updatedBooking = new Booking
            {
                PropertyId = bookingDto.PropertyId,
                UserId = bookingDto.UserId

            };
            _redHouseDbContext.Bookings.Update(updatedBooking);
            _redHouseDbContext.SaveChanges();
            return new ResponsDto<Booking>
            {
                Dto = updatedBooking,
                Message = "Booking updated successfully",
                StatusCode = HttpStatusCode.OK,
            };
        }
    }
}
