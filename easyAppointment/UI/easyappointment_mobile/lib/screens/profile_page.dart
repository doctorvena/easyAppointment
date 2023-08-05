import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/image_helper.dart';
import '../utils/user_singleton.dart';
import '../widgets/home_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserProvider _userProvider = UserProvider();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  Uint8List? bytes;
  File? _selectedImage;
  User? user;

  ValueNotifier<bool> _isFormChanged = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _selectImage() async {
    // final pickedFile =
    //     await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   setState(() {
    //     _selectedImage = File(pickedFile.path);
    //   });
    // }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _fetchUserData() async {
    try {
      var userData =
          await _userProvider.getById(UserSingleton().loggedInUserId);
      user = userData;

      // Update the widget state synchronously
      setState(() {
        _nameController.text = user!.firstName!;
        _usernameController.text = user!.username!;
        _phoneController.text = user!.phone!;
        _emailController.text = user!.email!;
        bytes = base64Decode(user!.photo!);
      });
    } catch (e) {
      // Handle any errors or display an error message
      print('Error fetching user data: $e');
    }
  }

  Image imageFromBase64String(String base64Image) {
    return Image.memory(base64Decode(base64Image));
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "profile",
      index: 2,
      child: SingleChildScrollView(
        // child: Card(
        //   color: Colors.grey[200],
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
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 118, 114, 114),
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintStyle: TextStyle(fontSize: 16),
                      border: InputBorder.none,
                      hintText: "Name",
                    ),
                    onChanged: (value) {
                      isFormChanged();
                    },
                  ),
                ),
              ),
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
                    decoration: const InputDecoration(
                      labelText: 'UserName',
                      hintStyle: TextStyle(fontSize: 16),
                      border: InputBorder.none,
                      hintText: "UserName",
                    ),
                    onChanged: (value) {
                      isFormChanged();
                    },
                  ),
                ),
              ),
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
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintStyle: TextStyle(fontSize: 16),
                      border: InputBorder.none,
                      hintText: "Email",
                    ),
                    onChanged: (value) {
                      isFormChanged();
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 118, 114, 114),
                    ),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      hintStyle: TextStyle(fontSize: 16),
                      border: InputBorder.none,
                      hintText: "Phone",
                    ),
                    onChanged: (value) {
                      isFormChanged();
                    },
                  ),
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _isFormChanged,
                builder: (BuildContext context, bool isUsernameChanged,
                    Widget? child) {
                  return ElevatedButton(
                    onPressed: isUsernameChanged
                        ? () async {
                            // Save profile settings logic
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
                            };

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
                          }
                        : null, // disable button if username not changed
                    child: Text('Save'),
                  );
                },
              ),
            ],
          ),
          // ),
        ),
      ),
    );
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
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void isFormChanged() {
    if (user?.username != _usernameController.text ||
        user?.firstName != _nameController.text ||
        user?.email != _emailController.text ||
        user?.phone != _phoneController.text) {
      _isFormChanged.value = true;
    } else {
      _isFormChanged.value = false;
    }
  }
}
