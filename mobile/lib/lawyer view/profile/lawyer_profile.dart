import 'dart:convert';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/main.dart';
import 'package:client/view/more/my_feedback.dart';
import 'package:client/view/more/profile/edit_profile.dart';
import 'package:client/view/more/user_level.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LawyerProfile extends StatefulWidget {
  const LawyerProfile({super.key});

  @override
  State<LawyerProfile> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<LawyerProfile>
    with AutomaticKeepAliveClientMixin {
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  Map<String, dynamic> userDto = json.decode(sharepref.getString("user")!);

  @override
  bool get wantKeepAlive => true; // Keep the state alive

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return VisibilityDetector(
      key: const Key('Profile'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          userDto = json.decode(sharepref.getString("user")!);
          setState(() {});
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              // Navigator.pop(context);
            },
            icon: const Icon(
              FontAwesomeIcons.angleLeft,
            ),
          ),
          title: const Text(
            "Profile",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Color.fromRGBO(0, 153, 115, 1),
                        color: const Color(0xFF001BFF).withOpacity(0.65),
                      ),
                      child: Center(
                        child: Text(
                          loginController
                              .getShortenedName(userDto["name"] ?? ""),
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
                          FontAwesomeIcons.pencil,
                          size: 18,
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
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const EditProfile());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFEE400),
                      // backgroundColor: Colors.black,
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
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 10),

                // MENU
                ProfileMenuWidget(
                  title: 'Setting',
                  icon: FontAwesomeIcons.cog,
                  onPress: () {},
                ),
                ProfileMenuWidget(
                    title: 'User Level',
                    icon: FontAwesomeIcons.solidUser,
                    sizeIcon: 21,
                    onPress: () {
                      Get.to(() => const UserLevel());
                    }),
                ProfileMenuWidget(
                    title: 'Change Theme',
                    icon: FontAwesomeIcons.palette,
                    sizeIcon: 22,
                    onPress: () {}),
                Divider(color: Colors.grey[300]),
                const SizedBox(height: 10),
                ProfileMenuWidget(
                    title: 'Feedback',
                    icon: Icons.feedback,
                    sizeIcon: 24,
                    onPress: () {
                      Get.to(() => const MyFeedback());
                    }),
                ProfileMenuWidget(
                    title: 'Logout',
                    icon: FontAwesomeIcons.rightFromBracket,
                    textColor: Colors.red[700],
                    sizeIcon: 22,
                    onPress: () {
                      sharepref.remove("user");
                      Get.offAllNamed("/login");
                    }),
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
