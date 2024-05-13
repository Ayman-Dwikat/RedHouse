// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contractActivity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractActivity _$ContractActivityFromJson(Map<String, dynamic> json) =>
    ContractActivity(
      id: json['id'] as int,
      contractId: json['contractId'] as int,
      activityType: json['activityType'] as String?,
      activityDate: DateTime.parse(json['activityDate'] as String),
      activityDescription: json['activityDescription'] as String,
    );

Map<String, dynamic> _$ContractActivityToJson(ContractActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contractId': instance.contractId,
      'activityType': instance.activityType,
      'activityDate': instance.activityDate.toIso8601String(),
      'activityDescription': instance.activityDescription,
    };
