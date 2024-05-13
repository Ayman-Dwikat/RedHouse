import 'package:json_annotation/json_annotation.dart';

part "milestone.g.dart";

@JsonSerializable()
class Milestone {
  int id;
  String milestoneName;
  String description;
  String milestoneDate;
  double amount;
  String milestoneStatus;
  int contractId;

  Milestone({
    required this.id,
    required this.milestoneName,
    required this.description,
    required this.milestoneDate,
    required this.amount,
    required this.milestoneStatus,
    required this.contractId,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) => _$MilestoneFromJson(json);
  Map<String, dynamic> toJson() => _$MilestoneToJson(this);
}
