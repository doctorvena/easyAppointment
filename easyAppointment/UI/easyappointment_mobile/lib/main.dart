import 'package:easyappointment_mobile/providers/city_provider.dart';
import 'package:easyappointment_mobile/providers/navigation.dart';
import 'package:easyappointment_mobile/providers/reservation_provider.dart';
import 'package:easyappointment_mobile/providers/salon_employee_provider.dart';
import 'package:easyappointment_mobile/providers/salon_photo_provider.dart';
import 'package:easyappointment_mobile/providers/salon_provider.dart';
import 'package:easyappointment_mobile/providers/salon_rating_provider.dart';
import 'package:easyappointment_mobile/providers/timeslot_provider.dart';
import 'package:easyappointment_mobile/providers/user_provider.dart';
import 'package:easyappointment_mobile/widgets/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = (FlutterErrorDetails details) {
    print(details.toString());
  };
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TimeSlotProvider()),
      ChangeNotifierProvider(create: (_) => SalonEmployeeProvider()),
      ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => SalonProvider()),
      ChangeNotifierProvider(create: (_) => SalonRatingProvider()),
      ChangeNotifierProvider(create: (_) => SalonPhotoProvider()),
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
        navigatorKey: navigatorKey);
  }
}
