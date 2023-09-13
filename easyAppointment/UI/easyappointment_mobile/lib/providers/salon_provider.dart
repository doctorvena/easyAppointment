import 'dart:convert';

import 'package:easyappointment_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

import '../models/salon.dart';
import '../models/search_result.dart';

class SalonProvider extends BaseProvider<Salon> {
  SalonProvider() : super("/Salon");

  @override
  Salon fromJson(data) {
    return Salon.fromJson(data);
  }

  Future<searchResult<Salon>> getRecommended(int salonId) async {
    var url = "http://10.0.2.2:4000/RecomendedSalon/$salonId";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = searchResult<Salon>();

      for (var item in data) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<int> getLastRatedSalonByUserId(int userId) async {
    var url = "http://10.0.2.2:4000/Salon/LastRatedSalonByUser/$userId";

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data['salonId'] ?? 0;
    } else {
      throw Exception("Unknown error");
    }
  }
}
