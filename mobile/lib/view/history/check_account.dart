import 'package:client/controller/history/history_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/user.dart';
import 'package:client/view/history/user_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckAccount extends StatefulWidget {
  final User user;
  const CheckAccount({Key? key, required this.user}) : super(key: key);

  @override
  State<CheckAccount> createState() => _CheckAccountState();
}

class _CheckAccountState extends State<CheckAccount> {
  bool isLoading = true; // Add a boolean variable for loading state
  bool isFollowed = false;
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  late HistoryController historyController;

  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {});
  }

  void loadData() async {
    historyController = Get.put(HistoryController(), permanent: true);
    await historyController.getHistoryUser(widget.user.id!);

    setState(() {
      isLoading = false; // Set isLoading to false when data is loaded
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // Show a loading indicator
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 27),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 3),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 100),
                Column(
                  children: [
                    const SizedBox(height: 15),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(0, 153, 115, 1),
                      ),
                      child: Center(
                        child: Text(
                          loginController.getShortenedName(widget.user.name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              widget.user.name!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
            ),
            Text(
              widget.user.email!,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 7),
            GestureDetector(
              onTap: () {
                setState(() {
                  isFollowed = !isFollowed;
                });
              },
              child: Container(
                width: 140,
                height: 38,
                decoration: BoxDecoration(
                  color: isFollowed ? Colors.grey[300] : Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isFollowed) const SizedBox(width: 10),
                    Text(
                      isFollowed ? "Followed" : "Follow",
                      style: TextStyle(
                        fontSize: 16,
                        color: isFollowed ? Colors.black : Colors.white,
                      ),
                    ),
                    if (isFollowed)
                      const Icon(
                        Icons.keyboard_arrow_down_sharp,
                        color: Colors.black,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Divider(thickness: 1.5),
            UserHistoryWidget(),
          ],
        ),
      ),
    );
  }
}
