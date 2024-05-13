import 'dart:io';
import 'package:client/controller/propertise/properties_controller.dart';
import 'package:client/view/add_property/add_property_8.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class AddProperty7 extends StatefulWidget {
  AddProperty7({Key? key}) : super(key: key);

  @override
  _AddProperty7State createState() => _AddProperty7State();
}

class _AddProperty7State extends State<AddProperty7>
    with SingleTickerProviderStateMixin {
  ManagePropertiesController controller =
      Get.put(ManagePropertiesController(), permanent: true);

  late AnimationController _animationController;
  late Animation<int> _textAnimation;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  List<File> _photos = [];

  final ImagePicker _picker = ImagePicker();

  Future<List<XFile>?> imgFromGallery() async {
    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _photos =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
        controller.isUploading = true; // Set the flag to indicate uploading
      });
      await uploadFiles(); // Upload files immediately
    } else {
      print('No images selected.');
    }

    return pickedFiles;
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _photos.add(
            File(pickedFile.path)); // Append the selected image to the list
        controller.isUploading = true; // Set the flag to indicate uploading
      });
      uploadFiles(); // Upload the new image immediately
    } else {
      print('No image selected.');
    }
  }

  Future uploadFiles() async {
    for (final photo in _photos) {
      final fileName = basename(photo.path);
      final destination = 'images/$fileName';

      try {
        final ref = firebase_storage.FirebaseStorage.instance.ref(destination);
        await ref.putFile(photo);
        final url = await ref.getDownloadURL();
        setState(() {
          controller.downloadUrls.add(url);
        });
      } catch (e) {
        print('Error occurred while uploading: $e');
      }
    }
  }

  @override
  void initState() {
    // Initialize AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // Create a Tween for the animation
    _textAnimation = IntTween(
            begin: 0,
            end:
                "Add photos of the property to offer a virtual living experience"
                    .length)
        .animate(_animationController);

    // Start the animation
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManagePropertiesController>(
      init: ManagePropertiesController(),
      builder: (ManagePropertiesController controller) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  controller.decreaseActiveStep();
                  print(controller.activeStep);
                  Navigator.pop(context);
                });
              },
            ),
            title: const Text(
              "Add Property",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        controller.increaseActiveStep();
                        print(controller.activeStep);
                      });
                      Get.to(() => AddProperty8());
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Body
          body: ListView(
            children: [
              controller.easyStepper(),
              Container(
                margin: const EdgeInsets.only(right: 15, left: 15, bottom: 25),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Introduction
                      Image.asset("assets/images/logo.png", scale: 11),
                      Container(
                        child: AnimatedBuilder(
                          animation: _textAnimation,
                          builder: (context, child) {
                            String animatedText =
                                "Add photos of the property to offer a virtual living experience"
                                    .substring(0, _textAnimation.value);
                            return Text(
                              animatedText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            );
                          },
                        ),
                      ),

                      // Display photos
                      const SizedBox(height: 30),
                      if (!controller.isUploading)
                        InkWell(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(13),
                              width: 1000,
                              height: 300,
                              foregroundDecoration: BoxDecoration(
                                  border: Border.all(color: Colors.black54),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              child: Container(
                                child: Center(
                                  child: Image.asset(
                                      "assets/images/add-photo.png"),
                                ),
                              ),
                            ))
                      else
                        Container(
                          margin: const EdgeInsets.all(13),
                          foregroundDecoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              child: GridView.builder(
                                physics:
                                    const NeverScrollableScrollPhysics(), // Disable scrolling in the GridView
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  childAspectRatio: 1.5,
                                ),
                                itemCount: controller.downloadUrls.length,
                                itemBuilder: (context, index) {
                                  final imageUrl =
                                      controller.downloadUrls[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    imgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
