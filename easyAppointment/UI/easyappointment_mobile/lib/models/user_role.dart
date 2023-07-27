import 'package:easyappointment_mobile/models/role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_role.g.dart';

@JsonSerializable()
class UserRole {
  UserRole(this.userRolesId, this.userId, this.roleId, this.date, this.role);

  int? userRolesId;
  int? userId;
  int? roleId;
  String? date;
  Role? role;

  factory UserRole.fromJson(Map<String, dynamic> json) =>
      _$UserRoleFromJson(json);
  Map<String, dynamic> toJson() => _$UserRoleToJson(this);
}
