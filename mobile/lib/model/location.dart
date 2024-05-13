// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part "location.g.dart";

@JsonSerializable()
class Location {
  int id;
  String streetAddress;
  String city;
  String region;
  String postalCode;
  String country;
  double latitude;
  double longitude;

  Location({
    required this.id,
    required this.streetAddress,
    required this.city,
    required this.region,
    required this.postalCode,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
