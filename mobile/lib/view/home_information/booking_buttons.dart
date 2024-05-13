import 'package:client/controller/application/applications_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/property.dart';
import 'package:client/view/home_information/application_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingButtons extends StatefulWidget {
  final Property property;

  const BookingButtons({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<BookingButtons> createState() => _BookingButtonsState();
}

class _BookingButtonsState extends State<BookingButtons> {
  ApplicationsController applicationsController =
      Get.put(ApplicationsController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                applicationsController.message.text = "";
                applicationsController.suggestedPrice.text = "";

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Theme(
                      data: ThemeData(
                        dialogBackgroundColor: Colors.white,
                      ),
                      child: Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 450),
                          child: CustomDialogBook(
                            property: widget.property,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              height: 45,
              color: Colors.black87,
              child: const Center(
                child: Text(
                  "Request to Book",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDialogBook extends StatefulWidget {
  final Property property;

  CustomDialogBook({Key? key, required this.property}) : super(key: key);

  @override
  _CustomDialogBookState createState() => _CustomDialogBookState();
}

class _CustomDialogBookState extends State<CustomDialogBook> {
  ApplicationsController applicationsController =
      Get.put(ApplicationsController(), permanent: true);

  LoginControllerImp loginController =
      Get.put(LoginControllerImp(), permanent: true);
  String message = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "Request to book",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        const Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFieldWithLabel(label: 'First & last name'),
                TextFieldWithLabel(label: 'Phone'),
                TextFieldWithLabel(label: 'Email'),
                TextFieldWithLabel(label: 'Message'),
                Padding(
                  padding:
                      EdgeInsets.only(left: 16, right: 37, top: 20, bottom: 12),
                  child: Text(
                    "You agree to RedHouse's Terms of Use & Privacy Policy. By choosing to contact a property, you also agree that RedHouse Group, landlords, and property managers may call or text you about any inquiries you submit through our services, which may involve use of automated means and prerecorded/artificial voices.",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ButtonBar(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 210,
                    height: 40,
                    color: Colors.blue,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {});
                        ScaffoldMessenger.of(context).clearSnackBars();

                        Future<void> addApplicationFuture() async {
                          applicationsController.propertyId =
                              widget.property.id;
                          applicationsController.userId =
                              loginController.userDto?["id"];
                          await applicationsController.addApplication();

                          setState(() {
                            message = applicationsController.responseMessage;
                          });
                          print(message);

                          if (message == "Sent Successfully") {
                            SnackBar snackBar = SnackBar(
                              content: Text(message),
                              backgroundColor: Colors.blue,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.of(context).pop();
                          }
                        }

                        addApplicationFuture();
                      },
                      child: const Text(
                        "Send request",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  SizedBox(
                    height: 40,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: message == ""
                    ? null
                    : const EdgeInsets.only(top: 15, right: 12, left: 10),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
