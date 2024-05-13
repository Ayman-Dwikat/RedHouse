// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
      id: json['id'] as int,
      propertyType: json['propertyType'] as String,
      userId: json['userId'] as int,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      propertyCode: json['propertyCode'] as String,
      propertyFiles: (json['propertyFiles'] as List<dynamic>?)
          ?.map((e) => PropertyFile.fromJson(e as Map<String, dynamic>))
          .toList(),
      locationId: json['locationId'] as int,
      location: json['location'] == null
          ? null
          : Location.fromJson(json['location'] as Map<String, dynamic>),
      price: json['price'] as int,
      numberOfBedRooms: json['numberOfBedRooms'] as int,
      numberOfBathRooms: json['numberOfBathRooms'] as int,
      squareMetersArea: json['squareMetersArea'] as int,
      propertyDescription: json['propertyDescription'] as String,
      builtYear: DateTime.parse(json['builtYear'] as String),
      view: json['view'] as String,
      availableOn: DateTime.parse(json['availableOn'] as String),
      propertyStatus: json['propertyStatus'] as String,
      numberOfUnits: json['numberOfUnits'] as int,
      parkingSpots: json['parkingSpots'] as int,
      listingType: json['listingType'] as String,
      isAvailableBasement: json['isAvailableBasement'] as String,
      listingBy: json['listingBy'] as String,
    );

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'id': instance.id,
      'propertyType': instance.propertyType,
      'userId': instance.userId,
      'user': instance.user,
      'propertyCode': instance.propertyCode,
      'propertyFiles': instance.propertyFiles,
      'locationId': instance.locationId,
      'location': instance.location,
      'price': instance.price,
      'numberOfBedRooms': instance.numberOfBedRooms,
      'numberOfBathRooms': instance.numberOfBathRooms,
      'squareMetersArea': instance.squareMetersArea,
      'propertyDescription': instance.propertyDescription,
      'builtYear': instance.builtYear.toIso8601String(),
      'view': instance.view,
      'availableOn': instance.availableOn.toIso8601String(),
      'propertyStatus': instance.propertyStatus,
      'numberOfUnits': instance.numberOfUnits,
      'parkingSpots': instance.parkingSpots,
      'listingType': instance.listingType,
      'isAvailableBasement': instance.isAvailableBasement,
      'listingBy': instance.listingBy,
    };
