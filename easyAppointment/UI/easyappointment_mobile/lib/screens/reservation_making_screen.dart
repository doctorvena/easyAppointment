import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/salon.dart';
import '../models/time-slot.dart';
import '../providers/reservation_provider.dart';
import '../providers/timeslot_provider.dart';
import '../utils/user_singleton.dart';
import 'narudzbe_page.dart';

class ReservationDetailsScreen extends StatelessWidget {
  final DateTime selectedDay;
  final TimeSlot selectedTimeSlot;
  final Salon salon;

  ReservationDetailsScreen({
    required this.selectedDay,
    required this.selectedTimeSlot,
    required this.salon,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMMM d, y').format(selectedDay);
    String formattedStartTime =
        DateFormat('hh:mm a').format(selectedTimeSlot.startTime!);
    String formattedEndTime =
        DateFormat('hh:mm a').format(DateTime.parse(selectedTimeSlot.endTime!));

    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  // Placeholder for employee picture
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time), // Clock icon
                        Text(' $formattedStartTime - $formattedEndTime'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_today), // Calendar icon
                        Text(' $formattedDate'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20), // Increased space
            Divider(thickness: 2),
            Text(
              salon.salonName.toString(), // Salon name
              style: TextStyle(fontSize: 28), // Larger font size, blue color
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Employee: ',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: selectedTimeSlot.employeeId.toString(),
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            Text(
              'Duration: ' +
                  selectedTimeSlot.duration.toString() +
                  ' min', // Duration
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await insertReservation(context, selectedTimeSlot, salon);
                    showReservationDialog(
                        context, selectedDay, selectedTimeSlot);
                  },
                  child: Text('Reserve!'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
                Text(
                  'Total Price: 20e', // Total price
                  style:
                      TextStyle(fontSize: 18, color: Colors.blue), // Blue color
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showReservationDialog(
      BuildContext context, DateTime selectedDay, TimeSlot selectedTimeSlot) {
    String formattedDate = DateFormat('MMMM d, y').format(selectedDay);
    String formattedStartTime =
        DateFormat('hh:mm a').format(selectedTimeSlot.startTime!);
    String formattedEndTime =
        DateFormat('hh:mm a').format(DateTime.parse(selectedTimeSlot.endTime!));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Reservation Confirmation'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'You made a reservation on:',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  '$formattedDate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$formattedStartTime - $formattedEndTime',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Pay With Card'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // Close the current dialog or popup
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const ReservationsPage()),
                      (Route<dynamic> route) =>
                          false, // This ensures all previous routes are removed
                    );
                  },
                  child: Text('Pay Later'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    textStyle: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> insertReservation(
      BuildContext context, TimeSlot selectedTimeSlot, Salon salon) async {
    var _reservationProvider = context.read<ReservationProvider>();
    var _timeSlotProvider = context.read<TimeSlotProvider>();

    final dynamic requestData = {
      "salonId": salon.salonId,
      "timeSlotId": selectedTimeSlot.timeSlotId,
      "reservationDate": DateTime.now().toIso8601String(),
      "reservationName": "CUSTOMER_NAME_OR_ID", // Modify as needed
      "status": "Active",
      "userCustomerId": UserSingleton().loggedInUserId
    };

    try {
      await _reservationProvider.insert(requestData);

      final updateData = {
        'status': 'Taken',
      };
      await _timeSlotProvider.update(selectedTimeSlot.timeSlotId!, updateData);
      Navigator.pop(context); // Close the dialog
    } catch (e) {}
  }
}
