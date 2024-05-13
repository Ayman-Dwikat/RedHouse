import 'package:client/model/neighborhood/locationNeighborhood.dart';
import 'package:json_annotation/json_annotation.dart';
part 'neighborhoodDto.g.dart';

@JsonSerializable()
class NeighborhoodDto {
  String neighborhoodType;
  String? neighborhoodName;
  LocationNeighborhood location;

  NeighborhoodDto({
    required this.neighborhoodType,
    this.neighborhoodName,
    required this.location,
  });

  factory NeighborhoodDto.fromJson(Map<String, dynamic> json) =>
      _$NeighborhoodDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NeighborhoodDtoToJson(this);
}


