// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time-slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
      json['timeSlotId'] as int?,
      json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      json['endTime'] as String?,
      json['salonId'] as int?,
      json['employeeId'] as int?,
      json['slotDate'] as String?,
      json['duration'] as int?,
      json['businessId'] as int?,
      json['status'] as String?,
      json['employee'] == null
          ? null
          : User.fromJson(json['employee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
      'timeSlotId': instance.timeSlotId,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime,
      'salonId': instance.salonId,
      'employeeId': instance.employeeId,
      'slotDate': instance.slotDate,
      'duration': instance.duration,
      'businessId': instance.businessId,
      'status': instance.status,
      'employee': instance.employee,
    };
