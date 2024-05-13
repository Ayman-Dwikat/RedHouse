import 'dart:convert';
import 'package:client/core/class/statusrequest.dart';
import 'package:client/data/users_auth.dart';
import 'package:client/main.dart';
import 'package:client/model/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpControllerImp extends GetxController {
  int landlordScore = 0;
  int customerScore = 0;
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController firstName;
  late TextEditingController lastName;
  late String userRole;
  late TextEditingController phoneNumber;
  late TextEditingController postalCode;
  late StatusRequest statusRequest;

  GlobalKey<FormState> formstateRegister = GlobalKey<FormState>();
  GlobalKey<FormState> formstateUpdate = GlobalKey<FormState>();
  List<User> listAutoCompleteLawyer = [];
  List<User> listAutoCompleteAgent = [];
  List<User> lawyerContacts = [];

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    firstName = TextEditingController();
    lastName = TextEditingController();
    postalCode = TextEditingController();
    phoneNumber = TextEditingController();
    userRole = "Basic Account";
    super.onInit();
  }

  signUp() async {
    if (formstateRegister.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      var response = await UserData.signUp(
          firstName.text,
          lastName.text,
          password.text,
          phoneNumber.text,
          email.text,
          userRole,
          postalCode.text);

          print(response);

      if (response['statusCode'] == 200) {
        Get.offAllNamed("/login");
      } else {
        Get.defaultDialog(
          title: "Error",
          middleText:
              "statusCode: ${response['statusCode']}, exception: ${response['exception']}",
        );
        statusRequest = StatusRequest.failure;
      }

      update();
    }
  }

  updateUser(int userId) async {
    var response = await UserData.updateUser(
      userId,
      firstName.text,
      email.text,
      phoneNumber.text,
    );

    if (response is Map<String, dynamic> && response['statusCode'] == 200) {
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  updateUserScore(int userId) async {
    var response = await UserData.updateUserScore(
      userId,
      userRole,
    );

    if (response is Map<String, dynamic> && response['statusCode'] == 200) {
      print(response);
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  updateUserVerified(int userId, bool isVerified) async {
    var response = await UserData.updateUserVerified(userId, isVerified);

    if (response is Map<String, dynamic> && response['statusCode'] == 200) {
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  getUser(int userId) async {
    var response = await UserData.getUser(userId);

    if (response['statusCode'] == 200) {
      sharepref.setString(
        "user",
        jsonEncode(
            User.fromJson(response['dto'] as Map<String, dynamic>).toJson()),
      );
      print(sharepref.getString("user"));
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  getListAutoCompleteLawyer(String query) async {
    query = query.isEmpty ? "*" : query;
    var response = await UserData.getListAutoCompleteLawyer(query);

    if (response['statusCode'] == 200) {
      listAutoCompleteLawyer = (response['listDto'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  getListAutoCompleteAgent(String query) async {
    query = query.isEmpty ? "*" : query;
    var response = await UserData.getListAutoCompleteAgent(query);

    if (response['statusCode'] == 200) {
      listAutoCompleteAgent = (response['listDto'] as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  getlawyerContacts(int id) async {
    var response = await UserData.getlawyerContacts(id);

    if (response is Map<String, dynamic>) {
      if (response['statusCode'] == 200) {
        lawyerContacts = (response['listDto'] as List<dynamic>)
            .map((e) => User.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        Get.defaultDialog(
          title: "Error",
          middleText:
              "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
        );
      }
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    firstName.dispose();
    lastName.dispose();
    phoneNumber.dispose();
    postalCode.dispose();
    super.dispose();
  }
}
