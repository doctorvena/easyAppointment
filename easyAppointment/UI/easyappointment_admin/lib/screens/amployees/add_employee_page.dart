import 'package:eprodaja_admin/app/user_singleton.dart';
import 'package:eprodaja_admin/providers/employee_salon_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class AddEmployeePage extends StatefulWidget {
  final Function refreshData;

  const AddEmployeePage({Key? key, required this.refreshData})
      : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddEmployeePage> {
  late UserProvider _userProvider;
  late SalonEmployeeProvider _salonEmployeeProvider;
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _salonEmployeeProvider = context.read<SalonEmployeeProvider>();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void addEmployee() async {
    String username = _usernameController.text.trim();
    bool isEmployee = false; // Set the isEmployee flag to false

    if (username.isNotEmpty) {
      try {
        if (UserSingleton().role == 'BusinessOwner') {
          // Check if the user is not an employee
          await _salonEmployeeProvider.addEmplyeeAsOwner(username);
          widget.refreshData();
          Navigator.pop(context);
        } else {
          // Show an error message that only business users can add employees
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Permission Denied'),
                content: Text('Only business users can add employees.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        // Handle the error
        // Show an error message or perform any necessary error handling
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('$e'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Show an error message or validation message if the required field is not filled
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Validation Error'),
            content: Text('Please enter a username.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEmployee = UserSingleton().role ==
        'Employee'; // Get the isEmployee flag from the user provider
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Employee Username',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _usernameController,
                enabled:
                    !isEmployee, // Disable the input field for business users
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Enter employee username',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: addEmployee,
                child: Text('Add Employee'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
