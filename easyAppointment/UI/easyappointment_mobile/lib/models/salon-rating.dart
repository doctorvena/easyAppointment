// ignore: unused_import
import 'dart:typed_data';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';

/// This allows the `SalonRating` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'salon-rating.g.dart';

@JsonSerializable()
class SalonRating {
  SalonRating(
    this.salonRatingId,
    this.rating,
    this.ratingDate,
    this.userId,
    this.comment,
    this.salonId,
  );

  final int? salonRatingId;
  final int? rating;
  final DateTime? ratingDate;
  final int? userId;
  final String? comment;
  final int? salonId;

  /// A necessary factory constructor for creating a new SalonRating instance
  /// from a map. Pass the map to the generated `_$SalonRatingFromJson()` constructor.
  factory SalonRating.fromJson(Map<String, dynamic> json) =>
      _$SalonRatingFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$SalonRatingToJson`.
  Map<String, dynamic> toJson() => _$SalonRatingToJson(this);
}
