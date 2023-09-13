import 'package:easyappointment_mobile/models/reservation.dart';
import 'package:flutter/material.dart';

void showAlertDialog(BuildContext context, Reservation reservation,
    Function cancelCallback, Function cancelReservationFunc) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmation'),
      content: Text('Do you really want to cancel this reservation?'),
      actions: [
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop();
            cancelReservationFunc(context, reservation);
          },
        ),
      ],
    ),
  );
}
