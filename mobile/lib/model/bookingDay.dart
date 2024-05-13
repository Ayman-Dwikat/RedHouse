import 'package:client/model/booking.dart';
import 'package:client/model/property.dart';
import 'package:client/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part "bookingDay.g.dart";

@JsonSerializable()
class BookingDay {
     int id ;
         int bookingId ;
         Booking? booking ;
         DateTime dayDate ;
  BookingDay({
    required this.id,
    required this.bookingId,
     this.booking,
    required this.dayDate,
  });

  factory BookingDay.fromJson(Map<String, dynamic> json) =>
      _$BookingDayFromJson(json);
  Map<String, dynamic> toJson() => _$BookingDayToJson(this);
}
