// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['roleId'] as int?,
      json['email'] as String?,
      json['phone'] as String?,
      json['username'] as String?,
      json['password'] as String?,
      json['passwordRepeat'] as String?,
      json['status'] as String?,
      json['sexId'] as int?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'roleId': instance.roleId,
      'email': instance.email,
      'phone': instance.phone,
      'username': instance.username,
      'password': instance.password,
      'passwordRepeat': instance.passwordRepeat,
      'status': instance.status,
      'sexId': instance.sexId,
    };
