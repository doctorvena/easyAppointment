// ignore_for_file: prefer_const_constructors, unnecessary_cast

import 'package:eprodaja_admin/app/user_singleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/search_result.dart';
import '../../models/time-slot.dart';
import '../../providers/timeslot_provider.dart';
import '../../widgets/master_screen.dart';
import 'add_time_slot_screen.dart';

class TimeSlotOverviewScreen extends StatefulWidget {
  const TimeSlotOverviewScreen({super.key});

  @override
  State<TimeSlotOverviewScreen> createState() => _TimeSlotOverviewScreenState();
}

class _TimeSlotOverviewScreenState extends State<TimeSlotOverviewScreen> {
  late TimeSlotProvider _timeslotprovider;
  searchResult<TimeSlot>? result;

  @override
  void initState() {
    super.initState();
    _timeslotprovider = context.read<TimeSlotProvider>();

    // Perform actions or initialize data when the page loads
    fetchData();
    initializeData();
  }

  Future<void> fetchData() async {
    var data;
    if (UserSingleton().role == 'Employee') {
      data = await _timeslotprovider
          .get(filter: {'EmployeeId': UserSingleton().loggedInUserId});
    } else {
      data = await _timeslotprovider
          .get(filter: {'SalonId': UserSingleton().loggedInUserSalon?.salonId});
    }

    setState(() {
      result = data as searchResult<TimeSlot>?;
    });
  }

  void initializeData() {
    // Initialize data or perform any other necessary setup
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "TimeSlot",
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: AddTimeSlotPage(),
                        ),
                      );
                    },
                  ).then((value) {
                    if (value != null && value) {
                      fetchData();
                    }
                  });
                },
                child: Text('Add Time Slot'),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Card(
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Start time',
                            style: TextStyle(fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'End time',
                            style: TextStyle(fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Employee',
                            style: TextStyle(fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Duration',
                            style: TextStyle(fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Expanded(
                          child: Text(
                            'Status',
                            style: TextStyle(fontStyle: FontStyle.normal),
                          ),
                        ),
                      ),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: result?.result
                            .map(
                              (TimeSlot e) => DataRow(
                                cells: [
                                  DataCell(Text(e.startTime ?? "")),
                                  DataCell(Text(e.endTime ?? "")),
                                  DataCell(
                                    Text(
                                      '${e.employee?.firstName ?? ""} ${e.employee?.lastName ?? ""}'
                                          .trim(),
                                    ),
                                  ),
                                  DataCell(Text(e.duration?.toString() ?? "")),
                                  DataCell(Text(e.status?.toString() ?? "")),
                                  DataCell(
                                    Row(
                                      children: [
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            deleteReservation(e.timeSlotId!);
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
      ),
    );
  }

  void deleteReservation(int timeslotId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this Time?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await _timeslotprovider.delete(timeslotId);
                  await fetchData();
                } catch (e) {
                  print('Error deleting reservation: $e');
                }
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
