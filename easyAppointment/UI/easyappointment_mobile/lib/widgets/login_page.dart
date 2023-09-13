import 'package:easyappointment_mobile/providers/timeslot_provider.dart';
import 'package:easyappointment_mobile/providers/user_provider.dart';
import 'package:easyappointment_mobile/widgets/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/salon_list.dart';
import '../utils/user_singleton.dart';
import '../utils/utils.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  UserProvider? _userProvider;
  TimeSlotProvider? _timeslotProvider;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = context.read<UserProvider>();
    _timeslotProvider = context.read<TimeSlotProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Login"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: _buildLoginForm(context),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 250,
          height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/EsayAppLogo.png"),
              fit: BoxFit.cover,
            ),
          ),
          margin: const EdgeInsets.only(top: 15),
        ),
        const Text(
          "Započni",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildUserNameField(),
                const SizedBox(height: 20.0),
                _buildPasswordField(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14.0),
        ElevatedButton(
          onPressed: isLoading ? null : _loginUser,
          child: isLoading ? CircularProgressIndicator() : const Text("Login"),
        ),
        const SizedBox(height: 14.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            TextButton(
              onPressed: () {
                _passwordController.clear();
                _userNameController.clear();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ),
                );
              },
              child: const Text("Register"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserNameField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 118, 114, 114),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: TextFormField(
          controller: _userNameController,
          validator: (value) {
            if (value!.trim().isEmpty) {
              return "Enter username";
            } else {
              return value.trim().length < 3
                  ? 'Minimum character length is 3'
                  : null;
            }
          },
          decoration: const InputDecoration(
            hintStyle: TextStyle(fontSize: 16),
            border: InputBorder.none,
            icon: Icon(Icons.person),
            hintText: "Username",
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 118, 114, 114),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: TextFormField(
          controller: _passwordController,
          validator: (value) {
            if (value!.trim().isEmpty) {
              return "Enter password";
            } else {
              return value.trim().length < 3
                  ? 'Minimum character length is 3'
                  : null;
            }
          },
          obscureText: true,
          decoration: const InputDecoration(
            hintStyle: TextStyle(fontSize: 16),
            border: InputBorder.none,
            icon: Icon(Icons.lock),
            hintText: "Password",
          ),
        ),
      ),
    );
  }

  void _loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    var username = _userNameController.text;
    var password = _passwordController.text;

    Authorization.username = username;
    Authorization.password = password;

    try {
      var loginResponse = await _userProvider?.loginUser(username, password);

      var loggedUser = loginResponse?.user;

      if (loggedUser == null) {
        throw Exception('User data not provided after login.');
      }

      UserSingleton().loggedInUserId = loggedUser.userId!;
      UserSingleton().role = loggedUser.userRoles![0].role?.roleName ?? '';

      if (UserSingleton().role != 'Customer') {
        throw Exception('Only Customers can login here!');
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SalonListScreen(),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  isLoading = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}
