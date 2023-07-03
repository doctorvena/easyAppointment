import 'package:json_annotation/json_annotation.dart';

part 'employee_salon.g.dart';

@JsonSerializable()
class SalonEmployee {
  SalonEmployee(
    this.salonEmployeeId,
    this.salonId,
    this.employeeUserId,
    this.photo,
  );
  final int? salonEmployeeId;
  final int? salonId;
  final int? employeeUserId;
  final String? photo;

  /// A necessary factory constructor for creating a new EmployeeSalon instance
  /// from a map. Pass the map to the generated `_$EmployeeSalonFromJson()` constructor.
  /// The constructor is named after the source class, in this case, EmployeeSalon.
  factory SalonEmployee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeSalonFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$EmployeeSalonToJson`.

  Map<String, dynamic> toJson() => _$EmployeeSalonToJson(this);
}
