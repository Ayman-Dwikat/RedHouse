import 'dart:convert';

import 'package:client/controller/users_auth/account_verification_controller.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DisplayVerificaionStatus extends StatefulWidget {
  const DisplayVerificaionStatus({super.key});

  @override
  State<DisplayVerificaionStatus> createState() =>
      _DisplayVerificaionStatusState();
}

class _DisplayVerificaionStatusState extends State<DisplayVerificaionStatus> {
  AccountVerificationController controller =
      Get.put(AccountVerificationController(), permanent: true);
  Map<String, dynamic> userDto = json.decode(sharepref.getString("user")!);

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    await controller.getUserVerification(userDto["id"]);
    print(controller.userVerification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Identity Verification",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.userVerification?.requestStatus == "Pending")
              pending()
            else if (controller.userVerification?.requestStatus == "Accepted")
              accepted()
            else
              rejected(),
          ],
        ),
      ),
    );
  }

  Widget pending() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/circle-mark.png", scale: 7),
        const SizedBox(height: 20),
        const Text(
          "Identity Verification is in progress",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 25),
        const Text(
          "We will notify you via email message as soon as your account will be verified",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget accepted() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/circle-check.png", scale: 7.5),
        const SizedBox(height: 20),
        const Text(
          "Complete Verification",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 25),
        const Text(
          "Your account has been properly verified, you can use your account safely",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Widget rejected() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/error-icon.png", scale: 8),
        const SizedBox(height: 20),
        const Text(
          "Verification Failed",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 25),
        const Text(
          "Your account can be suspended or requested to be verified again at any time",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
