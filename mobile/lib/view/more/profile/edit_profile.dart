import 'dart:convert';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/controller/users_auth/signup_controller.dart';
import 'package:client/core/functions/validInput.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  SignUpControllerImp controller =
      Get.put(SignUpControllerImp(), permanent: true);
  Map<String, dynamic> userDto = json.decode(sharepref.getString("user")!);
  String passwordError = "";
  String emailError = "";
  String nameError = "";
  String phoneError = "";
  String postalCodeError = "";

  @override
  void initState() {
    super.initState();
    controller.email.text = userDto["email"];
    controller.password.text = "11111Aa!";
    controller.firstName.text = userDto["name"];
    controller.postalCode.text =
        userDto["locationId"].toString().padLeft(4, "${userDto["locationId"]}");
    controller.phoneNumber.text = userDto["phoneNumber"].toString();
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
          "Edit Profile",
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
                const SizedBox(height: 75),

                // FIELDS
                TextFormField(
                  validator: (val) {
                    nameError = validInput(val!, 2, 100, "");
                    return nameError.isNotEmpty ? nameError : null;
                  },
                  controller: controller.firstName,
                  decoration: InputDecoration(
                    label: const Text(
                      "Full Name",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.solidUser,
                      color: const Color(0xFF001BFF).withOpacity(0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  validator: (val) {
                    emailError = validInput(val!, 5, 100, "email");
                    return emailError.isNotEmpty ? emailError : null;
                  },
                  controller: controller.email,
                  decoration: InputDecoration(
                    label: const Text(
                      "E-Mail",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.solidEnvelope,
                      color: const Color(0xFF001BFF).withOpacity(0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  validator: (val) {
                    passwordError = validInput(val!, 8, 100, "password");
                    return passwordError.isNotEmpty ? passwordError : null;
                  },
                  controller: controller.password,
                  obscureText: true,
                  decoration: InputDecoration(
                    label: const Text(
                      "Password",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.fingerprint,
                      color: const Color(0xFF001BFF).withOpacity(0.7),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  validator: (val) {
                    phoneError = validInput(val!, 9, 100, "phone");
                    return phoneError.isNotEmpty ? phoneError : null;
                  },
                  controller: controller.phoneNumber,
                  decoration: InputDecoration(
                    label: const Text(
                      "Phone No",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.phone,
                      color: const Color(0xFF001BFF).withOpacity(0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                TextFormField(
                  validator: (val) {
                    postalCodeError = validInput(val!, 4, 100, "postalCode");
                    return postalCodeError.isNotEmpty ? postalCodeError : null;
                  },
                  controller: controller.postalCode,
                  decoration: InputDecoration(
                    label: const Text(
                      "Postal Code",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.solidMap,
                      size: 22,
                      color: const Color(0xFF001BFF).withOpacity(0.6),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 500,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.formstateUpdate.currentState!.validate() &&
                          controller.password.text.isNotEmpty &&
                          controller.email.text.isNotEmpty &&
                          controller.firstName.text.isNotEmpty &&
                          controller.phoneNumber.text.isNotEmpty &&
                          controller.postalCode.text.isNotEmpty) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        SnackBar snackBar = const SnackBar(
                          content: Text("Edited Successfully"),
                          backgroundColor: Colors.blue,
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        await controller.updateUser(userDto["id"]);
                        await controller.getUser(userDto["id"]);
                        userDto = json.decode(sharepref.getString("user")!);

                        controller.email.text = userDto["email"];
                        controller.firstName.text = userDto["name"];
                        controller.phoneNumber.text =
                            userDto["phoneNumber"].toString();
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE400),
                      side: BorderSide.none,
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF272727),
                        // color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    SizedBox(
                      width: 105,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 245, 244, 244),
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color.fromARGB(255, 196, 39, 27),
                            // color: Colors.white,
                          ),
                        ),
                      ),
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
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
    this.sizeIcon = 23,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  final double sizeIcon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color(0xFF001BFF).withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF001BFF).withOpacity(0.6),
          size: sizeIcon,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 17.5,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(
                FontAwesomeIcons.angleRight,
                size: 18,
                color: Colors.grey,
              ),
            )
          : null,
    );
  }
}
