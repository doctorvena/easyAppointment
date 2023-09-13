import 'dart:convert';

import 'package:eprodaja_admin/models/salon.dart';
import 'package:eprodaja_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class SalonProvider extends BaseProvider<Salon> {
  SalonProvider() : super("/Salon");

  @override
  Salon fromJson(data) {
    return Salon.fromJson(data);
  }

  Future<Salon?> getSalonByEmployeeId(int employeeId) async {
    var url = "http://localhost:4000/Salon/$employeeId";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      if (response.body.isEmpty) {
        return null;
      } else {
        var data = jsonDecode(response.body);
        return fromJson(data) as Salon;
      }
    } else {
      throw Exception('Unknown error');
    }
  }
}
