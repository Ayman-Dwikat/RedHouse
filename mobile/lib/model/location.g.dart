// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      id: json['id'] as int,
      streetAddress: json['streetAddress'] as String,
      city: json['city'] as String,
      region: json['region'] as String,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'id': instance.id,
      'streetAddress': instance.streetAddress,
      'city': instance.city,
      'region': instance.region,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
