// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time-slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
      json['timeSlotId'] as int?,
      json['startTime'] as String?,
      json['endTime'] as String?,
      json['salonId'] as int?,
      json['employeeId'] as int?,
      json['slotDate'] as String?,
      json['duration'] as int?,
      json['OwnerUserId'] as int?,
      json['status'] as String?,
      json['employee'] == null
          ? null
          : User.fromJson(json['employee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
      'timeSlotId': instance.timeSlotId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'salonId': instance.salonId,
      'employeeId': instance.employeeId,
      'slotDate': instance.slotDate,
      'duration': instance.duration,
      'OwnerUserId': instance.OwnerUserId,
      'status': instance.status,
      'employee': instance.employee,
    };
