// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookingDay.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingDay _$BookingDayFromJson(Map<String, dynamic> json) => BookingDay(
      id: json['id'] as int,
      bookingId: json['bookingId'] as int,
      booking: json['booking'] == null
          ? null
          : Booking.fromJson(json['booking'] as Map<String, dynamic>),
      dayDate: DateTime.parse(json['dayDate'] as String),
    );

Map<String, dynamic> _$BookingDayToJson(BookingDay instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'booking': instance.booking,
      'dayDate': instance.dayDate.toIso8601String(),
    };
