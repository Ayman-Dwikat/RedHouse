// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserHistory _$UserHistoryFromJson(Map<String, dynamic> json) => UserHistory(
      id: json['id'] as int,
      contractId: json['contractId'] as int,
      feedbackToLandlord: json['feedbackToLandlord'] as String?,
      feedbackToCustomer: json['feedbackToCustomer'] as String?,
      customerRating: json['customerRating'] as int?,
      landlordRating: json['landlordRating'] as int?,
      contract: Contract.fromJson(json['contract'] as Map<String, dynamic>),
    )..helpful = json['helpful'] as String? ?? '';

Map<String, dynamic> _$UserHistoryToJson(UserHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contractId': instance.contractId,
      'contract': instance.contract,
      'feedbackToLandlord': instance.feedbackToLandlord,
      'feedbackToCustomer': instance.feedbackToCustomer,
      'customerRating': instance.customerRating,
      'landlordRating': instance.landlordRating,
      'helpful': instance.helpful,
    };
