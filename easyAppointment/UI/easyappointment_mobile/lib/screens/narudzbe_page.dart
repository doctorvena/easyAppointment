import 'package:easyappointment_mobile/models/reservation.dart';
import 'package:easyappointment_mobile/utils/user_singleton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/reservation_provider.dart';
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
                    },
                    onDataChanged: fetchReservations,
                  ),
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

class ReservationsList extends StatelessWidget {
  final List<Reservation> reservations;
  final ReservationProvider reservationProvider;
  final void Function(Reservation)? onReservationCancel;
  final Function? onDataChanged;

  ReservationsList({
    required this.reservations,
    required this.reservationProvider,
    this.onReservationCancel,
    this.onDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (reservations.isEmpty) {
      return Center(child: Text('No reservations found.'));
    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      child: ListView.builder(
        itemCount: reservations.length,
        itemBuilder: (ctx, index) {
          // ... // Keep everything else unchanged
          // Formatting the date and time
          String formattedDate = DateFormat('dd MMM yyyy, EEEE')
              .format(reservations[index].reservationDate!);
          String formattedTime = DateFormat('HH:mm')
              .format(reservations[index].timeSlots![0].startTime as DateTime);

          // Setting the indicator color based on the status
          Color indicatorColor = Colors.transparent;
          if (reservations[index].status == "Canceled") {
            indicatorColor = Colors.grey;
          } else if (reservations[index].status == "Completed") {
            indicatorColor = Colors.lightBlue;
          } else if (reservations[index].status == "Active") {
            indicatorColor = Colors.limeAccent;
          }

          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: indicatorColor,
              ),
              title: Text('Date: $formattedDate'),
              subtitle: Text(
                  'Time: $formattedTime - Salon: ${reservations[index].salonId}'),
              trailing: reservations[index].status == "Active"
                  ? ElevatedButton(
                      onPressed: () {
                        showAlertDialog(context, reservations[index]);
                      },
                      child: Text('Cancel'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent, // button's fill color
                      ),
                    )
                  : Text(reservations[index].status.toString()),
            ),
          );
        },
      ),
    );
  }

  void showAlertDialog(BuildContext context, Reservation reservation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Do you really want to cancel this reservation?'),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              cancelReservation(context, reservation);

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> cancelReservation(
      BuildContext context, Reservation reservation) async {
    try {
      final dynamic requestData = {
        "status": "Canceled",
        "timeSlotId": reservation.timeSlotId,
        "reservationName": reservation.reservationName,
        "reservationDate":
            DateTime.parse(reservation.reservationDate.toString())
                .toUtc()
                .toIso8601String()
      };
      await reservationProvider.update(reservation.reservationId!, requestData);

      if (onReservationCancel != null) {
        onReservationCancel!(reservation);
      }

      if (onDataChanged != null) {
        onDataChanged!();
      }
    } catch (e) {}
  }
}

// Your Reservation, ReservationProvider, UserSingleton, etc. classes would also be defined in the same file or imported at the top if they are in separate files.
