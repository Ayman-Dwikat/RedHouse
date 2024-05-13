import 'package:client/model/property.dart';
import 'package:client/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part "application.g.dart";

@JsonSerializable()
class Application {
  int id;
  int propertyId;
  int userId;
  DateTime applicationDate;
  String applicationStatus;
  String message;
  User user;
  Property property;
  // double? suggestedPrice;
  int? suggestedPrice;
  Application({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.applicationDate,
    required this.applicationStatus,
    required this.message,
    required this.property,
    required this.user,
    this.suggestedPrice,
  });

  factory Application.fromJson(Map<String, dynamic> json) =>
      _$ApplicationFromJson(json);
  Map<String, dynamic> toJson() => _$ApplicationToJson(this);
}
