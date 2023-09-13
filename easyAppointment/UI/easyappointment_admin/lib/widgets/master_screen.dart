// ignore_for_file: prefer_const_constructors
import 'package:eprodaja_admin/screens/amployees/employee_page.dart';
import 'package:eprodaja_admin/screens/photos/salon_photos_screen.dart';
import 'package:eprodaja_admin/screens/reservations/reservations_overview.dart';
import 'package:eprodaja_admin/screens/salon/salon_screen.dart';
import 'package:flutter/material.dart';

import '../app/user_singleton.dart';
import '../screens/contactus/contact_screen.dart';
import '../screens/help/help_screen.dart';
import '../screens/profile/prfile_screen.dart';
import '../screens/time-slot/timeslot_list_screen.dart';
import 'login_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget;

  MasterScreenWidget({this.child, this.title, this.title_widget, Key? key})
      : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title_widget ?? Text(widget.title ?? ""),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            if (UserSingleton().role != 'Employee' &&
                UserSingleton().role != 'Customer') ...[
              ListTile(
                title: Text('Salon'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SalonPage(),
                    ),
                  );
                },
              ),
            ],
            ListTile(
              title: Text('TimeSlot'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TimeSlotOverviewScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Reservations'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ReservationsOverview(),
                  ),
                );
              },
            ),
            if (UserSingleton().role != 'Employee' &&
                UserSingleton().role != 'Customer') ...[
              ListTile(
                title: Text('Employee'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EmployeeOverview(),
                    ),
                  );
                },
              ),
            ],
            if (UserSingleton().role != 'Employee' &&
                UserSingleton().role != 'Customer') ...[
              ListTile(
                title: Text('Photos'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SalonPhotosPage(),
                    ),
                  );
                },
              ),
            ],
            ListTile(
              title: Text('Help'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HelpPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Contact'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ContactPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Profile Settings'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProfileSettingsPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: _showLogoutDialog,
            ),
          ],
        ),
      ),
      body: widget.child!,
    );
  }

  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                // Call the logoutUser function to log out the user
                UserSingleton().loggedInUserId = -1;
                UserSingleton().loggedInUserSalon?.salonId = -1;

                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Logout'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
