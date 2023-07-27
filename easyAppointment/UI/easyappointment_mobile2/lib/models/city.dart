// ignore_for_file: depend_on_referenced_packages

import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'city.g.dart';

@JsonSerializable()
class City {
  City(
    this.cityId,
    this.cityName,
    this.country,
  );

  int? cityId;
  String? cityName;
  String? country;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CityToJson(this);
}
