import 'dart:convert';
import 'dart:io';

import 'package:eprodaja_admin/models/salon_photo.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/user_singleton.dart';
import '../../providers/salon_photo_provider.dart';
import '../../widgets/master_screen.dart';

class SalonPhotosPage extends StatefulWidget {
  const SalonPhotosPage({Key? key}) : super(key: key);

  @override
  _SalonPhotosPageState createState() => _SalonPhotosPageState();
}

class _SalonPhotosPageState extends State<SalonPhotosPage> {
  late SalonPhotoProvider _salonPhotoProvider;
  late PageController _pageController;

  // Temporarily using hardcoded data for demonstration.
  // In your final application, you should load the photos from your provider.
  // List<String> base64Photos = [
  //   // Add your base64 image strings here
  // ];

  List<SalonPhoto> photos = [];
  @override
  void initState() {
    super.initState();
    _salonPhotoProvider = context.read<SalonPhotoProvider>();
    _pageController = PageController();
    fetchData2();
  }

  // Future<void> fetchData() async {
  //   var data = await _salonPhotoProvider.get(
  //     filter: {'salonId': UserSingleton().loggedInUserSalon?.salonId},
  //   );
  //   setState(() {
  //     base64Photos = data.result
  //         .map((salonPhoto) =>
  //             salonPhoto.photo!) // Extract the photo field with null check
  //         .toList(); // Convert to a list
  //   });
  // }

  Future<void> fetchData2() async {
    print(UserSingleton().loggedInUserSalon?.salonId);
    var data = await _salonPhotoProvider.get(
      filter: {'salonId': UserSingleton().loggedInUserSalon?.salonId},
    );
    setState(() {
      photos = data.result; // Assign the result directly to photos
    });
  }

  Image imageFromBase64String(String base64Image) {
    return Image.memory(base64Decode(base64Image));
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Salon Photos',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            photos.isEmpty
                ? Text('No photos available.')
                : Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                        ),
                        Expanded(
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: photos.length,
                            itemBuilder: (context, index) {
                              return Center(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: imageFromBase64String(
                                          photos[index].photo ?? ""),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(8.0), // Change padding as needed
                  child: ElevatedButton(
                    onPressed: addPhoto,
                    child: Text('Add Photo'),
                  ),
                ),
                if (photos
                    .isNotEmpty) // Only show Delete button if there is photo
                  Padding(
                    padding:
                        const EdgeInsets.all(8.0), // Change padding as needed
                    child: ElevatedButton(
                      onPressed: () => deletePhoto(_pageController.page!
                          .round()), // delete the current photo
                      child: Text('Delete Photo'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void addPhoto() async {
    // Let the user select an image file
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      try {
        // Get the selected file
        File file = File(result.files.single.path!);

        // Convert the file to base64
        List<int> imageBytes = file.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        SalonPhoto photoToView = new SalonPhoto(
            99, base64Image, UserSingleton().loggedInUserSalon?.salonId);
        // Add the base64 image to the list of photos
        setState(() {
          photos.add(photoToView);
        });

        var body = {
          'photo': base64Image,
          'salonId': UserSingleton().loggedInUserSalon?.salonId,
        };
        await _salonPhotoProvider.insert(body);
        fetchData2();
        for (var i = 0; i < photos.length; i++) {}
        _pageController.jumpToPage(photos.length);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success!'),
              content: Text('Photo successfully added.'),
              actions: <Widget>[
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
      } catch (e) {}
    } else {
      // User canceled the picker
    }
  }

  // Function to delete a photo
  void deletePhoto(int index) async {
    try {
      await _salonPhotoProvider
          .delete(photos[index].photoId!); // Access id from SalonPhoto instance
      setState(() {
        photos.removeAt(index);
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success!'),
            content: Text('Photo successfully Removed.'),
            actions: <Widget>[
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
    } catch (e) {}
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
