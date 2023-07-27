// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRole _$UserRoleFromJson(Map<String, dynamic> json) => UserRole(
      json['userRolesId'] as int?,
      json['userId'] as int?,
      json['roleId'] as int?,
      json['date'] as String?,
      json['role'] == null
          ? null
          : Role.fromJson(json['role'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserRoleToJson(UserRole instance) => <String, dynamic>{
      'userRolesId': instance.userRolesId,
      'userId': instance.userId,
      'roleId': instance.roleId,
      'date': instance.date,
      'role': instance.role,
    };
