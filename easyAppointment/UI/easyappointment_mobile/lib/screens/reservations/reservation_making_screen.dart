import 'package:easyappointment_mobile/models/reservation.dart';
import 'package:easyappointment_mobile/screens/reservations/reservation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/salon.dart';
import '../../models/time-slot.dart';
import '../../providers/reservation_provider.dart';
import '../../providers/timeslot_provider.dart';
import '../../utils/user_singleton.dart';

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
                    Reservation? reservation = await insertReservation(
                        context, selectedTimeSlot, salon);
                    if (reservation != null) {
                      showReservationDialog(
                          context, selectedDay, selectedTimeSlot, reservation);
                    }
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

  void showReservationDialog(BuildContext context, DateTime selectedDay,
      TimeSlot selectedTimeSlot, Reservation? reservation) {
    String formattedDate = DateFormat('MMMM d, y').format(selectedDay);
    String formattedStartTime =
        DateFormat('hh:mm a').format(selectedTimeSlot.startTime!);
    String formattedEndTime =
        DateFormat('hh:mm a').format(DateTime.parse(selectedTimeSlot.endTime!));
    String price = '20.00'; // Price for the reservation, adjust as needed

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Checkout'),
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
                SizedBox(height: 20), // Increased spacing for better clarity
                Divider(thickness: 1, color: Colors.grey[300]),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      '\$$price',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _initiatePayPalPayment(context, reservation!);
                  },
                  child: Text('Pay With PayPal'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal[900], // Deep dark green color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    textStyle: TextStyle(fontSize: 20, color: Colors.white),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<Reservation> insertReservation(
      BuildContext context, TimeSlot selectedTimeSlot, Salon salon) async {
    var _reservationProvider = context.read<ReservationProvider>();
    var _timeSlotProvider = context.read<TimeSlotProvider>();

    final dynamic requestData = {
      "salonId": salon.salonId,
      "timeSlotId": selectedTimeSlot.timeSlotId,
      "reservationDate": DateTime.now().toIso8601String(),
      "reservationName": "CUSTOMER_NAME_OR_ID", // Modify as needed
      "status": "Active",
      "userCustomerId": UserSingleton().loggedInUserId,
      "isPaid": false,
      "price": salon.reservationPrice
    };

    try {
      var reservation = await _reservationProvider.insert(requestData);

      final updateData = {
        'status': 'Taken',
      };
      await _timeSlotProvider.update(selectedTimeSlot.timeSlotId!, updateData);

      return reservation;
      Navigator.pop(context); // Close the dialog
    } catch (e) {
      throw Exception("Unknown error");
    }
  }

  Future<void> _updateReservationToPaid(
      BuildContext context, Reservation reservation) async {
    var _reservationProvider = context.read<ReservationProvider>();
    final dynamic requestData = {
      'status': reservation.status,
      'timeSlotId': reservation.timeSlotId,
      'isPaid': true,
      'reservationName': reservation.reservationName,
      'reservationDate': DateTime.parse(reservation.reservationDate.toString())
          .toUtc()
          .toIso8601String()
    };

    try {
      await _reservationProvider.update(
          reservation.reservationId!, requestData);
      print("i guess no eror");
    } catch (e) {
      print("Error updating reservation to paid: $e");
    }
  }

  Future<void> _initiatePayPalPayment(
      BuildContext context, Reservation? reservation) async {
    // Push the PaypalCheckout widget and await the result
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckout(
        sandboxMode: true,
        clientId:
            "AQVtndGBNOvKsEYlCtqZekj9s3kHnxsVtRoL7J8bJ4PXPj1oBOlHYCUV0JFTlz3dNUy-zjQDCOjTmFfn",
        secretKey:
            "ELIJEgHfwdmF-wIs-8p3oxMymarodznKIFj4BmoC5ST5pF9Uu8UMfxRF0GbkBmXkNn6ByKePxPC_mkKM",
        returnURL: "success.snippetcoder.com",
        cancelURL: "cancel.snippetcoder.com",
        transactions: const [
          {
            "amount": {
              "total": '20',
              "currency": "USD",
              "details": {
                "subtotal": '20',
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description": "Reservation Payment",
          }
        ],
        note: "Payment for reservation.",
        onSuccess: (Map params) async {
          if (reservation != null) {
            // Check if reservationId is not null
            await _updateReservationToPaid(context, reservation);
          }
          print("Payment success: $params");
          // Navigate to ReservationsPage and remove all previous routes
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => ReservationsPage()),
            (Route<dynamic> route) =>
                false, // this ensures that there are no other routes left in the navigation stack
          );
        },
        onError: (error) {
          print("Payment error: $error");
          Navigator.of(context).pop(false); // Pop with payment error flag
        },
        onCancel: () {
          print('Payment cancelled.');
          Navigator.of(context)
              .pop(false); // Pop with payment cancellation flag
        },
      ),
    ));
  }
}
