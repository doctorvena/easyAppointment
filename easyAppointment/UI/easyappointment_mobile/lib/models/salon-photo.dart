// ignore: unused_import
import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'salon-photo.g.dart';

@JsonSerializable()
class SalonPhoto {
  SalonPhoto(this.salonId, this.photo, this.photoId);

  int? salonId;
  String? photo;
  int? photoId;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory SalonPhoto.fromJson(Map<String, dynamic> json) =>
      _$SalonPhotoFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SalonPhotoToJson(this);
}
