// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_salon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalonEmployee _$EmployeeSalonFromJson(Map<String, dynamic> json) =>
    SalonEmployee(
      json['salonEmployeeId'] as int?,
      json['salonId'] as int?,
      json['employeeUserId'] as int?,
      json['photo'] as String?,
    );

Map<String, dynamic> _$EmployeeSalonToJson(SalonEmployee instance) =>
    <String, dynamic>{
      'salonEmployeeId': instance.salonEmployeeId,
      'salonId': instance.salonId,
      'employeeUserId': instance.employeeUserId,
      'photo': instance.photo,
    };
