import 'package:client/controller/complaint/complaint_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/core/functions/validInput.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Complaint extends StatefulWidget {
  const Complaint({super.key});

  @override
  State<Complaint> createState() => _ComplineState();
}

class _ComplineState extends State<Complaint> {
  ComplaintController controller = Get.put(ComplaintController());
  LoginControllerImp loginController = Get.put(LoginControllerImp());

  String nameError = "";
  String emailError = "";
  String descriptionError = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Send Complaint",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: controller.formstate,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  const Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(height: 5),
                  TextFormField(
                    validator: (val) {
                      nameError = validInput(val!, 2, 100, "");
                      return nameError.isNotEmpty ? nameError : null;
                    },
                    controller: controller.name,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      suffixIcon: const Icon(FontAwesomeIcons.solidUser),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Email
                  Container(height: 20),
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(height: 5),
                  TextFormField(
                    validator: (val) {
                      emailError = validInput(val!, 5, 100, "email");
                      return emailError.isNotEmpty ? emailError : null;
                    },
                    controller: controller.email,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      suffixIcon: const Icon(Icons.email),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Description
                  Container(height: 20),
                  const Text(
                    "Compline description",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(height: 5),
                  Container(
                    child: TextFormField(
                      validator: (val) {
                        descriptionError =
                            validInput(val!, 10, 1000, "description");
                        return descriptionError.isNotEmpty
                            ? descriptionError
                            : null;
                      },
                      minLines: 10,
                      maxLines: 20,
                      controller: controller.description,
                      style: const TextStyle(),
                      decoration: InputDecoration(
                        // suffixIcon: Icon(Icons.description),
                        hintText:
                            "Example: New house in the center of the city, there is close school and very beautiful view",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  // Button
                  Container(height: 40),
                  Container(
                    width: 400,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        setState(() {});
                        if (controller.formstate.currentState!.validate() &&
                            controller.name.text.isNotEmpty &&
                            controller.email.text.isNotEmpty &&
                            controller.description.text.isNotEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          SnackBar snackBar = const SnackBar(
                            content: Text("Send Successfully"),
                            backgroundColor: Colors.blue,
                          );
                          controller.userId = loginController.userDto?["id"];

                          Future<void> sendComplaintFuture() async {
                            await controller.sendComplaint();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }

                          sendComplaintFuture();
                        }
                      },
                      minWidth: 400,
                      height: 40,
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
      ),
    );
  }
}
