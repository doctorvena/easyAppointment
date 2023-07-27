// ignore_for_file: prefer_const_constructors, must_be_immutable, non_constant_identifier_names
import 'package:easyappointment_mobile/screens/navigation_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget;
  int index;

  HomePage(
      {this.child,
      this.title,
      this.title_widget,
      required this.index,
      Key? key})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title_widget ?? Text(widget.title ?? ""),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: widget.child!,
      bottomNavigationBar: NavigationBarPage(
        index: widget.index,
      ),
    );
  }
}
