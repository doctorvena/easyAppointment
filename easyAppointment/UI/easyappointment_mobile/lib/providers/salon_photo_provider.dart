import 'package:easyappointment_mobile/providers/base_provider.dart';

import '../models/salon-photo.dart';

class SalonPhotoProvider extends BaseProvider<SalonPhoto> {
  SalonPhotoProvider() : super("/SalonPhoto");

  @override
  SalonPhoto fromJson(data) {
    return SalonPhoto.fromJson(data);
  }
}
