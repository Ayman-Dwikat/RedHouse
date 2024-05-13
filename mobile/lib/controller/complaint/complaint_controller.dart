import 'package:client/data/complaint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ComplaintController extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  int userId = 1;
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  sendComplaint() async {
    var response = await ComplaintData.sendComplaint(userId, description.text);
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
