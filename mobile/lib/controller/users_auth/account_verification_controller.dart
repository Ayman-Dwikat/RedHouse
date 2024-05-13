import 'package:client/core/class/statusrequest.dart';
import 'package:client/data/users_auth.dart';
import 'package:client/model/verification.dart';
import 'package:get/get.dart';

class AccountVerificationController extends GetxController {
  int userId = 0;
  String cardID = "";
  String personal = "";
  List<String> downloadUrls = [];
  StatusRequest statusRequest = StatusRequest.loading;
  Verification? userVerification;

  verifyAccount() async {
    downloadUrls.add(cardID);
    downloadUrls.add(personal);
    statusRequest = StatusRequest.loading;
    var response = await UserData.verifyAccount(userId, downloadUrls);

    if (response['statusCode'] == 200) {
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
      statusRequest = StatusRequest.failure;
    }
  }

  getUserVerification(int userId) async {
    var response = await UserData.getUserVerification(userId);

    if (response['statusCode'] == 200) {
      userVerification =
          Verification.fromJson(response['dto'] as Map<String, dynamic>);
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }
}
