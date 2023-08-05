// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../screens/navigation_bar.dart';
import '../utils/user_singleton.dart';
import 'login_page.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  int index;
  Widget? title_widget;
  bool hideNavBar;

  MasterScreenWidget(
      {this.child,
      this.title,
      this.title_widget,
      required this.index,
      this.hideNavBar = false,
      Key? key})
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
      body: widget.child!,
      bottomNavigationBar:
          widget.hideNavBar ? null : NavigationBarPage(index: widget.index),
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
