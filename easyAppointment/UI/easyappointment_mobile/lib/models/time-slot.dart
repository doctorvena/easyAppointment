import 'package:easyappointment_mobile/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'time-slot.g.dart';

@JsonSerializable()
class TimeSlot {
  TimeSlot(
    this.timeSlotId,
    this.startTime,
    this.endTime,
    this.salonId,
    this.employeeId,
    this.slotDate,
    this.duration,
    this.businessId,
    this.status,
    this.employee,
  );

  int? timeSlotId;
  DateTime? startTime;
  String? endTime;
  int? salonId;
  int? employeeId;
  String? slotDate;
  int? duration;
  int? businessId;
  String? status;
  User? employee;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$TimeSlotToJson(this);
}
