import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

@JsonSerializable()
class Role {
  Role(
    this.roleId,
    this.roleName,
    this.description,
  );

  int? roleId;
  String? roleName;
  String? description;

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
