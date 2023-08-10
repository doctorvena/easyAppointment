import 'package:easyappointment_mobile/screens/temp2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/reservation.dart';
import '../providers/reservation_provider.dart';
import '../utils/user_singleton.dart';
import '../widgets/home_page.dart';

class ReservationsPage extends StatefulWidget {
  const ReservationsPage({Key? key}) : super(key: key);

  @override
  ReservationsPageState createState() => ReservationsPageState();
}

class ReservationsPageState extends State<ReservationsPage> {
  late ReservationProvider _reservationProvider;
  List<Reservation> activeReservations = [];
  List<Reservation> pastReservations = [];

  @override
  void initState() {
    super.initState();
    _reservationProvider = context.read<ReservationProvider>();
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

    setState(() {
      if (mounted) {
        activeReservations = activeData.result;
        pastReservations = pastData.result;
      }
    });
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
                      onReservationCancel: (canceledReservation) {
                        setState(() {
                          activeReservations.remove(canceledReservation);
                          pastReservations.add(canceledReservation);
                        });
                      }),
                  ReservationsList(
                      reservations: pastReservations,
                      reservationProvider: _reservationProvider),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
