import 'package:eprodaja_admin/providers/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
      filter: {
        'salonId': UserSingleton().loggedInUserSalon!.salonId,
        'status': 'Available',
        'AreEmployeesIncluded': true,
      },
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
        child: Card(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Select Time Slot:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () {
                    if (timeSlots.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('No Time Slots Available'),
                            content: Text(
                              'There are no available time slots. Please navigate to the Time Slots page and add a time slot first.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // Navigate to the Time Slots page
                                  // You can use the Navigator.push method to navigate to the desired page
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: DropdownButtonFormField<TimeSlot>(
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
                        child: Text(
                          '${DateFormat('EEEE, MMM dd, hh:mm a').format(parseDateTime(timeSlot.startTime)!)} - ${DateFormat('hh:mm a').format(parseDateTime(timeSlot.endTime)!)} ( ${timeSlot.employee?.firstName ?? ""} ${timeSlot.employee?.lastName ?? ""} )'
                              .trim(),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
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
                    fillColor: Colors.white,
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
                        "status": "Active"
                      };

                      try {
                        // Create the reservation
                        await _reservationProvider.insert(requestData);
                        widget.refreshData();
                        // Reservation insertion successful

                        if (selectedTimeSlot != null) {
                          final updateData = {
                            'status': 'taken',
                          };
                          await _timeSlotProvider.update(
                              selectedTimeSlot!.timeSlotId!, updateData);
                        }
                      } catch (e) {
                        // Handle the error
                        print('Error creating reservation: $e');
                        // Show an error message or perform any necessary error handling
                      }

                      Navigator.pop(context);
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Validation Error'),
                            content: Text(
                                'Please select a time slot and provide a reservation name.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Create Reservation'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime? parseDateTime(String? dateTimeString) {
    if (dateTimeString != null) {
      return DateTime.parse(dateTimeString);
    }
    return null;
  }
}
