import 'dart:convert';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/controller/bottom_bar/bottom_bar.dart';
import 'package:client/main.dart';
import 'package:client/view/manage_properties/manage_properties.dart';
import 'package:client/view/messages/messages_page.dart';
import 'package:client/view/more/more.dart';
import 'package:client/view/search/search.dart';
import 'package:client/view/contracts/all_contracts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  BottomBarController bottomBarController =
      Get.put(BottomBarController(), permanent: true);

  LoginControllerImp loginController =
      Get.put(LoginControllerImp(), permanent: true);

  final List<Icon> _unselectedIcons = [
    Icon(
      FontAwesomeIcons.magnifyingGlassLocation,
      color: Colors.grey[600],
    ),
    Icon(
      FontAwesomeIcons.solidHandshake,
      color: Colors.grey[600],
    ),
    Icon(
      FontAwesomeIcons.solidComment,
      color: Colors.grey[600],
    ),
    Icon(
      FontAwesomeIcons.house,
      color: Colors.grey[600],
    ),
    Icon(
      FontAwesomeIcons.ellipsis,
      color: Colors.grey[700],
    ),
  ];

  final List<Icon> _selectedIcons = [
    const Icon(
      FontAwesomeIcons.magnifyingGlassLocation,
    ),
    const Icon(
      FontAwesomeIcons.solidHandshake,
    ),
    const Icon(
      FontAwesomeIcons.solidComment,
    ),
    const Icon(
      FontAwesomeIcons.house,
    ),
    const Icon(
      FontAwesomeIcons.ellipsis,
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

  Future<void> checkPermission() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    print(permission);

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Request location permission
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        // Location permission granted, you can now enable the location service
        bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

        if (!isLocationEnabled) {
          // Location service is not enabled, prompt the user to enable it
          isLocationEnabled = await Geolocator.openLocationSettings();
        }

        // At this point, the location service should be enabled
      } else {
        // Location permission denied
        print("Location permission denied");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: checkPermission(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return IndexedStack(
              index: bottomBarController.currentIndex,
              children: const [
                Search(),
                AllContracts(),
                Messages(),
                ManageProperties(),
                More(),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomBarController.currentIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 18,
        backgroundColor: Colors.white,
        selectedItemColor: const Color.fromARGB(255, 253, 45, 30),
        unselectedItemColor: Colors.grey[800],
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        items: [
          _buildBottomNavigationBarItem(0),
          _buildBottomNavigationBarItem(1),
          _buildBottomNavigationBarItem(2),
          _buildBottomNavigationBarItem(3),
          _buildBottomNavigationBarItem(4),
        ],
        onTap: (index) {
          setState(() {
            bottomBarController.currentIndex = index;
          });
        },
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(int index) {
    return BottomNavigationBarItem(
      icon: bottomBarController.currentIndex == index
          ? _selectedIcons[index]
          : _unselectedIcons[index],
      label: _getLabel(index),
    );
  }

  String _getLabel(int index) {
    switch (index) {
      case 0:
        return "Search";
      case 1:
        return "Contracts";
      case 2:
        return "Messages";
      case 3:
        return "Properties";
      case 4:
        return "More";
      default:
        return "";
    }
  }
}
