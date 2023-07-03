import 'package:json_annotation/json_annotation.dart';

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

  // A necessary factory constructor for creating a new City instance
  // from a map. Pass the map to the generated `_$CityFromJson()` constructor.
  // The constructor is named after the source class, in this case, City.
  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  // `toJson` is the convention for a class to declare support for serialization
  // to JSON. The implementation simply calls the private, generated
  // helper method `_$CityToJson`.
  Map<String, dynamic> toJson() => _$CityToJson(this);
}
