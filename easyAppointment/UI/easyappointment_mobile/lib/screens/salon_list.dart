import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easyappointment_mobile/models/city.dart';
import 'package:easyappointment_mobile/models/salon.dart';
import 'package:easyappointment_mobile/providers/salon_provider.dart';
import 'package:easyappointment_mobile/screens/pregled_radnje_page.dart';
import 'package:easyappointment_mobile/utils/user_singleton.dart';
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
  TextEditingController _ftsController = new TextEditingController();
  late SalonProvider _salonProvider;
  bool isLoading = true;
  bool showRecommended = false;
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

    fetchData();
    initializeData();
  }

  Future<void> fetchData({String fts = ''}) async {
    int? lastRatedSalonId = 0;
    if (showRecommended) {
      lastRatedSalonId = await _salonProvider
          .getLastRatedSalonByUserId(UserSingleton().loggedInUserId);
    }
    searchResult<Salon>? data;

    if (showRecommended) {
      data = await _salonProvider.getRecommended(lastRatedSalonId);
    } else {
      data = await _salonProvider.get(filter: {
        if (fts.isNotEmpty || fts != '') 'fts': fts,
      });
    }

    var cities = await _cityProvider.get();

    if (mounted) {
      setState(() {
        result = data as searchResult<Salon>?;
        cityResult = cities as searchResult<City>?;
        isLoading = false;
      });
    }
  }

  void initializeData() {}

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
                  SizedBox(height: 20),
                  Text('Loading Salons...'),
                ],
              ),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width * 0.95,
              child: ListView(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Switch(
                        value: showRecommended,
                        onChanged: (value) {
                          setState(() {
                            showRecommended = value;
                            _ftsController.text = '';
                            fetchData();
                          });
                        },
                      ),
                      Text('Show Recommended'),
                    ],
                  ),
                  if (!showRecommended)
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: MediaQuery.of(context).size.width * 0.05,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromARGB(255, 88, 86, 86),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _ftsController,
                              decoration: InputDecoration(
                                hintText: "Search...",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                              ),
                              onChanged: (value) {},
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              fetchData(fts: _ftsController.text);
                            },
                          ),
                        ],
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
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "${result?.result[index].rating ?? "0.0"}",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 255, 167, 34),
                                                ),
                                              ),
                                              Icon(
                                                Icons.star,
                                                color: Color.fromARGB(
                                                    255, 255, 167, 34),
                                                size: 22,
                                              ),
                                            ],
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
