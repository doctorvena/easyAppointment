// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['userId'] as int?,
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['roleId'] as int?,
      json['email'] as String?,
      json['phone'] as String?,
      json['photo'] as String?,
      json['username'] as String?,
      json['password'] as String?,
      json['passwordRepeat'] as String?,
      json['status'] as String?,
      json['sexId'] as int?,
      (json['userRoles'] as List<dynamic>?)
          ?.map((e) => UserRole.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'roleId': instance.roleId,
      'email': instance.email,
      'phone': instance.phone,
      'photo': instance.photo,
      'username': instance.username,
      'password': instance.password,
      'passwordRepeat': instance.passwordRepeat,
      'status': instance.status,
      'sexId': instance.sexId,
      'userRoles': instance.userRoles,
    };
