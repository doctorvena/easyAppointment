import 'package:easyappointment_mobile/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  LoginResponse(this.token, this.responseMsg, this.user, this.expiry);

  String? token;
  dynamic responseMsg; // Use appropriate type or a model if needed
  User? user;
  final DateTime? expiry;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
