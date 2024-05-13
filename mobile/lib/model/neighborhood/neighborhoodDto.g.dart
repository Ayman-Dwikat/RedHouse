// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'neighborhoodDto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NeighborhoodDto _$NeighborhoodDtoFromJson(Map<String, dynamic> json) =>
    NeighborhoodDto(
      neighborhoodType: json['neighborhoodType'] as String,
      neighborhoodName: json['neighborhoodName'] as String?,
      location: LocationNeighborhood.fromJson(
          json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NeighborhoodDtoToJson(NeighborhoodDto instance) =>
    <String, dynamic>{
      'neighborhoodType': instance.neighborhoodType,
      'neighborhoodName': instance.neighborhoodName,
      'location': instance.location,
    };
