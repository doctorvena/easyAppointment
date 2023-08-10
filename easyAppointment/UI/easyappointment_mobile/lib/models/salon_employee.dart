import 'package:easyappointment_mobile/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'salon_employee.g.dart';

@JsonSerializable()
class SalonEmployee {
  SalonEmployee(
    this.salonEmployeeId,
    this.salonId,
    this.employeeUserId,
    this.photo,
    this.firstName,
    this.lastName,
    this.username,
    this.phone,
    this.email,
    this.user,
  );

  final int? salonEmployeeId;
  final int? salonId;
  final int? employeeUserId;
  final String? photo;
  final String? firstName;
  final String? lastName;
  final String? username;
  final String? phone;
  final String? email;
  final User? user;

  /// A necessary factory constructor for creating a new EmployeeSalon instance
  /// from a map. Pass the map to the generated `_$EmployeeSalonFromJson()` constructor.
  /// The constructor is named after the source class, in this case, EmployeeSalon.
  factory SalonEmployee.fromJson(Map<String, dynamic> json) =>
      _$SalonEmployeeFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$EmployeeSalonToJson`.

  Map<String, dynamic> toJson() => _$SalonEmployeeToJson(this);
}
