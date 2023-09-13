// ignore: unused_import
import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'salon.g.dart';

@JsonSerializable()
class Salon {
  Salon(this.salonId, this.salonName, this.address, this.photo,
      this.ownerUserId, this.cityId, this.reservationPrice, this.rating);

  int? salonId;
  String? salonName;
  String? address;
  String? photo;
  int? ownerUserId;
  int? cityId;
  int? reservationPrice;
  double? rating;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Salon.fromJson(Map<String, dynamic> json) => _$SalonFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SalonToJson(this);
}
