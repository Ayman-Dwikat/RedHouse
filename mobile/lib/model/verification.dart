import 'package:client/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'verification.g.dart';

@JsonSerializable()
class Verification {
  int? id;
  int? userId;
  User? user;
  String? requestStatus;
  DateTime? requestDate;

  Verification({
    this.id,
    this.userId,
    this.user,
    this.requestDate,
    this.requestStatus,
  });

  factory Verification.fromJson(Map<String, dynamic> json) =>
      _$VerificationFromJson(json);
  Map<String, dynamic> toJson() => _$VerificationToJson(this);
}
