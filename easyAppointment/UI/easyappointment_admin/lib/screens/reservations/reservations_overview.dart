// ignore_for_file: prefer_const_constructors, unnecessary_import

import 'package:eprodaja_admin/models/reservation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/user_singleton.dart';
import '../../models/search_result.dart';
import '../../providers/reservation_provider.dart';
import '../../widgets/master_screen.dart';

class ReservationsOverview extends StatefulWidget {
  const ReservationsOverview({super.key});

  State<ReservationsOverview> createState() => _ReservationsOverviewState();
}

class _ReservationsOverviewState extends State<ReservationsOverview> {
  late ReservationProvider _reservationProvider;
  searchResult<Reservation>? result;

  @override
  void initState() {
    super.initState();

    _reservationProvider = context.read<ReservationProvider>();
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Reservations",
      child: Container(
        child: Column(
          children: [
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                var data = await _reservationProvider.get(
                    filter: {'userBusinessId': UserSingleton().loggedInUserId});

                setState(() {
                  result = data as searchResult<Reservation>?;
                });
              },
              child: Text("Testic"),
            ),
            Expanded(
              child: Center(
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
                        label: Text('Actions'),
                      ),
                    ],
                    rows: result?.result
                            .map(
                              (Reservation e) => DataRow(
                                onSelectChanged: (selected) {
                                  if (selected == true) {
                                    // Handle row selection
                                  }
                                },
                                cells: [
                                  DataCell(Text(e.reservationId.toString())),
                                  DataCell(Text(e.timeSlotId.toString())),
                                  DataCell(Text(e.reservationDate.toString())),
                                  DataCell(
                                    e.timeSlots != null &&
                                            e.timeSlots!.isNotEmpty
                                        ? Text(e.timeSlots![0].startTime
                                            .toString())
                                        : Text(''),
                                  ),
                                  DataCell(
                                    e.timeSlots != null &&
                                            e.timeSlots!.isNotEmpty
                                        ? Text(
                                            e.timeSlots![0].endTime.toString())
                                        : Text(''),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Edit action
                                          },
                                          child: Icon(Icons.edit),
                                        ),
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Delete action
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
}
