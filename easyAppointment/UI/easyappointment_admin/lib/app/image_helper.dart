import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  static Future<File?> pickImage(ImageSource source) async {
    final pickedFile = await _imagePicker.getImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path as String);
    }
    return null;
  }

  static Future<String?> fileToBytes(File file) async {
    if (file != null) {
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      return base64Image;
    }
    return null;
  }

  static void storeImageToDatabase(Uint8List imageData) {
    // Save the imageData to the database as a byte array
  }

  static Uint8List? base64ToBytes(String? base64Image) {
    if (base64Image != null) {
      final bytes = base64Decode(base64Image);
      return Uint8List.fromList(bytes);
    }
    return null;
  }

  static Image imageFromBase64String(String base64Image) {
    return Image.memory(base64Decode(base64Image));
  }

  static Future<String> fileToBase64(File file) async {
    List<int> imageBytes = await file.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }
}
