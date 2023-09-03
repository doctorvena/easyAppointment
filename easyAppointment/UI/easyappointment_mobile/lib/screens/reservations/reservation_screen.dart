import 'package:easyappointment_mobile/models/salon.dart';
import 'package:easyappointment_mobile/screens/reservations/reservation_making_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/time-slot.dart';
import '../../providers/timeslot_provider.dart';

class ReservationScreen extends StatefulWidget {
  Salon salon;
  ReservationScreen({required this.salon, super.key});

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  late TimeSlotProvider _timeSlotProvider;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<TimeSlot> timeSlots = [];

  @override
  void initState() {
    super.initState();
    _timeSlotProvider = context.read<TimeSlotProvider>();
  }

  Future<void> GetTimeSlots(String _selectedDayFormated) async {
    var data = await _timeSlotProvider.get(
      filter: {
        'SalonId': widget.salon.salonId,
        'SearchDate': _selectedDayFormated, // Added SearchDate to filter
      },
    );
    print(data);
    setState(() {
      timeSlots = data.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservation'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              GetTimeSlots(DateFormat('yyyy-MM-dd').format(
                  _selectedDay!)); // Fetch timeslots whenever a new day is selected
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                if (date.isBefore(DateTime.now())) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // color: Colors.red,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${date.day}',
                      style: TextStyle().copyWith(color: Colors.red),
                    ),
                  );
                } else {
                  return Text(
                    '${date.day}',
                    style: TextStyle().copyWith(color: Colors.green),
                  );
                }
              },
            ),
          ),
          Divider(
            // This will add a one-line separator
            color: Colors.grey,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _selectedDay == null
                  ? "Select the Day" // If no day is selected
                  : timeSlots.isEmpty
                      ? "The selected day has no available time slots, please try another date" // If there are no time slots for the selected day
                      : "Select the time slot that suits you", // If there are time slots for the selected day
              style: TextStyle(
                fontSize: 16, // You can adjust the size
                fontWeight: FontWeight.bold, // You can adjust the weight
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                var timeSlot = timeSlots[index];
                var isTaken = timeSlot.status == "Taken";
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Neutral color for the button
                      onPrimary: Colors.black, // Text color
                      elevation: 5, // Elevation for the 3D effect
                      side: BorderSide(
                        color: isTaken
                            ? Colors.red
                            : Colors.green, // Colored indicator
                      ),
                    ),
                    onPressed: isTaken
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReservationDetailsScreen(
                                  selectedDay: _selectedDay!,
                                  selectedTimeSlot: timeSlots[index],
                                  salon: widget.salon,
                                ),
                              ),
                            );
                          },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(
                            isTaken ? Icons.close : Icons.check,
                            color: isTaken
                                ? Colors.red
                                : Colors.green, // Colored indicator
                          ),
                          Text(
                            '${DateFormat('hh:mm a').format(timeSlot.startTime!)} - ${DateFormat('hh:mm a').format(parseDateTime(timeSlot.endTime)!)}',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
