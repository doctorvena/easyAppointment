import 'package:eprodaja_admin/providers/salon_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';
import 'login_screen.dart';

class RegistrationPage extends StatelessWidget {
  final _fromKey = GlobalKey<FormBuilderState>();
  late UserProvider _userProvider = UserProvider();
  late SalonProvider _salonProvider = SalonProvider();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: _userProvider),
        ChangeNotifierProvider<SalonProvider>.value(value: _salonProvider),
      ],
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove back button
          title: Text("Registration"),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(14.0),
            child: Container(
              color: Color.fromRGBO(220, 220, 220, 90),
              padding: EdgeInsets.all(14.0),
              constraints: BoxConstraints(maxHeight: 520, maxWidth: 520),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "First Name",
                      ),
                      controller: _firstNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'First name is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Last Name",
                      ),
                      controller: _lastNameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                      ),
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email is required';
                        } else if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Username",
                      ),
                      controller: _usernameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Password",
                      ),
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                      ),
                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Confirm password is required';
                        } else if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Phone",
                      ),
                      controller: _phoneController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      onChanged: (value) {
                        selectedRole = value;
                      },
                      decoration: InputDecoration(
                        labelText: "Role",
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "business_owner",
                          child: Text("Business Owner"),
                        ),
                        DropdownMenuItem(
                          value: "employee",
                          child: Text("Employee"),
                        ),
                      ],
                      validator: (value) {
                        if (value == null) {
                          return 'Role is required';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String firstName = _firstNameController.text;
                        String lastName = _lastNameController.text;
                        String username = _usernameController.text;
                        String phone = _phoneController.text;
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        String confirmPassword =
                            _confirmPasswordController.text;
                        int roleId;
                        if (selectedRole == "Employee") {
                          roleId = 4;
                        } else {
                          roleId = 2;
                        }

                        validateRegister();

                        if (firstName == null || firstName.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("FirstName can not be empty"),
                          ));
                          return;
                        }

                        if (lastName == null || lastName.isEmpty) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("LastName can not be empty"),
                          ));
                          return;
                        }

                        if (email == null ||
                            email.isEmpty ||
                            !isValidEmail(email)) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Please enter a valid email address"),
                          ));
                          return;
                        }

                        if (!validateStructure(password)) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                "Password must contain one upercase letter one special char and number"),
                          ));
                          return;
                        }

                        if (password != confirmPassword) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Passwors must match!"),
                          ));
                          return;
                        }

                        final Map<String, dynamic> requestBody = {
                          'firstName': firstName,
                          'lastName': lastName,
                          'roleId': selectedRole == "employee" ? 4 : 2,
                          'email': email,
                          'phone': phone,
                          'username': username,
                          'password': password,
                          'passwordRepeat': confirmPassword,
                          'status': 'Active',
                          'sexId': 1,
                        };

                        var test = await _userProvider.createUser(requestBody);

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Registracija uspješna!')),
                        );
                      },
                      child: Text("Register"),
                    ),
                    SizedBox(height: 12.0),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      child: Text("Login"),
                    ),
                  ],
                ),
              ),
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

  Future<void> _saveUser(var request) async {
    try {
      _fromKey.currentState?.saveAndValidate();
      await _userProvider.insert(request);
    } catch (e, stackTrace) {
      print('An error occurred: $e');
      print('Stack trace: $stackTrace');
    }
  }

  bool _validateInput(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Field '$value' can not be empty"),
      ));

      return false;
    }
    return true;
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~.]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool validateRegister() {
    return true;
  }
}
