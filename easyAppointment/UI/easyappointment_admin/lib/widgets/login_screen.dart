import 'package:eprodaja_admin/screens/reservations/reservations_overview.dart';
import 'package:eprodaja_admin/screens/salon/salon_screen.dart';
import 'package:eprodaja_admin/widgets/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/app/user_singleton.dart';
import '/providers/salon_provider.dart';
import '/providers/user_provider.dart';
import '/utils/utils.dart';
import '../providers/employee_salon_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late UserProvider _userProvider;
  late SalonEmployeeProvider _salonEmployeeProvider;
  late SalonProvider _salonProvider;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _salonEmployeeProvider = context.read<SalonEmployeeProvider>();
    _salonProvider = context.read<SalonProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Remove back button
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
                      labelText: "UserName",
                      prefixIcon: Icon(Icons.email),
                    ),
                    controller: _userNameController,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.password),
                    ),
                    obscureText: true,
                    controller: _passwordController,
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: isLoading ? null : _loginUser,
                    child:
                        isLoading ? CircularProgressIndicator() : Text("Login"),
                  ),
                  TextButton(
                    onPressed: _navigateToRegistrationPage,
                    child: Text("Don't have an account?"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loginUser() async {
    var username1 = _userNameController.text.trim();
    var password1 = _passwordController.text.trim();

    if (username1.isEmpty || password1.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Error"),
          content: Text("Both username and password are required."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    setState(
      () {
        isLoading = true;
      },
    );

    var username = _userNameController.text;
    var password = _passwordController.text;
    Authorization.username = username;
    Authorization.password = password;

    try {
      var loginResponse = await _userProvider.login(username, password);

      if (loginResponse == null || loginResponse.user == null) {
        throw Exception('User login failed');
      }

      UserSingleton().loggedInUserId = loginResponse.user!.userId!;
      UserSingleton().jwtToken = loginResponse.token;
      UserSingleton().role =
          loginResponse.user!.userRoles![0].role?.roleName ?? '';

      if (UserSingleton().role != 'Employee') {
        try {
          var loggedUserSalon = await _salonProvider.get(
            filter: {'ownerUserId': UserSingleton().loggedInUserId},
          );

          if (loggedUserSalon != null &&
              loggedUserSalon.result[0].salonId != null) {
            UserSingleton().loggedInUserSalon = loggedUserSalon.result[0];
          }
        } catch (e) {}
      }

      if (UserSingleton().role == 'Employee') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ReservationsOverview(),
          ),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SalonPage(),
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                setState(
                  () {
                    isLoading = false;
                  },
                );
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _navigateToRegistrationPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RegistrationPage(),
      ),
    );
  }
}
