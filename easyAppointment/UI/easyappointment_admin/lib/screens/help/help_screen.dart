import 'package:flutter/material.dart';

import '../../widgets/master_screen.dart';
import 'help_information.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Help Center',
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0), // Adjust the padding value as needed
          child: Text(
            HelpInformation.info,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
