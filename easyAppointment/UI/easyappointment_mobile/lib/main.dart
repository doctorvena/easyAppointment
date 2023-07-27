import 'package:easyappointment_mobile/providers/city_provider.dart';
import 'package:easyappointment_mobile/providers/salon_provider.dart';
import 'package:easyappointment_mobile/providers/timeslot_provider.dart';
import 'package:easyappointment_mobile/providers/user_provider.dart';
import 'package:easyappointment_mobile/widgets/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TimeSlotProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => SalonProvider()),
      ChangeNotifierProvider(create: (_) => CityProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyAppointment',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: LoginPage(),
    );
  }
}
