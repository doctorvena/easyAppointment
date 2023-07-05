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
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void addUser() async {
    String userName = _userNameController.text.trim();
    String email = _emailController.text.trim();

    if (userName.isNotEmpty && email.isNotEmpty) {
      try {
        // await _userProvider.insert(
        //     userName, email, UserSingleton().loggedInUserId);
        widget.refreshData();
        Navigator.pop(context);
      } catch (e) {
        // Handle the error
        print('Error adding user: $e');
        // Show an error message or perform any necessary error handling
      }
    } else {
      // Show an error message or validation message if the required fields are not filled
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'User Name:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _userNameController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Email:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addUser,
              child: Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}
