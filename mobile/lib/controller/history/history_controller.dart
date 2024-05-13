import 'package:client/data/history.dart';
import 'package:client/model/user_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  List<UserHistory> userHistories = [];
  List<UserHistory> propertyHistory = [];

  TextEditingController feedback = TextEditingController();
  int rating = 1;

  getHistoryUser(int userId) async {
    var response = await UserHistoryData.getUserHistory(userId);

    if (response['statusCode'] == 200) {
      userHistories = (response['listDto'] as List<dynamic>)
          .map((e) => UserHistory.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  getHistoryProperty(int propertId) async {
    var response = await UserHistoryData.getPropertyHistory(propertId);

    if (response['statusCode'] == 200) {
      propertyHistory = (response['listDto'] as List<dynamic>)
          .map((e) => UserHistory.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  sendFeedback(int userId, int contractId) async {
    var response = await UserHistoryData.sendFeedback(
        userId, contractId, feedback.text, rating);


    if (response['statusCode'] == 200) {
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }
}
