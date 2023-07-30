import 'package:flutter/material.dart';

import '../widgets/home_page.dart';

class NarudzbePage extends StatelessWidget {
  const NarudzbePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "narudzbe",
      index: 1,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
      ),
    );
  }
}
