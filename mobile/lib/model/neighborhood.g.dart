// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'neighborhood.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Neighborhood _$NeighborhoodFromJson(Map<String, dynamic> json) => Neighborhood(
      neighborhoodType: json['neighborhoodType'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      id: json['id'] as int?,
      propertyId: json['propertyId'] as int?,
      property: json['property'] == null
          ? null
          : Property.fromJson(json['property'] as Map<String, dynamic>),
      neighborhoodName: json['neighborhoodName'] as String?,
      locationId: json['locationId'] as int?,
    );

Map<String, dynamic> _$NeighborhoodToJson(Neighborhood instance) =>
    <String, dynamic>{
      'neighborhoodType': instance.neighborhoodType,
      'location': instance.location,
      'id': instance.id,
      'propertyId': instance.propertyId,
      'property': instance.property,
      'neighborhoodName': instance.neighborhoodName,
      'locationId': instance.locationId,
    };
