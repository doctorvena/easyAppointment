import 'package:eprodaja_admin/models/salon.dart';
import 'package:eprodaja_admin/providers/base_provider.dart';

class SalonProvider extends BaseProvider<Salon> {
  SalonProvider() : super("/Salon");

  @override
  Salon fromJson(data) {
    // TODO: implement fromJson
    return Salon.fromJson(data);
  }
}
