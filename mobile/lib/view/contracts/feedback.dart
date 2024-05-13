import 'package:client/controller/history/history_controller.dart';
import 'package:client/core/functions/validInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class Feedback extends StatefulWidget {
  final int contractId;
  final int userId;
  const Feedback({Key? key, required this.contractId, required this.userId})
      : super(key: key);
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback>
    with SingleTickerProviderStateMixin {
  HistoryController controller = Get.put(HistoryController(), permanent: true);
  late AnimationController _animationController;
  late Animation<int> _textAnimation;
  String descriptionError = "";

  void sendFeedback() async {
    await controller.sendFeedback(widget.userId, widget.contractId);
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _textAnimation = IntTween(
            begin: 0,
            end:
                "You can give a feedback and rating about the user, to keep a reference about him so that others can see it to get an impression of this user."
                    .length)
        .animate(_animationController);

    _animationController.forward();

    print(widget.userId);
    print(widget.contractId);
    controller.feedback.text = "";
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Give Feedback",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formstate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Introduction
                Container(height: 10),
                Row(
                  children: [
                    Image.asset("assets/images/logo.png", scale: 11),
                  ],
                ),
                AnimatedBuilder(
                  animation: _textAnimation,
                  builder: (context, child) {
                    String animatedText =
                        "You can give a feedback and rating about the user, to keep a reference about him so that others can see it to get an impression of this user."
                            .substring(0, _textAnimation.value);
                    return Text(
                      animatedText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                      ),
                    );
                  },
                ),

                Container(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        RatingBar.builder(
                          itemCount: 5,
                          initialRating: 1,
                          minRating: 1,
                          itemBuilder: (context, index) {
                            return const Icon(
                              Icons.star,
                              color: Colors.amber,
                            );
                          },
                          onRatingUpdate: (value) {
                            controller.rating = value.toInt();
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ],
                ),

                Container(height: 20),
                Container(
                  child: TextFormField(
                    validator: (val) {
                      descriptionError =
                          validInput(val!, 10, 400, "description");
                      return descriptionError.isNotEmpty
                          ? descriptionError
                          : null;
                    },
                    minLines: 8,
                    maxLines: 20,
                    controller: controller.feedback,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      hintText: "Add your feedback",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                Container(height: 30),
                Container(
                  width: 400,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      setState(() {});

                      if (controller.formstate.currentState!.validate() &&
                          controller.feedback.text.isNotEmpty) {
                        sendFeedback();
                        ScaffoldMessenger.of(context).clearSnackBars();
                        SnackBar snackBar = const SnackBar(
                          content: Text("Sent Successfully"),
                          backgroundColor: Colors.blue,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                        Navigator.pop(context);
                      }
                    },
                    minWidth: 300,
                    height: 38,
                    color: Colors.black87,
                    child: const Center(
                      child: Text(
                        "Send",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
