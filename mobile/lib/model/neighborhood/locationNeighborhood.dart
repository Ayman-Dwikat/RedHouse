import 'package:json_annotation/json_annotation.dart';
part 'locationNeighborhood.g.dart';

@JsonSerializable()
class LocationNeighborhood {
  String? streetAddress;
  String? city;
  String? region;
  String? postalCode;
  String? country;
  double? latitude;
  double? longitude;

  LocationNeighborhood({
    this.streetAddress,
    this.city,
    this.region,
    this.postalCode,
    this.country,
    this.latitude,
    this.longitude,
  });

  factory LocationNeighborhood.fromJson(Map<String, dynamic> json) =>
      _$LocationNeighborhoodFromJson(json);
  Map<String, dynamic> toJson() => _$LocationNeighborhoodToJson(this);
}
