import 'package:easyappointment_mobile/models/reservation.dart';
import 'package:easyappointment_mobile/providers/reservation_provider.dart';
import 'package:easyappointment_mobile/providers/salon_rating_provider.dart';
import 'package:easyappointment_mobile/utils/user_singleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/home_page.dart';
import 'reservations_list.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({Key? key}) : super(key: key);

  @override
  ReservationsPageState createState() => ReservationsPageState();
}

class ReservationsPageState extends State<ReservationsPage> {
  late ReservationProvider _reservationProvider;
  late SalonRatingProvider _salonRatingProvider;
  List<Reservation> activeReservations = [];
  List<Reservation> pastReservations = [];

  @override
  void initState() {
    super.initState();
    _reservationProvider = context.read<ReservationProvider>();
    _salonRatingProvider = context.read<SalonRatingProvider>();
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    var activeData = await _reservationProvider.get(
      filter: {
        'IsActive': true,
        'userCustomerId': UserSingleton().loggedInUserId
      },
    );
    var pastData = await _reservationProvider.get(
      filter: {
        'IsActive': false,
        'userCustomerId': UserSingleton().loggedInUserId
      },
    );

    if (mounted) {
      setState(() {
        if (mounted) {
          activeReservations = activeData.result;
          pastReservations = pastData.result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MasterScreenWidget(
        title: "Reservations",
        index: 1,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: "Active Reservations"),
                Tab(text: "Past Reservations"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ReservationsList(
                    reservations: activeReservations,
                    reservationProvider: _reservationProvider,
                    onReservationUpdated: fetchReservations,
                  ),
                  ReservationsList(
                    reservations: pastReservations,
                    reservationProvider: _reservationProvider,
                    onReservationUpdated: fetchReservations,
                    salonRatingProvider: _salonRatingProvider,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
