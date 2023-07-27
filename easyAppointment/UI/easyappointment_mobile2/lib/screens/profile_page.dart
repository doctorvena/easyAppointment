import 'package:flutter/material.dart';

import '../widgets/home_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(
      title: "profile",
      index: 2,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
      ),
    );
  }
}
