// ignore_for_file: prefer_const_constructors, unnecessary_cast

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:easyappointment_mobile/models/salon.dart';
import 'package:easyappointment_mobile/widgets/home_page.dart';
import 'package:flutter/material.dart';

class PregledRadnjePage extends StatefulWidget {
  Salon salon;
  PregledRadnjePage({required this.salon, super.key});

  @override
  State<PregledRadnjePage> createState() => _PregledRadnjePageState();
}

class _PregledRadnjePageState extends State<PregledRadnjePage> {
  Uint8List? bytes;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    // Perform actions or initialize data when the page loads
    fetchData();
    initializeData();
  }

  Future<void> fetchData() async {
    setState(() {
      bytes = base64Decode(widget.salon.photo!);
      print(bytes);
    });
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
      title: "Pregled radnje",
      index: 0,
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 180,
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
                ),
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
                                SizedBox(
                                  height: 50,
                                  width: 160,
                                  child: ListView.builder(
                                    primary: false,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: 5,
                                    itemBuilder: (context, index) {
                                      return Icon(
                                        Icons.star,
                                        size: 30,
                                        color:
                                            Color.fromARGB(255, 255, 167, 34),
                                      );
                                    },
                                  ),
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
                  "Naši uposlenici",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              //ListView.builder()
            ],
          ),
        ),
      ),
    );
  }
}
