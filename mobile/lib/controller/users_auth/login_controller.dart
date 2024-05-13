import 'dart:convert';
import 'package:client/controller/bottom_bar/bottom_bar.dart';
import 'package:client/controller/map_list/map_list_controller.dart';
import 'package:client/core/class/statusrequest.dart';
import 'package:client/core/functions/handlingdata.dart';
import 'package:client/data/users_auth.dart';
import 'package:client/main.dart';
import 'package:client/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginControllerImp extends GetxController {
  BottomBarController bottomBarController =
      Get.put(BottomBarController(), permanent: true);
  MapListController mapListController =
      Get.put(MapListController(), permanent: true);
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController email;
  late TextEditingController password;
  late StatusRequest statusRequest;
  List data = [];

  Map<String, dynamic>? userDto;
  // instance of fireStore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  login() async {
    if (formstate.currentState!.validate()) {
      var response = await UserData.login(password.text, email.text);
      statusRequest = handlingData(response);
      if (response['statusCode'] == 200) {
        setToken(response['message']);
        sharepref.setString("user", jsonEncode(response['dto']));
        userDto = json.decode(sharepref.getString("user") ?? "{}");

        // add new document for ths user in users collection if it doesn't already exists
        String userId = userDto!["id"].toString();
        _fireStore.collection('users').doc(userId).set({
          'uid': userId,
          'email': userDto?["email"],
          'name': userDto?["name"],
        }, SetOptions(merge: true));

        bottomBarController.currentIndex = 0;
        mapListController.isListIcon = true;

        if (userDto?["isVerified"] == true) {
          if (userDto?["userRole"] == "Lawyer") {
            Get.offAllNamed("/lawyer-bottom-bar");
          } else {
            Get.offAllNamed("/bottom-bar");
          }
        } else {
          Get.toNamed("/verification");
        }
      } else {
        Get.defaultDialog(
          title: "ُWarning",
          middleText: 'The email or password you entered invalid',
        );
        statusRequest = StatusRequest.failure;
      }
      return;
    } else {
      Get.defaultDialog(
        title: "ُWarning",
        middleText: 'There is something wronge!',
      );
      statusRequest = StatusRequest.failure;
    }
  }

  String getShortenedName(String? name) {
    if (name != null) {
      final nameParts = name.split(' ');
      if (nameParts.length == 2) {
        return nameParts[0].substring(0, 1) + nameParts[1].substring(0, 1);
      } else if (nameParts.length == 1) {
        return nameParts[0].substring(0, 1);
      }
    }
    return "";
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
