// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'milestone.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Milestone _$MilestoneFromJson(Map<String, dynamic> json) => Milestone(
      id: json['id'] as int,
      milestoneName: json['milestoneName'] as String,
      description: json['description'] as String,
      milestoneDate: json['milestoneDate'] as String,
      amount: (json['amount'] as num).toDouble(),
      milestoneStatus: json['milestoneStatus'] as String,
      contractId: json['contractId'] as int,
    );

Map<String, dynamic> _$MilestoneToJson(Milestone instance) => <String, dynamic>{
      'id': instance.id,
      'milestoneName': instance.milestoneName,
      'description': instance.description,
      'milestoneDate': instance.milestoneDate,
      'amount': instance.amount,
      'milestoneStatus': instance.milestoneStatus,
      'contractId': instance.contractId,
    };
