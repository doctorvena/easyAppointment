import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/reservation.dart';
import 'base_provider.dart';

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super("/Reservations");

  @override
  Reservation fromJson(data) {
    return Reservation.fromJson(data);
  }

  Future<List<Reservation>> getReservationsForEmployee(
      int employeeUserId) async {
    var url = "http://localhost:4000/Reservations/ByEmployee/$employeeUserId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return (data as List).map((item) => Reservation.fromJson(item)).toList();
    } else {
      throw Exception("Error fetching reservations.");
    }
  }
}
