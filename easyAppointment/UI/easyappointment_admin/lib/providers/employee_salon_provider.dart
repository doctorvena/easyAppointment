import 'package:eprodaja_admin/models/employee_salon.dart';
import 'package:eprodaja_admin/providers/base_provider.dart';

class SalonEmployeeProvider extends BaseProvider<SalonEmployee> {
  SalonEmployeeProvider() : super("/SalonEmployee");

  @override
  SalonEmployee fromJson(data) {
    // TODO: implement fromJson
    return SalonEmployee.fromJson(data);
  }
}
