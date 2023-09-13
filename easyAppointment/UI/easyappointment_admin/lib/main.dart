import 'package:eprodaja_admin/providers/city_provider.dart';
import 'package:eprodaja_admin/providers/employee_salon_provider.dart';
import 'package:eprodaja_admin/providers/reservation_provider.dart';
import 'package:eprodaja_admin/providers/salon_photo_provider.dart';
import 'package:eprodaja_admin/providers/salon_provider.dart';
import 'package:eprodaja_admin/providers/timeslot_provider.dart';
import 'package:eprodaja_admin/providers/user_provider.dart';
import 'package:eprodaja_admin/widgets/login_screen.dart';
import 'package:eprodaja_admin/widgets/navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TimeSlotProvider()),
      ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => SalonProvider()),
      ChangeNotifierProvider(create: (_) => SalonEmployeeProvider()),
      ChangeNotifierProvider(create: (_) => SalonPhotoProvider()),
      ChangeNotifierProvider(create: (_) => CityProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: LoginPage(),
        navigatorKey: navigatorKey);
  }
}
