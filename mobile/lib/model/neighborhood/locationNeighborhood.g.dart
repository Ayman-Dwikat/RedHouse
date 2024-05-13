// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locationNeighborhood.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationNeighborhood _$LocationNeighborhoodFromJson(
        Map<String, dynamic> json) =>
    LocationNeighborhood(
      streetAddress: json['streetAddress'] as String?,
      city: json['city'] as String?,
      region: json['region'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LocationNeighborhoodToJson(
        LocationNeighborhood instance) =>
    <String, dynamic>{
      'streetAddress': instance.streetAddress,
      'city': instance.city,
      'region': instance.region,
      'postalCode': instance.postalCode,
      'country': instance.country,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
