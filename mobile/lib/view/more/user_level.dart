// ignore_for_file: sized_box_for_whitespace

import 'dart:convert';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/controller/users_auth/signup_controller.dart';
import 'package:client/core/functions/validInput.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UserLevel extends StatefulWidget {
  const UserLevel({super.key});

  @override
  State<UserLevel> createState() => _EditProfileState();
}

class _EditProfileState extends State<UserLevel> {
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  SignUpControllerImp controller =
      Get.put(SignUpControllerImp(), permanent: true);
  Map<String, dynamic> userDto = json.decode(sharepref.getString("user")!);

  @override
  void initState() {
    loadUser();
    super.initState();
  }

  void loadUser() async {
    await controller.getUser(userDto["id"]);
    userDto = json.decode(sharepref.getString("user")!);
    print(userDto);
    controller.email.text = userDto["email"];
    controller.firstName.text = userDto["name"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            FontAwesomeIcons.angleLeft,
          ),
        ),
        title: const Text(
          "User Level",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formstateUpdate,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF001BFF).withOpacity(0.65),
                      ),
                      child: Center(
                        child: Text(
                          loginController.getShortenedName(userDto["name"]),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 38,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: const Color(0xFFFEE400),
                        ),
                        child: const Icon(
                          Icons.photo_camera,
                          size: 21,
                          color: Color.fromARGB(221, 54, 52, 52),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  userDto["name"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  userDto["email"] ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "User Level",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  userDto["userRole"] ?? "",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 196, 39, 27),
                  ),
                ),
                const SizedBox(height: 25),
                const Text(
                  "# of properties sell or rent",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                buildRatingRow(
                    userDto["landlordScore"], userDto["landlordScore"], 5),
                const SizedBox(height: 25),
                const Text(
                  "# of properties buy or rented",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                buildRatingRow(
                    userDto["customerScore"], userDto["customerScore"], 5),
                const SizedBox(height: 170),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                          text: "Joinded ",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: DateFormat('MMM d, y')
                                  .format(DateTime.parse(userDto["created"])),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 196, 39, 27),
                              ),
                            ),
                          ]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRatingRow(int rating, int count, int totalCount) {
    double percentage = (count / totalCount);

    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            child: Text('$rating/5   ',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                )),
          ),
          Container(
            width: 220,
            height: 13,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(100),
              value: percentage,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 196, 39, 27),
              ),
              backgroundColor: Colors.grey,
            ),
          ),
          // Text(' $percentage%'),
        ],
      ),
    );
  }
}
