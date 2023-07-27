import 'package:easyappointment_mobile/models/city.dart';

import '../models/time-slot.dart';
import 'package:easyappointment_mobile/providers/base_provider.dart';

class CityProvider extends BaseProvider<City> {
  CityProvider() : super("/City");

  @override
  City fromJson(data) {
    return City.fromJson(data);
  }
}
