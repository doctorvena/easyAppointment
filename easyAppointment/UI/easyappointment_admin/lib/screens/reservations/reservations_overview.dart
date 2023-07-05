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
      filter: {'salonId': UserSingleton().loggedInUserSalon.salonId},
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
      title: 'Reservations - ${UserSingleton().loggedInUserSalon.salonName}',
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
                      salonId: UserSingleton().loggedInUserSalon.salonId,
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
                          'Reservation ID',
                          style: const TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: const Expanded(
                        child: const Text(
                          'Time Slot ID',
                          style: const TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
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
                          'Reservation Nmae',
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
                      label: Text('Delete'),
                    ),
                  ],
                  rows: result?.result
                          .map(
                            (Reservation e) => DataRow(
                              cells: [
                                DataCell(Text(e.reservationId.toString())),
                                DataCell(Text(e.timeSlotId.toString())),
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
                                      ? Text(e.timeSlots![0].endTime.toString())
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
}
