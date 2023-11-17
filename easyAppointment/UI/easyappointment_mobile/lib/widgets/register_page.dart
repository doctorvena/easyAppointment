// ignore_for_file: unused_import, must_be_immutable, unused_local_variable, unnecessary_null_comparison, unused_catch_stack, unused_element

import 'package:easyappointment_mobile/models/salon.dart';
import 'package:easyappointment_mobile/providers/user_provider.dart';
import 'package:easyappointment_mobile/widgets/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../screens/salon_list.dart';

class RegisterPage extends StatelessWidget {
  final _fromKey = GlobalKey<FormBuilderState>();
  late final UserProvider _userProvider = UserProvider();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: _userProvider),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
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
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //first name
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 118, 114, 114),
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: TextFormField(
                            controller: _firstNameController,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Enter First Name";
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
                              hintText: "First Name",
                            ),
                          ),
                        ),
                      ),
                      //last name
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 118, 114, 114),
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: TextFormField(
                            controller: _lastNameController,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Enter Last Name";
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
                              hintText: "Last Name",
                            ),
                          ),
                        ),
                      ),
                      //username
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 118, 114, 114),
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: TextFormField(
                            controller: _emailController,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Enter email";
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
                              hintText: "Email",
                            ),
                          ),
                        ),
                      ),
                      //username
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 118, 114, 114),
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: TextFormField(
                            controller: _usernameController,
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
                      ),
                      //password
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 118, 114, 114),
                            ),
                            borderRadius: BorderRadius.circular(8)),
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
                              icon: Icon(Icons.person),
                              hintText: "Password",
                            ),
                          ),
                        ),
                      ),
                      //confirm password
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 118, 114, 114),
                            ),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return "Enter Password confirmation";
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
                              icon: Icon(Icons.person),
                              hintText: "Confirm password",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14.0),
                ElevatedButton(
                  onPressed: () async {
                    String firstName = _firstNameController.text;
                    String lastName = _lastNameController.text;
                    String username = _usernameController.text;
                    String phone = _phoneController.text;
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    String confirmPassword = _confirmPasswordController.text;
                    int roleId = 3;

                    if (firstName == null || firstName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("FirstName can not be empty"),
                      ));
                      return;
                    }

                    if (lastName == null || lastName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("LastName can not be empty"),
                      ));
                      return;
                    }

                    if (email == null ||
                        email.isEmpty ||
                        !isValidEmail(email)) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please enter a valid email address"),
                      ));
                      return;
                    }

                    if (!validateStructure(password)) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "Password must contain one upercase letter one special char and number"),
                      ));
                      return;
                    }

                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Passwors must match!"),
                      ));
                      return;
                    }

                    final Map<String, dynamic> requestBody = {
                      'firstName': firstName,
                      'lastName': lastName,
                      'roleId': 3,
                      'email': email,
                      'phone': "phone",
                      'username': username,
                      'password': password,
                      'passwordRepeat': confirmPassword,
                      'sexId': 1,
                      'status': 'Active',
                    };
                    var test = await _userProvider.createUser(requestBody);

                    // After registration, you can navigate to a different page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                    _firstNameController.clear();
                    _lastNameController.clear();
                    _usernameController.clear();
                    _phoneController.clear();
                    _emailController.clear();
                    _passwordController.clear();
                    _confirmPasswordController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registracija uspješna!')),
                    );
                  },
                  child: const Text("Register"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        _firstNameController.clear();
                        _lastNameController.clear();
                        _usernameController.clear();
                        _phoneController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                        _confirmPasswordController.clear();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: const Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // A basic regex for email validation
    final RegExp regex =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$");
    return regex.hasMatch(email);
  }

  bool _validateInput(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Field '$value' can not be empty"),
      ));

      return false;
    }
    // Add more validation logic as needed
    return true; // Return null if the input is valid
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool validateRegister() {
    return true;
  }
}
