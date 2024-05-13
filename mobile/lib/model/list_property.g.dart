// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListProperty _$ListPropertyFromJson(Map<String, dynamic> json) => ListProperty(
      listDto: (json['listDto'] as List<dynamic>)
          .map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListPropertyToJson(ListProperty instance) =>
    <String, dynamic>{
      'listDto': instance.listDto,
    };
