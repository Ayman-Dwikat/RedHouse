import 'package:client/model/property.dart';
import 'package:json_annotation/json_annotation.dart';

part "list_property.g.dart";

@JsonSerializable()
class ListProperty {
  List<Property> listDto = [];
  ListProperty({required this.listDto});

  factory ListProperty.fromJson(Map<String, dynamic> json) =>
      _$ListPropertyFromJson(json);
  Map<String, dynamic> toJson() => _$ListPropertyToJson(this);
}
