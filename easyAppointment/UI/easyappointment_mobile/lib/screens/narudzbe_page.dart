import 'package:flutter/material.dart';

import '../widgets/home_page.dart';

class ReservationsPage extends StatelessWidget {
  const ReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: MasterScreenWidget(
        title: "Reservations",
        index: 1,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors
                  .black, // Change to a color that contrasts with your AppBar background
              unselectedLabelColor:
                  Colors.grey, // Change to a suitable color for unselected tabs

              tabs: [
                Tab(text: "Active Reservations"),
                Tab(text: "Past Reservations"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _ActiveReservationsTab(),
                  _PastReservationsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveReservationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Center(
        child: Text('Display active reservations here.'),
      ),
    );
  }
}

class _PastReservationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Center(
        child: Text('Display past reservations here.'),
      ),
    );
  }
}
