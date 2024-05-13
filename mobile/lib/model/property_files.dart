import 'package:json_annotation/json_annotation.dart';

part "property_files.g.dart";

@JsonSerializable()

class PropertyFile {
  int? id;
  int? propertyId;
  String? downloadUrls;

  PropertyFile({
    this.id,
    this.propertyId,
    this.downloadUrls,
  });

factory PropertyFile.fromJson(Map<String, dynamic> json) => _$PropertyFileFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyFileToJson(this);
}
