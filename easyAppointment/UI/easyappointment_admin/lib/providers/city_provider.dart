import 'package:eprodaja_admin/providers/base_provider.dart';

import '../models/city.dart';

class CityProvider extends BaseProvider<City> {
  CityProvider() : super("/City");

  @override
  City fromJson(data) {
    // TODO: implement fromJson
    return City.fromJson(data);
  }
}
