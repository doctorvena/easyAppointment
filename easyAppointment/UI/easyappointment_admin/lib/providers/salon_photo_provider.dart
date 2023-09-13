import 'package:eprodaja_admin/models/salon_photo.dart';
import 'package:eprodaja_admin/providers/base_provider.dart';

class SalonPhotoProvider extends BaseProvider<SalonPhoto> {
  SalonPhotoProvider() : super("/SalonPhoto");

  @override
  SalonPhoto fromJson(data) {
    return SalonPhoto.fromJson(data);
  }
}
