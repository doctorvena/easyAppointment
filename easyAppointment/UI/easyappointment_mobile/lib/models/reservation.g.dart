// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      json['reservationId'] as int?,
      json['salonId'] as int?,
      json['userCustomerId'] as int?,
      json['userBusinessId'] as int?,
      json['timeSlotId'] as int?,
      json['status'] as String?,
      json['reservationDate'] == null
          ? null
          : DateTime.parse(json['reservationDate'] as String),
      json['reservationName'] as String?,
      (json['timeSlots'] as List<dynamic>?)
          ?.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['rating'] as int?,
      (json['price'] as num?)?.toDouble(),
      json['isPaid'] as bool?,
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'reservationId': instance.reservationId,
      'salonId': instance.salonId,
      'userCustomerId': instance.userCustomerId,
      'userBusinessId': instance.userBusinessId,
      'timeSlotId': instance.timeSlotId,
      'rating': instance.rating,
      'reservationDate': instance.reservationDate?.toIso8601String(),
      'reservationName': instance.reservationName,
      'status': instance.status,
      'timeSlots': instance.timeSlots,
      'price': instance.price,
      'isPaid': instance.isPaid,
    };
