// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_salon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

// employee_salon.g.dart

SalonEmployee _$SalonEmployeeFromJson(Map<String, dynamic> json) =>
    SalonEmployee(
      json['salonEmployeeId'] as int?,
      json['salonId'] as int?,
      json['employeeUserId'] as int?,
      json['photo'] as String?,
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['username'] as String?,
      json['phone'] as String?,
      json['email'] as String?,
    );

Map<String, dynamic> _$SalonEmployeeToJson(SalonEmployee instance) =>
    <String, dynamic>{
      'salonEmployeeId': instance.salonEmployeeId,
      'salonId': instance.salonId,
      'employeeUserId': instance.employeeUserId,
      'photo': instance.photo,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'username': instance.username,
      'phone': instance.phone,
      'email': instance.email,
    };
