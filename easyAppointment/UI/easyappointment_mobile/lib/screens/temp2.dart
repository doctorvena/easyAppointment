import 'package:easyappointment_mobile/models/reservation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/reservation_provider.dart';

class ReservationsList extends StatelessWidget {
  final List<Reservation> reservations;
  final ReservationProvider reservationProvider;
  final void Function(Reservation)? onReservationCancel;

  ReservationsList({
    required this.reservations,
    required this.reservationProvider,
    this.onReservationCancel,
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
          // Formatting the date and time
          String formattedDate = DateFormat('dd MMM yyyy, EEEE')
              .format(reservations[index].reservationDate!);
          String formattedTime = DateFormat('HH:mm')
              .format(reservations[index].timeslots![0].startTime as DateTime);

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

      Navigator.pop(context); // Close the dialog

      if (onReservationCancel != null) {
        onReservationCancel!(reservation);
      }
    } catch (e) {
      print('Error canceling reservation: $e');
      // Add additional error handling here
    }
  }
}
