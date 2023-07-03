import 'package:json_annotation/json_annotation.dart';

part 'salon_photo.g.dart';

@JsonSerializable()
class SalonPhoto {
  final int? photoId;
  final String? photo;
  final int? salonId;

  SalonPhoto(
    this.photoId,
    this.photo,
    this.salonId,
  );

  factory SalonPhoto.fromJson(Map<String, dynamic> json) =>
      _$SalonPhotoFromJson(json);

  Map<String, dynamic> toJson() => _$SalonPhotoToJson(this);
}
