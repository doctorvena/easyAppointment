import 'package:eprodaja_admin/providers/city_provider.dart';
import 'package:eprodaja_admin/providers/employee_salon_provider%20copy.dart';
import 'package:eprodaja_admin/providers/reservation_provider.dart';
import 'package:eprodaja_admin/providers/salon_photo_provider.dart';
import 'package:eprodaja_admin/providers/salon_provider.dart';
import 'package:eprodaja_admin/providers/timeslot_provider.dart';
import 'package:eprodaja_admin/providers/user_provider.dart';
import 'package:eprodaja_admin/screens/reservations/reservations_overview.dart';
import 'package:eprodaja_admin/utils/utils.dart';
import 'package:eprodaja_admin/widgets/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/user_singleton.dart';

void main() {
  final timeOfDay = TimeOfDay(hour: 0, minute: 34);
  final formattedTime =
      '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}:00';

  print(formattedTime); // Output: 12:34:00

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
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.deepOrange,
      ),
      home: LoginPage(),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Easy Appointment",
      theme: ThemeData(primarySwatch: Colors.orange),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Easy App"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const TextField(
                decoration: InputDecoration(labelText: "Enter your UserName"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    print("test");
                  },
                  child: const Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  late UserProvider _userProvider;
  late SalonProvider _salonProvider;

  @override
  Widget build(BuildContext context) {
    _userProvider = context.read<UserProvider>();
    _salonProvider = context.read<SalonProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
          child: Container(
        constraints: BoxConstraints(maxHeight: 450, maxWidth: 450),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/EsayAppLogo.png",
                  height: 200,
                  width: 200,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: "UserName", prefixIcon: Icon(Icons.email)),
                  controller: _userNameController,
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  // ignore: prefer_const_constructors
                  decoration: InputDecoration(
                      labelText: "Password", prefixIcon: Icon(Icons.password)),
                  controller: _passwordController,
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () async {
                    var username = _userNameController.text;
                    var password = _passwordController.text;
                    // _passwordController.text = username;

                    print("login proceed $username $password");

                    Authorization.username = username;
                    Authorization.password = password;

                    try {
                      var loggedUser =
                          await _userProvider.loginUser(username, password);

                      if (loggedUser == null) {
                        throw Exception(
                            'User login failed'); // Throw exception if user is null
                      }

                      UserSingleton().loggedInUserId = loggedUser.userId!;
                      try {
                        var loggedUserSalon = await _salonProvider.get(
                          filter: {
                            'ownerUserId': UserSingleton().loggedInUserId
                          },
                        );

                        if (loggedUserSalon == null) {
                          throw Exception(
                              'User login failed'); // Throw exception if user is null
                        } else {
                          UserSingleton().loggedInUserSalon =
                              loggedUserSalon.result[0];
                          print(loggedUserSalon.result[0].salonId);
                          print(UserSingleton().loggedInUserSalon.salonId);
                        }
                      } catch (e) {}
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ReservationsOverview(),
                        ),
                      );
                    } on Exception catch (e) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Error"),
                          content: Text(e.toString()),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  child: Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegistrationPage(),
                      ),
                    );
                  },
                  child: Text("Dont't have account?"),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
