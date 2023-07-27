// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time-slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
      json['timeSlotId'] as int?,
      json['startTime'] as String?,
      json['endTime'] as String?,
      json['businessId'] as int?,
      json['duration'] as String?,
    );

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
      'timeSlotId': instance.timeSlotId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'businessId': instance.businessId,
      'duration': instance.duration,
    };
