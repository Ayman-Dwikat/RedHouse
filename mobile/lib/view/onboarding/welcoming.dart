import 'package:client/controller/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Welcoming extends StatelessWidget {
  const Welcoming({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OnBoardingControllerImp controller = Get.put(OnBoardingControllerImp());

    // Add a delay of 4 seconds and then navigate to the login screen
    Future.delayed(const Duration(seconds: 4), () {
      controller.toOnBoardingOne();
    });

    return Scaffold(
      body: Container(
        // ignore: sort_child_properties_last
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Image.asset("assets/images/logo.png", scale: 3),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Red",
                  style: TextStyle(
                      color: Color(0xffd92328),
                      fontSize: 42,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "House",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                )
              ],
            ),
            const Text(
              "GROW WITH US",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.grey,
                  letterSpacing: 5,
                  fontWeight: FontWeight.w300),
            )
          ],
        ),
        padding: const EdgeInsets.only(bottom: 130),
      ),
    );
  }
}
