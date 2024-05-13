// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map<String, dynamic> json) => Offer(
      id: json['id'] as int,
      landlordId: json['landlordId'] as int,
      customerId: json['customerId'] as int,
      propertryId: json['propertryId'] as int?,
      userCreatedId: json['userCreatedId'] as int,
      offerDate: DateTime.parse(json['offerDate'] as String),
      offerExpires: DateTime.parse(json['offerExpires'] as String),
      description: json['description'] as String,
      offerStatus: json['offerStatus'] as String,
      price: json['price'] as int,
      landlord: json['landlord'] == null
          ? null
          : User.fromJson(json['landlord'] as Map<String, dynamic>),
      customer: json['customer'] == null
          ? null
          : User.fromJson(json['customer'] as Map<String, dynamic>),
      property: json['property'] == null
          ? null
          : Property.fromJson(json['property'] as Map<String, dynamic>),
      userCreated: json['userCreated'] == null
          ? null
          : User.fromJson(json['userCreated'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      'id': instance.id,
      'landlordId': instance.landlordId,
      'customerId': instance.customerId,
      'propertryId': instance.propertryId,
      'userCreatedId': instance.userCreatedId,
      'offerDate': instance.offerDate.toIso8601String(),
      'offerExpires': instance.offerExpires.toIso8601String(),
      'description': instance.description,
      'price': instance.price,
      'offerStatus': instance.offerStatus,
      'landlord': instance.landlord,
      'customer': instance.customer,
      'userCreated': instance.userCreated,
      'property': instance.property,
    };
