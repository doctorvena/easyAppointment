import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eprodaja_admin/app/user_singleton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app/image_helper.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../../widgets/master_screen.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  final UserProvider _userProvider = UserProvider();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  Uint8List? bytes;
  File? _selectedImage;
  User? user;
  int? _selectedSexId;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _selectImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    // _selectedSexId.dispose();
    super.dispose();
  }

  void _fetchUserData() async {
    try {
      var userData =
          await _userProvider.getById(UserSingleton().loggedInUserId);
      user = userData;

      setState(() {
        _nameController.text = user!.firstName!;
        _usernameController.text = user!.username!;
        _phoneController.text = user!.phone!;
        _emailController.text = user!.email!;
        bytes = base64Decode(user!.photo!);
        _selectedSexId = user!.sexId;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Image imageFromBase64String(String base64Image) {
    return Image.memory(base64Decode(base64Image));
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'User Profile',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(100.0),
        child: Card(
          color: Colors.grey[200],
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _selectImage,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : bytes != null && bytes!.isNotEmpty
                              ? DecorationImage(
                                  image: MemoryImage(bytes!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    child: _selectedImage == null &&
                            (bytes == null || bytes!.isEmpty)
                        ? Icon(Icons.person, size: 48, color: Colors.grey)
                        : null,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.0), // Optional for better UI
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius:
                        BorderRadius.circular(5.0), // Optional for better UI
                  ),
                  child: DropdownButtonHideUnderline(
                    // to hide the built-in underline of the dropdown
                    child: DropdownButton<int>(
                      isExpanded: true, // makes it full width
                      value: _selectedSexId,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedSexId = newValue;
                        });
                      },
                      items: <DropdownMenuItem<int>>[
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text("Male"),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text("Female"),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    String name = _nameController.text;
                    String username = _usernameController.text;
                    String phone = _phoneController.text;
                    String email = _emailController.text;
                    String? photo = _selectedImage != null
                        ? await ImageHelper.fileToBytes(_selectedImage!)
                        : user!.photo ?? "";
                    Map<String, dynamic> updateData = {
                      'firstName': name,
                      'lastName': '',
                      'email': email,
                      'phone': phone,
                      'photo': photo,
                      'sexId': _selectedSexId,
                    };

                    if (email == null ||
                        email.isEmpty ||
                        !isValidEmail(email)) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Please enter a valid email address"),
                      ));
                      return;
                    }

                    try {
                      _userProvider.update(
                          UserSingleton().loggedInUserId, updateData);
                      showSuccessDialog(context);
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
                  child: Text('Save'),
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

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Successfully updated!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
