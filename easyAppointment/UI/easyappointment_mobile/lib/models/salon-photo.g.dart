// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon-photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalonPhoto _$SalonPhotoFromJson(Map<String, dynamic> json) => SalonPhoto(
      json['salonId'] as int?,
      json['photo'] as String?,
      json['photoId'] as int?,
    );

Map<String, dynamic> _$SalonPhotoToJson(SalonPhoto instance) =>
    <String, dynamic>{
      'salonId': instance.salonId,
      'photo': instance.photo,
      'photoId': instance.photoId,
    };
