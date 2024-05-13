import 'package:json_annotation/json_annotation.dart';
part "contractActivity.g.dart";

@JsonSerializable()
class ContractActivity {
  int id;
  int contractId;
  String ? activityType;
  DateTime activityDate;
  String activityDescription;

  ContractActivity({
    required this.id,
    required this.contractId,
    this.activityType,
    required this.activityDate,
    required this.activityDescription,
  });

  factory ContractActivity.fromJson(Map<String, dynamic> json) =>
      _$ContractActivityFromJson(json);
  Map<String, dynamic> toJson() => _$ContractActivityToJson(this);
}
