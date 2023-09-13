import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eprodaja_admin/app/user_singleton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../app/image_helper.dart';
import '../../models/city.dart';
import '../../models/salon.dart';
import '../../models/search_result.dart';
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
  searchResult<City>? cityResult;
  City? _selectedCity;

  TextEditingController _salonNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _reservationPriceController = TextEditingController();
  Uint8List? bytes;
  File? _selectedImage;
  int? selectedCityId;
  Salon? salon;

  @override
  void initState() {
    super.initState();
    _cityProvider = context.read<CityProvider>();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchCities();
    _fetchSalonData();
  }

  Future<void> _fetchCities() async {
    try {
      var cities = await _cityProvider.get();
      setState(() {
        cityResult = cities as searchResult<City>?;
      });
    } catch (e) {
      print('Error fetching cities: $e');
    }
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
    _reservationPriceController.dispose();
    super.dispose();
  }

  void _fetchSalonData() async {
    try {
      var salonId = UserSingleton().loggedInUserSalon?.salonId;
      if (salonId == null || salonId == -1) {
        if (UserSingleton().role != "Employee") {
          final Map<String, dynamic> requestBodySalon = {
            'salonName': "New Salon",
            'address': "Address",
            'photo': "",
            'ownerUserId': UserSingleton().loggedInUserId,
            'cityId': 1,
            'rating': 0,
          };

          var salonData = await _salonProvider.insert(requestBodySalon);
          salon = salonData as Salon;
          // UserSingleton().loggedInUserSalon?.salonId = salonData.salonId;
          UserSingleton().loggedInUserSalon = salon;
          print(UserSingleton().loggedInUserSalon?.salonId);
          setState(() {
            _salonNameController.text = salon!.salonName!;
            _addressController.text = salon!.address!;
            selectedCityId = salon!.cityId;
            bytes = base64Decode(salon!.photo!);
          });
        }
      } else {
        var salonData = await _salonProvider.getById(salonId);
        salon = salonData as Salon;

        setState(() {
          _salonNameController.text = salon!.salonName!;
          _addressController.text = salon!.address!;

          _reservationPriceController.text = salon!.reservationPrice.toString();

          selectedCityId = salon!.cityId;
          bytes = base64Decode(salon!.photo!);

          if (cityResult != null && cityResult!.result.isNotEmpty) {
            _selectedCity = cityResult!.result.firstWhere(
                (city) => city.cityId == salon!.cityId,
                orElse: () => cityResult!.result.first);
          }
        });
      }
    } catch (e) {
      print('Error fetching or creating salon data: $e');
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
                        width: 400,
                        height: 200,
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
                    TextField(
                      controller: _reservationPriceController,
                      decoration: InputDecoration(
                        labelText: 'Reservation Price',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 8),
                    DropdownButton<City>(
                      value: _selectedCity,
                      hint: Text("Select a city"),
                      items: cityResult?.result.map((City city) {
                        return DropdownMenuItem<City>(
                          value: city,
                          child: Text(city.cityName!),
                        );
                      }).toList(),
                      onChanged: (City? newValue) {
                        setState(() {
                          _selectedCity = newValue;
                          selectedCityId = newValue?.cityId;
                        });
                      },
                      isExpanded: true,
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        String salonName = _salonNameController.text;
                        String address = _addressController.text;
                        String? photo = _selectedImage != null
                            ? await ImageHelper.fileToBytes(_selectedImage!)
                            : salon!.photo ?? "";

                        Map<String, dynamic> updateData = {
                          'salonName': salonName,
                          'address': address,
                          'ownerUserId': UserSingleton().loggedInUserId,
                          'photo': photo,
                          'cityId': selectedCityId,
                          'reservationPrice': _reservationPriceController.text
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
