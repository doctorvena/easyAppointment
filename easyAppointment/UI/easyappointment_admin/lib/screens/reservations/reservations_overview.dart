import 'package:eprodaja_admin/models/reservation.dart';
import 'package:eprodaja_admin/providers/salon_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../app/user_singleton.dart';
import '../../models/search_result.dart';
import '../../providers/reservation_provider.dart';
import '../../widgets/master_screen.dart';
import 'add_reservation_page.dart';

class ReservationsOverview extends StatefulWidget {
  const ReservationsOverview({Key? key}) : super(key: key);

  @override
  _ReservationsOverviewState createState() => _ReservationsOverviewState();
}

class _ReservationsOverviewState extends State<ReservationsOverview> {
  late ReservationProvider _reservationProvider;
  late SalonProvider _salonnProvider;
  searchResult<Reservation>? result;

  @override
  void initState() {
    super.initState();
    _reservationProvider = context.read<ReservationProvider>();
    _salonnProvider = context.read<SalonProvider>();
    fetchSalonId(); // Fetch the salon ID first
  }

  Future<void> fetchSalonId() async {
    // Fetch the salon ID that the user owns
    try {
      setState(() {});
      fetchData(); // Fetch reservations after getting the salon ID
    } catch (e) {
      // Handle error
      print('Error fetching salon ID: $e');
    }
  }

  Future<void> fetchData() async {
    var data = await _reservationProvider.get(
      filter: {'salonId': UserSingleton().loggedInUserSalon?.salonId},
    );

    setState(() {
      result = data as searchResult<Reservation>?;
    });
  }

  Future<void> refreshData() async {
    await fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Reservations',
      child: Column(
        children: [
          SizedBox(height: 8),
          Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddReservationPage(
                      salonId: UserSingleton().loggedInUserSalon?.salonId,
                      refreshData: refreshData,
                    ),
                  ),
                );
              },
              child: Text('Add Reservation Manualy'),
            ),
          ),
          Expanded(
            child: Card(
              color: Colors.grey[200],
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: const Expanded(
                        child: const Text(
                          'Reservation Date',
                          style: const TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: const Expanded(
                        child: const Text(
                          'Reservation Name',
                          style: const TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: const Expanded(
                        child: const Text(
                          'Start Time',
                          style: const TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: const Expanded(
                        child: const Text(
                          'End Time',
                          style: const TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: const Expanded(
                        child: const Text(
                          'Status',
                          style: const TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text('Completed'),
                    ),
                    DataColumn(
                      label: Text('Cancel'),
                    ),
                    DataColumn(
                      label: Text('Delete'),
                    ),
                  ],
                  rows: result?.result
                          .map(
                            (Reservation e) => DataRow(
                              cells: [
                                DataCell(
                                  e.reservationDate != null
                                      ? Text(
                                          DateFormat('EEEE, MMM dd, yyyy')
                                              .format(e.reservationDate!),
                                        )
                                      : Text(''),
                                ),
                                DataCell(Text(e.reservationName.toString())),
                                DataCell(
                                  e.timeSlots != null && e.timeSlots!.isNotEmpty
                                      ? Text(
                                          DateFormat('EEEE, HH:mm').format(
                                              parseDateTime(
                                                  e.timeSlots![0].startTime)!),
                                        )
                                      : Text(''),
                                ),
                                DataCell(
                                  e.timeSlots != null && e.timeSlots!.isNotEmpty
                                      ? Text(
                                          DateFormat('EEEE, HH:mm').format(
                                              parseDateTime(
                                                  e.timeSlots![0].endTime)!),
                                        )
                                      : Text(''),
                                ),
                                DataCell(
                                  Text(e.status.toString()),
                                  showEditIcon:
                                      false, // Optional: If you want an edit icon

                                  placeholder: false,
                                ),
                                DataCell(
                                  e.status == "Active"
                                      ? ElevatedButton(
                                          onPressed: () {
                                            completeReservation(e);
                                          },
                                          child: Text("Complete"),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green),
                                        )
                                      : Text(''),
                                ),
                                DataCell(
                                  e.status == "Active"
                                      ? ElevatedButton(
                                          onPressed: () {
                                            cancelReservation(e);
                                          },
                                          child: Text("Cancel"),
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red),
                                        )
                                      : Text(''),
                                ),
                                DataCell(
                                  Row(
                                    children: [
                                      SizedBox(width: 8),
                                      ElevatedButton(
                                        onPressed: () {
                                          deleteReservation(e.reservationId!);
                                        },
                                        child: Icon(Icons.delete),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          .toList() ??
                      [],
                ),
              ),
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

  void deleteReservation(int reservationId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this reservation?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  await _reservationProvider.delete(reservationId);
                  await fetchData(); // Refresh data after deletion
                } catch (e) {
                  // Handle the error
                  print('Error deleting reservation: $e');
                  // Show an error message or perform any necessary error handling
                }
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void completeReservation(Reservation reservation) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(
              'Are you sure you want to mark this reservation as complete?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  final dynamic requestData = {
                    "status": "Completed",
                    "timeSlotId": reservation.timeSlotId,
                    "rating": reservation.rating,
                    "isPaid": reservation.isPaid,
                    "reservationName": reservation.reservationName,
                    "reservationDate":
                        DateTime.parse(reservation.reservationDate.toString())
                            .toUtc()
                            .toIso8601String()
                  };
                  await _reservationProvider.update(
                      reservation.reservationId!, requestData);

                  // onReservationUpdated();
                } catch (e) {}
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void cancelReservation(Reservation reservation) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to cancel this reservation?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
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
                  await _reservationProvider.update(
                      reservation.reservationId!, requestData);

                  // onReservationUpdated();
                } catch (e) {}
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}
