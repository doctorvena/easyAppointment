import 'package:flutter/material.dart';

import '../../widgets/master_screen.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'User Profile',
      child: Center(
        child: Text(
          'Help Information',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
