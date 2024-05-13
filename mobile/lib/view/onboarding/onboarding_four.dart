import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingFour extends StatelessWidget {
  const OnBoardingFour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: 30,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Red",
                  style: TextStyle(
                    color: Color(0xffd92328),
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "House",
                  style: TextStyle(color: Colors.black, fontSize: 24),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 53,
                ),
                Image.asset("assets/images/for-rent.jpg", scale: 0.5),
                Container(
                  height: 73,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome To ",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Red",
                      style: TextStyle(
                        color: Color(0xffd92328),
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "House",
                      style: TextStyle(color: Colors.black, fontSize: 24),
                    ),
                  ],
                ),
                Container(
                  height: 10,
                ),
                Text(
                  "Check user history so you can improve decision-making",
                  textAlign: TextAlign.center, // Corrected textAlign
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[700],
                  ),
                ),
                Container(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...List.generate(
                        4,
                        (index) => Container(
                              margin: const EdgeInsets.only(right: 5),
                              height: 6,
                              width: 6,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)),
                            ))
                  ],
                ),
                Container(
                  height: 20,
                ),
                Container(
                  width: 220,
                  child: MaterialButton(
                    onPressed: () {
                      sharepref.setString("first", "no");
                      Get.offAllNamed("/bottom-bar");
                    },
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
