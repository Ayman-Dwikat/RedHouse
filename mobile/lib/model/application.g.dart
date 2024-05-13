// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Application _$ApplicationFromJson(Map<String, dynamic> json) => Application(
      id: json['id'] as int,
      propertyId: json['propertyId'] as int,
      userId: json['userId'] as int,
      applicationDate: DateTime.parse(json['applicationDate'] as String),
      applicationStatus: json['applicationStatus'] as String,
      message: json['message'] as String,
      property: Property.fromJson(json['property'] as Map<String, dynamic>),
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      suggestedPrice: json['suggestedPrice'] as int?,
    );

Map<String, dynamic> _$ApplicationToJson(Application instance) =>
    <String, dynamic>{
      'id': instance.id,
      'propertyId': instance.propertyId,
      'userId': instance.userId,
      'applicationDate': instance.applicationDate.toIso8601String(),
      'applicationStatus': instance.applicationStatus,
      'message': instance.message,
      'user': instance.user,
      'property': instance.property,
      'suggestedPrice': instance.suggestedPrice,
    };
