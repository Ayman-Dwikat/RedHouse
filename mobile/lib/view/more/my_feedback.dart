import 'package:client/controller/history/history_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/view/history/user_history_widget.dart';

class MyFeedback extends StatefulWidget {
  const MyFeedback({super.key});

  @override
  State<MyFeedback> createState() => _MyFeedbackState();
}

class _MyFeedbackState extends State<MyFeedback> {
  bool isLoading = true; // Add a boolean variable for loading state
  bool isFollowed = false;
  late HistoryController historyController;
  LoginControllerImp loginController = Get.put(LoginControllerImp());

  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {});
  }

  void loadData() async {
    historyController = Get.put(HistoryController(), permanent: true);
    await historyController.getHistoryUser(loginController.userDto?["id"]);

    setState(() {
      isLoading = false; // Set isLoading to false when data is loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Feedback",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: bodyMyFeedback(),
    );
  }

  Widget bodyMyFeedback() {
    if (historyController.userHistories.isEmpty) {
      return Container(
        margin: const EdgeInsetsDirectional.symmetric(vertical: 60),
        child: SingleChildScrollView(
          child: UserHistoryWidget(),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: UserHistoryWidget(),
      );
    }
  }
}
