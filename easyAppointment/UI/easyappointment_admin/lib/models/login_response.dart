import 'package:eprodaja_admin/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  LoginResponse(this.token, this.responseMsg, this.user);

  String? token;
  dynamic responseMsg; // Use appropriate type or a model if needed
  User? user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
