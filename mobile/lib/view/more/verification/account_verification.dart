import 'dart:convert';
import 'dart:io';
import 'package:client/controller/users_auth/account_verification_controller.dart';
import 'package:client/controller/users_auth/signup_controller.dart';
import 'package:client/main.dart';
import 'package:client/view/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class AccountVerification extends StatefulWidget {
  const AccountVerification({Key? key}) : super(key: key);

  @override
  _AccountVerificationState createState() => _AccountVerificationState();
}

class _AccountVerificationState extends State<AccountVerification>
    with SingleTickerProviderStateMixin {
  AccountVerificationController controller =
      Get.put(AccountVerificationController(), permanent: true);
  SignUpControllerImp signUpController = Get.put(SignUpControllerImp());

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  List<File> _photos = [];
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<int> _textAnimation;
  bool isCard = true;

  Future<List<XFile>?> imgFromGallery() async {
    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _photos =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
      await uploadFiles(); // Upload files immediately
    } else {}

    return pickedFiles;
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _photos.add(File(pickedFile.path));
      });
      uploadFiles(); // Upload the new image immediately
    } else {}
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
          if (isCard) {
            controller.cardID = url;
          } else {
            controller.personal = url;
          }
        });
      } catch (e) {}
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _textAnimation = IntTween(
            begin: 0,
            end:
                "Verify your account by submiting your card ID and recent personal image"
                    .length)
        .animate(_animationController);

    _animationController.forward();

    controller.cardID = "";
    controller.personal = "";
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateAfterVerification() async {
    await Future.delayed(const Duration(seconds: 5));

    String? userDtoJson = sharepref.getString("user");
    Map<String, dynamic> userDto = json.decode(userDtoJson ?? "{}");
    controller.userId = userDto["id"];

    controller.verifyAccount();
    signUpController.updateUserVerified(userDto["id"], true);
    userDto["isVerified"] = true;
    String updatedUserDtoJson = jsonEncode(userDto);
    sharepref.setString("user", updatedUserDtoJson);

    if (userDto["userRole"] == "Lawyer") {
      Get.offAllNamed("/lawyer-bottom-bar");
    } else {
      Get.offAllNamed("/bottom-bar");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountVerificationController>(
      init: AccountVerificationController(),
      builder: (AccountVerificationController controller) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Get.offAll(() => const Login());
              },
            ),
            title: const Text(
              "Identity Verification",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Body
          body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),

                    // Introduction
                    Row(
                      children: [
                        Image.asset("assets/images/logo.png", scale: 11),
                      ],
                    ),
                    AnimatedBuilder(
                      animation: _textAnimation,
                      builder: (context, child) {
                        String animatedText =
                            "Verify your account by submiting your card ID and recent personal image"
                                .substring(0, _textAnimation.value);
                        return Text(
                          animatedText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        );
                      },
                    ),

                    // Card ID photo
                    const SizedBox(height: 30),
                    if (controller.cardID == "")
                      InkWell(
                        onTap: () {
                          _showPicker(context);
                          isCard = true;
                        },
                        child: Container(
                          width: 320,
                          height: 210,
                          foregroundDecoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Uploud image for card ID",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 10),
                              Icon(
                                FontAwesomeIcons.solidAddressCard,
                                size: 120,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      InkWell(
                        onTap: () {
                          _showPicker(context);
                          isCard = true;
                        },
                        child: Container(
                          width: 320,
                          height: 210,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                controller.cardID,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Personal photo
                    const SizedBox(height: 25),
                    if (controller.personal == "")
                      InkWell(
                        onTap: () {
                          _showPicker(context);
                          isCard = false;
                        },
                        child: Container(
                          width: 320,
                          height: 210,
                          foregroundDecoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Uploud personal image",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 15),
                              Icon(
                                FontAwesomeIcons.userGroup,
                                size: 115,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      InkWell(
                        onTap: () {
                          _showPicker(context);
                          isCard = false;
                        },
                        child: Container(
                          width: 320,
                          height: 210,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                controller.personal,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Button
                    const SizedBox(height: 25),
                    if (controller.cardID != "" && controller.personal != "")
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                height: 40,
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const VerificationComplete()),
                                  );

                                  _navigateAfterVerification();
                                },
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  "Verification",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
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
        );
      },
    );
  }
}

class VerificationComplete extends StatefulWidget {
  const VerificationComplete({super.key});

  @override
  State<VerificationComplete> createState() => _VerificationCompleteState();
}

class _VerificationCompleteState extends State<VerificationComplete> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/circle-check.png", scale: 7.5),
            const SizedBox(height: 20),
            const Text(
              "Identity Verfication is in progress",
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            const Text(
              "We will notify you via email message as soon as your account will be verified",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
