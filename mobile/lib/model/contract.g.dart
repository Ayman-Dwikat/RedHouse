// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contract.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contract _$ContractFromJson(Map<String, dynamic> json) => Contract(
      id: json['id'] as int,
      offerId: json['offerId'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      contractType: json['contractType'] as String,
      contractStatus: json['contractStatus'] as String,
      earnings: (json['earnings'] as num).toDouble(),
      isShouldPay: json['isShouldPay'] as int,
      offer: json['offer'] == null
          ? null
          : Offer.fromJson(json['offer'] as Map<String, dynamic>),
      milestones: (json['milestones'] as List<dynamic>?)
          ?.map((e) => Milestone.fromJson(e as Map<String, dynamic>))
          .toList(),
      lawyerId: json['lawyerId'] as int?,
      lawyer: json['lawyer'] == null
          ? null
          : User.fromJson(json['lawyer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContractToJson(Contract instance) => <String, dynamic>{
      'id': instance.id,
      'offerId': instance.offerId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'contractType': instance.contractType,
      'contractStatus': instance.contractStatus,
      'earnings': instance.earnings,
      'isShouldPay': instance.isShouldPay,
      'offer': instance.offer,
      'milestones': instance.milestones,
    };
