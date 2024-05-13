import 'package:client/data/booking.dart';
import 'package:flutter/material.dart';
import 'package:client/model/booking.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  List<DateTime> preBookedDays = [];
  int userId = 1;
  int propertyId = 1;
  List<DateTime> bookingDays = [];
  List<Booking> userBookings = [];

  String bookingTo = "Customer";
  String bookingStatus = "All";

  TextEditingController cardNumber = TextEditingController();
  TextEditingController cardName = TextEditingController();
  TextEditingController cardCCV = TextEditingController();
  TextEditingController cardDate = TextEditingController();

  createBooking() async {
    var response =
        await BookingData.createBooking(userId, propertyId, bookingDays);

    if (response is Map<String, dynamic>) {
      if (response['statusCode'] == 200) {
      } else {
        Get.defaultDialog(
          title: "Error",
          middleText:
              "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
        );
      }
    }
  }

  getBookingDaysForProperty(int propertyId) async {
    var response = await BookingData.getBookingDaysForProperty(propertyId);

    if (response['statusCode'] == 200) {
      preBookedDays = (response['listDto'] as List<dynamic>)
          .map((e) => DateTime.parse(e['dayDate']))
          .toList();
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  getBookingsForUser(int userId) async {
    var response =
        await BookingData.getBookingsForUser(userId, bookingTo, bookingStatus);

    if (response['statusCode'] == 200) {
      userBookings = (response['listDto'] as List<dynamic>)
          .map((e) => Booking.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  deleteBooking(int id) async {
    var response = await BookingData.deleteBooking(id);
  }
}
