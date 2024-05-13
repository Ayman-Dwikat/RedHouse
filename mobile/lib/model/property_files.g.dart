// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_files.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyFile _$PropertyFileFromJson(Map<String, dynamic> json) => PropertyFile(
      id: json['id'] as int?,
      propertyId: json['propertyId'] as int?,
      downloadUrls: json['downloadUrls'] as String?,
    );

Map<String, dynamic> _$PropertyFileToJson(PropertyFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'propertyId': instance.propertyId,
      'downloadUrls': instance.downloadUrls,
    };
