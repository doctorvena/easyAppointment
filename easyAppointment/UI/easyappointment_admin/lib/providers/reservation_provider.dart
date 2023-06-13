import 'package:eprodaja_admin/providers/base_provider.dart';

import '../models/reservation.dart';

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super("/Reservations");

  @override
  Reservation fromJson(data) {
    // TODO: implement fromJson
    return Reservation.fromJson(data);
  }
}
