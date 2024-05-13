import 'dart:convert';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/lawyer%20view/lawyer%20contract/all_contracts.dart';
import 'package:client/lawyer%20view/messages/messages_page.dart';
import 'package:client/lawyer%20view/profile/lawyer_profile.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LawyerBottomBar extends StatefulWidget {
  const LawyerBottomBar({Key? key}) : super(key: key);

  @override
  State<LawyerBottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<LawyerBottomBar> {
  int currentIndex = 0;
  Color primaryColor = Color.fromARGB(255, 26, 85, 154);
  LoginControllerImp loginController =
      Get.put(LoginControllerImp(), permanent: true);

  final List<Icon> _unselectedIcons = [
    Icon(
      FontAwesomeIcons.solidHandshake,
      color: Colors.grey[600],
    ),
    Icon(
      FontAwesomeIcons.solidComment,
      color: Colors.grey[600],
    ),
    Icon(
      FontAwesomeIcons.userGraduate,
      color: Colors.grey[600],
    ),
  ];

  final List<Icon> _selectedIcons = [
    const Icon(
      FontAwesomeIcons.solidHandshake,
    ),
    const Icon(
      FontAwesomeIcons.solidComment,
    ),
    const Icon(
      FontAwesomeIcons.userGraduate,
    ),
  ];

  @override
  void initState() {
    super.initState();
    loginController.userDto = json.decode(sharepref.getString("user") ?? "{}");
    print(loginController.userDto);
    print(loginController.userDto);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          LawyerContracts(),
          LawyerMessges(),
          LawyerProfile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 18,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF001BFF),
        unselectedItemColor: Colors.grey[800],
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        items: [
          _buildBottomNavigationBarItem(0),
          _buildBottomNavigationBarItem(1),
          _buildBottomNavigationBarItem(2),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(int index) {
    return BottomNavigationBarItem(
      icon: currentIndex == index
          ? _selectedIcons[index]
          : _unselectedIcons[index],
      label: _getLabel(index),
    );
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return "Contracts";
      case 1:
        return "Messages";
      case 2:
        return "Profile";
      default:
        return "";
    }
  }
}
