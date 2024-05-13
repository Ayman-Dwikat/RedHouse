// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int?,
      email: json['email'] as String?,
      isVerified: json['isVerified'] as bool?,
      locationId: json['locationId'] as int?,
      name: json['name'] as String?,
      phoneNumber: json['phoneNumber'] as int?,
      userRole: json['userRole'] as String?,
      landlordScore: json['landlordScore'] as int?,
      customerScore: json['customerScore'] as int?,
      created: json['created'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'isVerified': instance.isVerified,
      'phoneNumber': instance.phoneNumber,
      'locationId': instance.locationId,
      'userRole': instance.userRole,
      'landlordScore': instance.landlordScore,
      'customerScore': instance.customerScore,
      'created': instance.created,
    };
