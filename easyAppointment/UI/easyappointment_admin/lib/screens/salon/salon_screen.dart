import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eprodaja_admin/app/user_singleton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../app/image_helper.dart';
import '../../models/salon.dart';
import '../../providers/city_provider.dart';
import '../../providers/salon_provider.dart';
import '../../widgets/master_screen.dart';

class SalonPage extends StatefulWidget {
  const SalonPage({Key? key}) : super(key: key);

  @override
  _SalonPageState createState() => _SalonPageState();
}

class _SalonPageState extends State<SalonPage> {
  final SalonProvider _salonProvider = SalonProvider();
  late CityProvider _cityProvider;

  TextEditingController _salonNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  Uint8List? bytes;
  File? _selectedImage;
  int? selectedCityId;
  Salon? salon;

  @override
  void initState() {
    super.initState();
    _cityProvider = context.read<CityProvider>();
    _fetchSalonData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    _salonNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _fetchSalonData() async {
    try {
      var salonData = await _salonProvider
          .getById(UserSingleton().loggedInUserSalon?.salonId!);
      salon =
          salonData as Salon; // Assuming the response returns a single salon

      // Update the widget state synchronously
      setState(() {
        _salonNameController.text = salon!.salonName!;
        _addressController.text = salon!.address!;
        selectedCityId = salon!.cityId;
        bytes = base64Decode(salon!.photo!);
      });
    } catch (e) {
      // Handle any errors or display an error message
      print('Error fetching salon data: $e');
    }
  }

  Image imageFromBase64String(String base64Image) {
    return Image.memory(base64Decode(base64Image));
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Business - Update Your Business Details',
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(60.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              color: Colors.grey[200],
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _selectImage,
                      child: Container(
                        width: 400, // Increase the width
                        height: 200, // Increase the height
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
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
                            ? Icon(Icons.photo_album,
                                size: 48, color: Colors.grey)
                            : null,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _salonNameController,
                      decoration: InputDecoration(
                        labelText: 'Salon Name',
                      ),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        // Save profile settings logic
                        String salonName = _salonNameController.text;
                        String address = _addressController.text;
                        String? photo = _selectedImage != null
                            ? await ImageHelper.fileToBytes(_selectedImage!)
                            : salon!.photo ?? "";

                        Map<String, dynamic> updateData = {
                          'salonName': salonName,
                          'address': address,
                          'ownerUserId': UserSingleton().loggedInUserId,
                          'photo':
                              photo, // Update with the photo data if needed
                          'cityId': selectedCityId,
                        };

                        try {
                          int? salonId =
                              UserSingleton().loggedInUserSalon?.salonId;
                          _salonProvider.update(salonId!, updateData);
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
}
