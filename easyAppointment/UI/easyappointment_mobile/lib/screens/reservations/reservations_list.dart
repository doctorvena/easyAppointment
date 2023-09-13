import 'package:easyappointment_mobile/providers/salon_rating_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/reservation.dart';
import '../../providers/reservation_provider.dart';
import 'dialogs_and_alerts.dart';

class ReservationsList extends StatelessWidget {
  final List<Reservation> reservations;
  final ReservationProvider reservationProvider;
  final SalonRatingProvider? salonRatingProvider;

  final Function() onReservationUpdated;

  ReservationsList({
    required this.reservations,
    required this.reservationProvider,
    required this.onReservationUpdated,
    this.salonRatingProvider,
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
          String formattedDate = DateFormat('dd MMM yyyy, EEEE')
              .format(reservations[index].reservationDate!);
          String formattedTime = DateFormat('HH:mm')
              .format(reservations[index].timeSlots![0].startTime as DateTime);

          Color indicatorColor = Colors.transparent;
          if (reservations[index].status == "Canceled") {
            indicatorColor = Colors.grey;
          } else if (reservations[index].status == "Completed") {
            indicatorColor = Colors.lightBlue;
          } else if (reservations[index].status == "Active") {
            indicatorColor = Colors.limeAccent;
          }

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: indicatorColor,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: $formattedDate'),
                        Text(
                            'Time: $formattedTime - Salon: ${reservations[index].salonId}'),
                        // Text(
                        //     'Price: \$${reservations[index].price.toString}'), // Displaying price
                        Text(
                            'Paid: ${reservations[index].isPaid != null && reservations[index].isPaid! ? "Yes" : "No"}'),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(reservations[index].status.toString()),
                          ),
                          if (reservations[index].rating != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Row(
                                children: [
                                  Text('${reservations[index].rating}'),
                                  Icon(Icons.star, color: Colors.yellow),
                                ],
                              ),
                            ),
                          if (reservations[index].rating == null &&
                              reservations[index].status != "Active")
                            IconButton(
                              onPressed: () {
                                _showRatingDialog(context, reservations[index]);
                              },
                              icon: Icon(Icons.rate_review, color: Colors.blue),
                            ),
                          if (reservations[index].status == "Active")
                            ElevatedButton(
                              onPressed: () {
                                showAlertDialog(context, reservations[index],
                                    () {}, cancelReservation);
                              },
                              child: Text('Cancel'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> cancelReservation(
      BuildContext context, Reservation reservation) async {
    try {
      final dynamic requestData = {
        "status": "Canceled",
        "timeSlotId": reservation.timeSlotId,
        "rating": reservation.rating,
        "isPaid": reservation.isPaid,
        "reservationName": reservation.reservationName,
        "reservationDate":
            DateTime.parse(reservation.reservationDate.toString())
                .toUtc()
                .toIso8601String()
      };
      await reservationProvider.update(reservation.reservationId!, requestData);

      onReservationUpdated();
    } catch (e) {}
  }

  Future<void> _showRatingDialog(
      BuildContext context, Reservation reservation) async {
    int selectedRating = 0;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rate the experience'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          Icons.star,
                          color: index < selectedRating
                              ? Colors.yellow
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text('Rate'),
                    onPressed: () {
                      if (selectedRating == 0) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error!'),
                              content: Text(
                                  'Please select a valid rating before submitting.'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Okay'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        insertSalonRating(
                            selectedRating, salonRatingProvider!, reservation);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Thanks for rating!')),
                        );
                      }
                    },
                  ),
                  TextButton(
                    child: Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> insertSalonRating(
      int rating, SalonRatingProvider provider, Reservation reservation) async {
    try {
      final dynamic requestData = {
        "rating": rating,
        "ratingDate": DateTime.now().toIso8601String(),
        "userId": reservation.userCustomerId,
        "salonId": reservation.salonId
      };

      await provider.insert(requestData);
    } catch (e) {
      throw Exception("Unknown error");
    }

    try {
      final dynamic requestData = {
        "status": reservation.status,
        "rating": rating,
        "isPaid": reservation.isPaid,
        "timeSlotId": reservation.timeSlotId,
        "reservationName": reservation.reservationName,
        "reservationDate":
            DateTime.parse(reservation.reservationDate.toString())
                .toUtc()
                .toIso8601String()
      };
      await reservationProvider.update(reservation.reservationId!, requestData);
      onReservationUpdated();
    } catch (e) {
      throw Exception("Unknown error $e");
    }
  }
}
