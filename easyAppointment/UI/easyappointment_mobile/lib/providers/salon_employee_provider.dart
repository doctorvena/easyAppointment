import '../models/salon_employee.dart';
import 'base_provider.dart';

class SalonEmployeeProvider extends BaseProvider<SalonEmployee> {
  SalonEmployeeProvider() : super("/SalonEmployee");

  @override
  SalonEmployee fromJson(data) {
    // TODO: implement fromJson
    return SalonEmployee.fromJson(data);
  }
}
