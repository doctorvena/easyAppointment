import 'package:eprodaja_admin/providers/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/user_singleton.dart';
import '../../models/time-slot.dart';
import '../../providers/timeslot_provider.dart';

class AddReservationPage extends StatefulWidget {
  final void Function() refreshData;
  final int? salonId;
  AddReservationPage({required this.salonId, required this.refreshData});

  @override
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  late TimeSlotProvider _timeSlotProvider;
  late ReservationProvider _reservationProvider;
  List<TimeSlot> timeSlots = [];
  TimeSlot? selectedTimeSlot;
  String? reservationName;

  @override
  void initState() {
    super.initState();
    _timeSlotProvider = context.read<TimeSlotProvider>();
    _reservationProvider = context.read<ReservationProvider>();
    fetchTimeSlots();
  }

  Future<void> fetchTimeSlots() async {
    var data = await _timeSlotProvider.get(
      filter: {'userBusinessId': UserSingleton().loggedInUserId},
    );
    setState(() {
      timeSlots = data.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reservation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Time Slot:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            DropdownButtonFormField<TimeSlot>(
              value: selectedTimeSlot,
              onChanged: (TimeSlot? newValue) {
                setState(() {
                  selectedTimeSlot = newValue;
                });
              },
              items: timeSlots
                  .map<DropdownMenuItem<TimeSlot>>((TimeSlot timeSlot) {
                return DropdownMenuItem<TimeSlot>(
                  value: timeSlot,
                  child: Text(timeSlot.startTime.toString()),
                );
              }).toList(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Reservation Name:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  reservationName = value;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (selectedTimeSlot != null && reservationName != null) {
                  final dynamic requestData = {
                    "salonId": widget.salonId,
                    "timeSlotId": selectedTimeSlot!.timeSlotId,
                    "reservationDate": DateTime.now().toIso8601String(),
                    "reservationName": reservationName!,
                  };

                  try {
                    // Create the reservation
                    await _reservationProvider.insert(requestData);
                    widget.refreshData();
                    // Reservation insertion successful
                  } catch (e) {
                    // Handle the error
                    print('Error creating reservation: $e');
                    // Show an error message or perform any necessary error handling
                  }

                  Navigator.pop(context);
                } else {
                  // Show an error message or validation message if the required fields are not filled
                }
              },
              child: Text('Create Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
