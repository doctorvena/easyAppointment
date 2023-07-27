import 'package:easyappointment_mobile/providers/base_provider.dart';

import '../models/salon.dart';

class SalonProvider extends BaseProvider<Salon> {
  SalonProvider() : super("/Salon");

  @override
  Salon fromJson(data) {
    return Salon.fromJson(data);
  }
}
