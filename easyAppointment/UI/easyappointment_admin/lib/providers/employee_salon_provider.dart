import 'dart:convert';

import 'package:eprodaja_admin/app/user_singleton.dart';
import 'package:eprodaja_admin/models/employee_salon.dart';
import 'package:eprodaja_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class SalonEmployeeProvider extends BaseProvider<SalonEmployee> {
  SalonEmployeeProvider() : super("/SalonEmployee");

  @override
  SalonEmployee fromJson(data) {
    // TODO: implement fromJson
    return SalonEmployee.fromJson(data);
  }

  Future<SalonEmployee> addEmplyeeAsOwner(String username) async {
    var salonId = UserSingleton().loggedInUserSalon!.salonId;
    var url =
        "http://localhost:4000/SalonEmployee/AddSalonEmployee?username=$username&salonId=$salonId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.post(uri, headers: headers);

    if (response.body.contains("Employee is already employed")) {
      throw new Exception("Employee is already employed!");
    }

    if (response.body.contains("User not found")) {
      throw new Exception("Employee not found!");
    }

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }
}
