import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eprodaja_admin/app/user_singleton.dart';
import 'package:eprodaja_admin/models/city.dart';
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
          .getById(UserSingleton().loggedInUserSalon!.salonId!);
      salon =
          salonData as Salon; // Assuming the response returns a single salon

      // Update the widget state synchronously
      setState(() {
        _salonNameController.text = salon!.salonName!;
        _addressController.text = salon!.address!;
        // if (salon.photo!.isNotEmpty) {
        //   Uri uri = Uri.parse(salon.photo!);
        //   _selectedImage =
        //       File.fromUri(uri); // Assign the string to a File object
        // }
        selectedCityId = salon!.cityId;
        bytes = base64Decode(salon!.photo!);
      });
      print(_selectedImage);
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
      title: 'Salon',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            GestureDetector(
              onTap: _selectImage,
              child: Container(
                width: 200,
                height: 100,
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
                child:
                    _selectedImage == null && (bytes == null || bytes!.isEmpty)
                        ? Icon(Icons.check_box_outline_blank,
                            size: 60, color: Colors.grey)
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
                labelText: 'Adress',
              ),
            ),
            SizedBox(height: 8),
            FutureBuilder(
              future: _cityProvider.get(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<City> cities = snapshot.data.result;
                  return DropdownButtonFormField<int>(
                    value: selectedCityId,
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedCityId = newValue;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'City',
                    ),
                    items: cities.map((City city) {
                      return DropdownMenuItem<int>(
                        value: city.cityId,
                        child: Text(city.cityName ?? ''),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
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
                    'photo': photo, // Update with the photo data if needed
                    'cityId': selectedCityId,
                  };

                  try {
                    int? salonId = UserSingleton().loggedInUserSalon!.salonId;
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
            ),
          ],
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
