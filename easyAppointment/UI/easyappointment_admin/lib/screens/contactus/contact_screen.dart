import 'package:flutter/material.dart';

import '../../widgets/master_screen.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'User Profile',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Contact Information',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Text(
              'Email: contact@example.com',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              'Phone: +1234567890',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
