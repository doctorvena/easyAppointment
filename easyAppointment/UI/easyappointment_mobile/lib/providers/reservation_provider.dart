import '../models/reservation.dart';
import 'base_provider.dart';

class ReservationProvider extends BaseProvider<Reservation> {
  ReservationProvider() : super("/Reservations");

  @override
  Reservation fromJson(data) {
    // TODO: implement fromJson
    return Reservation.fromJson(data);
  }
}
