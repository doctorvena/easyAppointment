// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'salon-rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalonRating _$SalonRatingFromJson(Map<String, dynamic> json) => SalonRating(
      json['salonRatingId'] as int?,
      json['rating'] as int?,
      json['ratingDate'] == null
          ? null
          : DateTime.parse(json['ratingDate'] as String),
      json['userId'] as int?,
      json['comment'] as String?,
      json['salonId'] as int?,
    );

Map<String, dynamic> _$SalonRatingToJson(SalonRating instance) =>
    <String, dynamic>{
      'salonRatingId': instance.salonRatingId,
      'rating': instance.rating,
      'ratingDate': instance.ratingDate?.toIso8601String(),
      'userId': instance.userId,
      'comment': instance.comment,
      'salonId': instance.salonId,
    };
