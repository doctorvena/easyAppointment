import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
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
              onPressed: () {
                // Logic for "Statistika otkazivanja" report generation
              },
              child: Text('Statistika otkazivanja'),
            ),
            SizedBox(height: 20), // Add some spacing between the buttons
            ElevatedButton(
              onPressed: () {
                // Logic for "Vrijeme rezervacije" report generation
              },
              child: Text('Vrijeme rezervacije'),
            ),
          ],
        ),
      ),
    );
  }
}
