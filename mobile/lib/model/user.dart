import 'package:json_annotation/json_annotation.dart';

part "user.g.dart";

@JsonSerializable()
class User {
  int? id;
  String? name;
  String? email;
  bool? isVerified;
  int? phoneNumber;
  int? locationId;
  String? userRole;
  int? landlordScore;
  int? customerScore;
  String? created;

  User({
    required this.id,
    required this.email,
    required this.isVerified,
    required this.locationId,
    required this.name,
    required this.phoneNumber,
    required this.userRole,
    required this.landlordScore,
    required this.customerScore,
    required this.created,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
