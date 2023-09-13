import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/user_singleton.dart';
import '../../models/reservation.dart';
import '../../models/search_result.dart';
import '../../providers/pdf_test2.dart';
import '../../providers/reservation_provider.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late ReservationProvider _reservationProvider;
  searchResult<Reservation>? result;

  @override
  void initState() {
    super.initState();
    // Initialize providers and fetch data here, if required
    _reservationProvider = context.read<ReservationProvider>();
    fetchData();
  }

  Future<void> fetchData() async {
    var data = await _reservationProvider.get(
      filter: {'salonId': UserSingleton().loggedInUserSalon?.salonId},
    );

    setState(() {
      result = data as searchResult<Reservation>?;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Izvještaji'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {},
              child: Text('Statistika otkazivanja'),
            ),
            SizedBox(height: 20), // Add some spacing between the buttons
            ElevatedButton(
              onPressed: () async {
                PdfReservationReportApi.generate(result!);
              },
              child: Text('Vrijeme rezervacije'),
            ),
          ],
        ),
      ),
    );
  }
}
