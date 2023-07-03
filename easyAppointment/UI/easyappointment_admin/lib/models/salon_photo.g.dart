// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon_photo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalonPhoto _$SalonPhotoFromJson(Map<String, dynamic> json) => SalonPhoto(
      json['photoId'] as int?,
      json['photo'] as String?,
      json['salonId'] as int?,
    );

Map<String, dynamic> _$SalonPhotoToJson(SalonPhoto instance) =>
    <String, dynamic>{
      'photoId': instance.photoId,
      'photo': instance.photo,
      'salonId': instance.salonId,
    };
