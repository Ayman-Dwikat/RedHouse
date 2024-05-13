import 'package:client/model/location.dart';
import 'package:client/model/property_files.dart';
import 'package:client/model/user.dart';
import 'package:json_annotation/json_annotation.dart';
part "property.g.dart";

@JsonSerializable()
class Property {
  int id;
  String propertyType;
  int userId;
  User? user;
  String propertyCode;
  List<PropertyFile>? propertyFiles;
  int locationId;
  Location? location;
  int price;
  int numberOfBedRooms;
  int numberOfBathRooms;
  int squareMetersArea;
  String propertyDescription;
  DateTime builtYear;
  String view;
  DateTime availableOn;
  String propertyStatus;
  int numberOfUnits;
  int parkingSpots;
  String listingType;
  String isAvailableBasement;
  String listingBy;

  Property({
    required this.id,
    required this.propertyType,
    required this.userId,
    this.user,
    required this.propertyCode,
    this.propertyFiles,
    required this.locationId,
    this.location,
    required this.price,
    required this.numberOfBedRooms,
    required this.numberOfBathRooms,
    required this.squareMetersArea,
    required this.propertyDescription,
    required this.builtYear,
    required this.view,
    required this.availableOn,
    required this.propertyStatus,
    required this.numberOfUnits,
    required this.parkingSpots,
    required this.listingType,
    required this.isAvailableBasement,
    required this.listingBy,
  });

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyToJson(this);

}
