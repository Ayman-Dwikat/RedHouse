// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
      id: json['id'] as int,
      propertyId: json['propertyId'] as int,
      userId: json['userId'] as int,
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      bookingStatus: json['bookingStatus'] as String,
      bookingCode: json['bookingCode'] as String,
      property: json['property'] == null
          ? null
          : Property.fromJson(json['property'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      bookingDays: (json['bookingDays'] as List<dynamic>?)
          ?.map((e) => BookingDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'user': instance.user,
      'propertyId': instance.propertyId,
      'property': instance.property,
      'bookingCode': instance.bookingCode,
      'bookingDate': instance.bookingDate.toIso8601String(),
      'bookingStatus': instance.bookingStatus,
      'bookingDays': instance.bookingDays,
    };
