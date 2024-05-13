import 'package:client/model/bookingDay.dart';
import 'package:client/model/property.dart';
import 'package:client/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part "booking.g.dart";

@JsonSerializable()
class Booking {
    int id ;
    int userId ;
    User? user ;
    
    int propertyId;
    Property? property ;
    String bookingCode ;
    DateTime bookingDate ;
    String bookingStatus ;
    List<BookingDay>? bookingDays ;
  Booking({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.bookingDate,
    required this.bookingStatus,
    required this.bookingCode,
     this.property,
     this.user,
    this.bookingDays,
  });

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);
}
