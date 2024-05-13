using System;
using Cooking_School.Dtos;
using RedHouse_Server.Dtos.ApplicationDtos;
using RedHouse_Server.Dtos.ContractDtos;
using RedHouse_Server.Dtos.OfferDtos;
using RedHouse_Server.Models;
using server.Models;

namespace server.Services
{
    public interface IBookingServices
    {
        public Task<ResponsDto<Booking>> Book(BookingDto bookingDto);
        public Task<ResponsDto<Booking>> GetAllBookings();
        public Task<ResponsDto<Booking>> GetAllBookingsForUser(int userId, string bookingsTo, string bookingStatus);
        public Task<ResponsDto<Booking>> GetBooking(int bookingId);
        public Task<ResponsDto<Booking>> DeleteBooking(int bookingId);
        public Task<ResponsDto<Booking>> UpdateBooking(BookingDto bookingDto, int bookingId);
        public Task<ResponsDto<Booking>> AcceptBooking(int offerId);
        public Task<ResponsDto<BookingDay>> GetBookingDaysForProperty(int propertyId);
        public Task<int> NumberOfBookings();

    }
}
