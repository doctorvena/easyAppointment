// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Salon _$SalonFromJson(Map<String, dynamic> json) => Salon(
      json['salonId'] as int?,
      json['salonName'] as String?,
      json['address'] as String?,
      json['photo'] as String?,
      json['ownerUserId'] as int?,
      json['cityId'] as int?,
      json['reservationPrice'] as int?,
      (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SalonToJson(Salon instance) => <String, dynamic>{
      'salonId': instance.salonId,
      'salonName': instance.salonName,
      'address': instance.address,
      'photo': instance.photo,
      'ownerUserId': instance.ownerUserId,
      'cityId': instance.cityId,
      'reservationPrice': instance.reservationPrice,
      'rating': instance.rating,
    };
