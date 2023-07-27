import 'package:flutter/material.dart';

import '../widgets/home_page.dart';

class NarudzbePage extends StatelessWidget {
  const NarudzbePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(
      title: "narudzbe",
      index: 2,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
      ),
    );
  }
}
