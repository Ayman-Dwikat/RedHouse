import 'package:client/model/location.dart';
import 'package:client/model/property.dart';
import 'package:json_annotation/json_annotation.dart';
part "neighborhood.g.dart";

@JsonSerializable()
class Neighborhood {
  String neighborhoodType;
  Location location;
  int? id;
  int? propertyId;
  Property? property;
  String? neighborhoodName;
  int? locationId;

  Neighborhood({
    required this.neighborhoodType,
    required this.location,
    this.id,
    this.propertyId,
    this.property,
    this.neighborhoodName,
    this.locationId,
  });

  factory Neighborhood.fromJson(Map<String, dynamic> json) =>
      _$NeighborhoodFromJson(json);
  Map<String, dynamic> toJson() => _$NeighborhoodToJson(this);
}
