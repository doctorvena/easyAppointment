// ignore_for_file: prefer_const_constructors, unnecessary_cast

import 'dart:math';

import 'package:eprodaja_admin/screens/time-slot/timeslot_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/search_result.dart';
import '../../models/time-slot.dart';
import '../../providers/timeslot_provider.dart';
import '../../widgets/master_screen.dart';

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
    var data = await _timeslotprovider.get(null);

    print("data: $data");

    setState(() {
      result = data as searchResult<TimeSlot>?;
    });
  }

  void initializeData() {
    // Initialize data or perform any other necessary setup
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "TimeSlot",
      child: Container(
        child: Column(children: [
          SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              // ignore: avoid_print
              // print("data: ${data.result[0].naziv}");
            },
            child: Text("Testic"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
                onPressed: () async {
                  _showMyDialog();
                },
                child: Text("Add new")),
          ),
          Expanded(
              child: Center(
                  child: SingleChildScrollView(
            child: DataTable(
                columns: const [
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Id',
                        style: TextStyle(fontStyle: FontStyle.normal),
                      ),
                    ),
                  ),
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
                        'Bussines Id',
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
                  DataColumn(label: Text('Actions')),
                ],
                rows: result?.result
                        .map((TimeSlot e) => DataRow(
                                onSelectChanged: (selected) => {
                                      if (selected == true)
                                        {
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             TimeSlotDetails(
                                          //               timeSlot: e,
                                          //             )))
                                        },
                                      print("selected ${e.duration}")
                                    },
                                cells: [
                                  DataCell(
                                      Text(e.timeSlotId?.toString() ?? "")),
                                  DataCell(Text(e.startTime ?? "")),
                                  DataCell(Text(e.endTime ?? "")),
                                  DataCell(
                                      Text(e.businessId?.toString() ?? "")),
                                  DataCell(Text(e.duration?.toString() ?? "")),
                                  DataCell(Row(children: [
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
                                  ]))
                                ]))
                        .toList() ??
                    []),
          )))
        ]),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: const Text(
              'Add new Time Slot',
            ),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: 300,
          ),
          content: TimeSlotDetails(
            timeSlot: null,
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
