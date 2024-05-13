// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Verification _$VerificationFromJson(Map<String, dynamic> json) => Verification(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      requestDate: json['requestDate'] == null
          ? null
          : DateTime.parse(json['requestDate'] as String),
      requestStatus: json['requestStatus'] as String?,
    );

Map<String, dynamic> _$VerificationToJson(Verification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'user': instance.user,
      'requestDate': instance.requestDate?.toIso8601String(),
      'requestStatus': instance.requestStatus,
    };
