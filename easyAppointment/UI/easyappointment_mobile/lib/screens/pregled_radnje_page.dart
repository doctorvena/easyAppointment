import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easyappointment_mobile/models/salon-photo.dart';
import 'package:easyappointment_mobile/models/salon.dart';
import 'package:easyappointment_mobile/providers/salon_photo_provider.dart';
import 'package:easyappointment_mobile/screens/reservations/reservation_screen.dart';
import 'package:easyappointment_mobile/widgets/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/salon_employee.dart';
import '../providers/salon_employee_provider.dart';

class PregledRadnjePage extends StatefulWidget {
  Salon salon;
  PregledRadnjePage({required this.salon, super.key});

  @override
  State<PregledRadnjePage> createState() => _PregledRadnjePageState();
}

class _PregledRadnjePageState extends State<PregledRadnjePage> {
  Uint8List? bytes;
  File? _selectedImage;
  List<SalonEmployee> employees = [];
  List<SalonPhoto> salonPhotos = [];
  late SalonEmployeeProvider _salonEmployeeProvider;
  late SalonPhotoProvider _salonPhotoProvider;

  @override
  void initState() {
    super.initState();
    _salonEmployeeProvider = context.read<SalonEmployeeProvider>();
    _salonPhotoProvider = context.read<SalonPhotoProvider>();
    fetchData();
    initializeData();
  }

  Future<void> fetchData() async {
    var data = await _salonEmployeeProvider.get(
      filter: {
        'SalonId': widget.salon.salonId,
        'AreUsersIncluded': true,
      },
    );
    employees = data.result;

    var dataSP = await _salonPhotoProvider.get(
      filter: {
        'SalonId': widget.salon.salonId,
      },
    );
    salonPhotos = dataSP.result;

    setState(() {
      bytes = base64Decode(widget.salon.photo!);
      var stop;
      print(bytes);
    });
  }

  void initializeData() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MasterScreenWidget(
        hideNavBar: true,
        title: "Pregled radnje",
        index: 0,
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 180,
                  child: salonPhotos.isNotEmpty
                      ? PageView.builder(
                          itemCount: salonPhotos.length,
                          itemBuilder: (context, index) {
                            Uint8List? coverBytes;
                            if (salonPhotos[index].photo != null &&
                                salonPhotos[index].photo!.isNotEmpty) {
                              coverBytes =
                                  base64Decode(salonPhotos[index].photo!);
                            }
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: coverBytes != null
                                    ? DecorationImage(
                                        image: MemoryImage(coverBytes),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                color: Colors.red,
                              ),
                            );
                          },
                        )
                      : Container(color: Colors.red),
                ),
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                        child: Row(
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
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
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(45)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Column(
                                children: [
                                  Text(
                                    widget.salon.salonName ?? "",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 30,
                                        color:
                                            Color.fromARGB(255, 255, 167, 34),
                                      ),
                                      SizedBox(width: 5.0),
                                      Text(
                                        widget.salon.rating!.toStringAsFixed(1),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(widget.salon.address ?? ""),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20),
                  child: Text(
                    "Our Employees",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                employees.isNotEmpty
                    ? Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: employees.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    image: (employees[index].user?.photo !=
                                                null &&
                                            employees[index].user?.photo != "")
                                        ? DecorationImage(
                                            image: MemoryImage(
                                              getUint8List(
                                                  employees[index].user?.photo),
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: (employees[index].user?.photo ==
                                              null ||
                                          employees[index].user?.photo == "")
                                      ? Icon(
                                          Icons.person_3_sharp,
                                          size: 24,
                                          color: Colors.grey,
                                        )
                                      : null,
                                ),
                                title: Text(
                                    '${employees[index].firstName} ${employees[index].lastName}'),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "We have no employees yet",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ReservationScreen(
                  salon: widget.salon,
                ),
              ),
            );
          },
          child: const Text('Make a Reservation'),
        ),
      ),
    );
  }

  getUint8List(String? photo) {
    if (photo == null) return true;
    return base64Decode(photo);
  }
}
