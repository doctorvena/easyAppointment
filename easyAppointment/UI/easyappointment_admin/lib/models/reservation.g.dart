// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
    json['reservationId'] as int?,
    json['userBusinessId'] as int?,
    json['userCustomerId'] as int?,
    json['timeSlotId'] as int?,
    json['reservationDate'] == null
        ? null
        : DateTime.parse(json['reservationDate'] as String),
    json['reservationName'] as String?,
    json['timeSlot'] as List<TimeSlot>?);

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'reservationId': instance.reservationId,
      'userBusinessId': instance.userBusinessId,
      'userCustomerId': instance.userCustomerId,
      'timeSlotId': instance.timeSlotId,
      'reservationDate': instance.reservationDate?.toIso8601String(),
      'reservationName': instance.reservationName,
      'timeSlot': instance.timeSlots
    };
