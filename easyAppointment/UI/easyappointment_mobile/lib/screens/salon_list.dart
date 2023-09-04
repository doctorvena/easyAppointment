// ignore_for_file: prefer_const_constructors, unnecessary_cast

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easyappointment_mobile/models/city.dart';
import 'package:easyappointment_mobile/models/salon.dart';
import 'package:easyappointment_mobile/providers/salon_provider.dart';
import 'package:easyappointment_mobile/screens/pregled_radnje_page.dart';
import 'package:easyappointment_mobile/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/search_result.dart';
import '../providers/city_provider.dart';

class SalonListScreen extends StatefulWidget {
  const SalonListScreen({super.key});

  @override
  State<SalonListScreen> createState() => _SalonListScreenState();
}

class _SalonListScreenState extends State<SalonListScreen> {
  late SalonProvider _salonProvider;
  bool isLoading = true;

  late CityProvider _cityProvider;
  searchResult<Salon>? result;
  searchResult<City>? cityResult;
  late List<Uint8List> bytes = [];
  int filter = 0;
  File? _selectedImage;
  String dropDownText = "all";

  @override
  void initState() {
    super.initState();
    _salonProvider = context.read<SalonProvider>();
    _cityProvider = context.read<CityProvider>();

    // Perform actions or initialize data when the page loads
    fetchData();
    initializeData();
  }

  Future<void> fetchData() async {
    var data = await _salonProvider.get();
    var cities = await _cityProvider.get();

    if (mounted) {
      // Check if the widget is still in the widget tree
      setState(() {
        result = data as searchResult<Salon>?;
        cityResult = cities as searchResult<City>?;
        isLoading = false; // Set loading to false when data is fetched
      });
    }
  }

  void initializeData() {
    // Initialize data or perform any other necessary setup
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "EasyAppointment",
      index: 0,
      child: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                      height:
                          20), // Add some spacing between the loader and the text
                  Text('Loading Salons...'), // Your loading message
                ],
              ),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                      left: MediaQuery.of(context).size.width * 0.05,
                    ),
                    height: 50,
                    // width: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Color.fromARGB(255, 88, 86, 86),
                      ),
                    ),
                    child: DropdownButton<int>(
                      isExpanded: true,
                      hint: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(dropDownText),
                      ),
                      items:
                          cityResult?.result.map<DropdownMenuItem<int>>((item) {
                        return DropdownMenuItem<int>(
                          value: item.cityId,
                          child: Text(item.cityName ?? ""),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          filter = value ?? 0;
                          dropDownText =
                              cityResult?.result[filter - 1].cityName ?? "";
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.68,
                      child: ListView.builder(
                        itemCount: result?.result.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Visibility(
                            visible: filter == 0 ||
                                filter == result?.result[index].cityId,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PregledRadnjePage(
                                        salon: result!.result[index]),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color.fromARGB(255, 88, 86, 86),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                margin: EdgeInsets.only(top: 15),
                                height: 120,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: Container(
                                          width: 120,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            // shape: BoxShape.rectangle,
                                            image:
                                                result?.result[index].photo !=
                                                            null &&
                                                        result?.result[index]
                                                                .photo !=
                                                            ""
                                                    ? DecorationImage(
                                                        image: MemoryImage(
                                                            getUint8List(result
                                                                ?.result[index]
                                                                .photo)),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : null,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              topLeft: Radius.circular(15),
                                            ),
                                          ),
                                          child: result?.result[index].photo ==
                                                      null ||
                                                  result?.result[index].photo ==
                                                      ""
                                              ? Icon(Icons.photo_album,
                                                  size: 48, color: Colors.grey)
                                              : null),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            result?.result[index].salonName ??
                                                "",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 50,
                                            width: 160,
                                            child: ListView.builder(
                                              primary: false,
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  5, // Because a rating is out of 5
                                              itemBuilder:
                                                  (context, starIndex) {
                                                double rating = result
                                                        ?.result[index]
                                                        .rating ??
                                                    0;
                                                if (starIndex < rating) {
                                                  // This means we are still within the range of full stars
                                                  return Icon(
                                                    Icons.star,
                                                    size: 30,
                                                    color: Color.fromARGB(
                                                        255, 255, 167, 34),
                                                  );
                                                } else if (starIndex <
                                                    rating + 0.5) {
                                                  // This means we should be displaying a half star
                                                  return Icon(
                                                    Icons
                                                        .star_half, // This icon represents a half star
                                                    size: 30,
                                                    color: Color.fromARGB(
                                                        255, 255, 167, 34),
                                                  );
                                                } else {
                                                  // This means we are in the range of empty stars
                                                  return Icon(
                                                    Icons
                                                        .star_border, // This icon represents an empty star
                                                    size: 30,
                                                    color: Color.fromARGB(
                                                        255, 255, 167, 34),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          Text(result?.result[index].address ??
                                              ""),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  getUint8List(String? photo) {
    if (photo == null) return true;
    return base64Decode(photo);
  }
}
