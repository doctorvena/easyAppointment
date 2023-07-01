// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time-slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
      json['timeSlotId'] as int?,
      json['startTime'] as String?,
      json['endTime'] as String?,
      json['serviceId'] as int?,
      json['employeeId'] as int?,
      json['slotDate'] as String?,
      json['duration'] as int?,
      json['businessId'] as int?,
    );

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
      'timeSlotId': instance.timeSlotId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'serviceId': instance.serviceId,
      'employeeId': instance.employeeId,
      'slotDate': instance.slotDate,
      'duration': instance.duration,
      'businessId': instance.businessId,
    };
