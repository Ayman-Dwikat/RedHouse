import 'dart:convert';
import 'package:client/core/class/statusrequest.dart';
import 'package:client/core/functions/checkinternet.dart';
import 'package:client/link_api.dart';
import 'package:client/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BookingData {
  static createBooking(
    int userId,
    int propertyId,
    List<DateTime> bookingDays,
  ) async {
    List<String> formattedBookingDays = bookingDays
        .map((dateTime) => DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime))
        .toList();

    var data = {
      "userId": userId,
      "propertyId": propertyId,
      "bookingDays": formattedBookingDays,
    };

    if (await checkInternet()) {
      var response = await http.post(
        Uri.parse(AppLink.bookings),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${getToken()}',
        },
        body: json.encode(data),
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = json.decode(response.body);
        return (responsebody);
      } else {
        return (StatusRequest.serverfailure);
      }
    } else {
      return (StatusRequest.offlinefailure);
    }
  }

  static getBookingDaysForProperty(int propertyId) async {
    if (await checkInternet()) {
      final Uri uri =
          Uri.https("10.0.2.2:7042", "/properties/$propertyId/booking-days");

      var response = await http.get(uri, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${getToken()}',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = json.decode(response.body);

        return (responsebody);
      } else {
        return StatusRequest.serverfailure;
      }
    } else {
      return StatusRequest.offlinefailure;
    }
  }

  static getBookingsForUser(
      int userId, String? bookingTo, String? bookingStatus) async {
    final Map<String, dynamic> filters = {
      "bookingsTo": bookingTo,
      "bookingStatus": bookingStatus,
    };

    if (await checkInternet()) {
      final Uri uri =
          Uri.https("10.0.2.2:7042", "users/$userId/bookings", filters);

      var response = await http.get(uri, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${getToken()}',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = json.decode(response.body);
        return (responsebody);
      } else {
        return StatusRequest.serverfailure;
      }
    } else {
      return StatusRequest.offlinefailure;
    }
  }

  static deleteBooking(int id) async {
    if (await checkInternet()) {
      var response = await http.delete(Uri.parse('${AppLink.bookings}/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${getToken()}',
          });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = json.decode(response.body);
        return (responsebody);
      } else {
        return StatusRequest.serverfailure;
      }
    } else {
      return StatusRequest.offlinefailure;
    }
  }
}
