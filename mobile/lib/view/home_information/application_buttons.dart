import 'package:client/controller/application/applications_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/property.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicationButtons extends StatefulWidget {
  final Property property;

  const ApplicationButtons({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  State<ApplicationButtons> createState() => _ApplicationButtonstState();
}

class _ApplicationButtonstState extends State<ApplicationButtons> {
  ApplicationsController applicationsController =
      Get.put(ApplicationsController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 175,
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
                          constraints: const BoxConstraints(maxHeight: 550),
                          child: CustomDialogApply(
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
              child: Center(
                child: Text(
                  widget.property.listingType == "For monthly rent"
                      ? "Request to Rent"
                      : "Request to Buy",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 175,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.black, width: 1.4),
              ),
              onPressed: () {
                String phone = "0${widget.property.user!.phoneNumber}";
                launch('tel:$phone');
              },
              height: 45,
              child: const Center(
                child: Text(
                  "Request a Tour",
                  style: TextStyle(
                    color: Colors.black,
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

class CustomDialogApply extends StatefulWidget {
  final Property property;

  CustomDialogApply({Key? key, required this.property}) : super(key: key);

  @override
  _CustomDialogApplyState createState() => _CustomDialogApplyState();
}

class _CustomDialogApplyState extends State<CustomDialogApply> {
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
            "Request to apply",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const TextFieldWithLabel(label: 'First & last name'),
                const TextFieldWithLabel(label: 'Phone'),
                const TextFieldWithLabel(label: 'Email'),
                const TextFieldWithLabel(label: 'Message'),
                TextFieldWithLabel(
                  label: "The price you pay for this property",
                  property: widget.property,
                ),
                const Padding(
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

class TextFieldWithLabel extends StatelessWidget {
  final String label;
  final Property? property;
  const TextFieldWithLabel({super.key, required this.label, this.property});

  @override
  Widget build(BuildContext context) {
    ApplicationsController controller =
        Get.put(ApplicationsController(), permanent: true);

    String hintText() {
      if (label == "Message") {
        return "Add your message";
      } else if (label == "The price you pay for this property") {
        if (property?.listingType == "For rent") {
          return "Enter the monthly rental price";
        } else {
          return "Enter the buy price";
        }
      }
      return label;
    }

    String suffixText() {
      if (label == "The price you pay for this property") {
        if (property?.listingType == "For rent") {
          return '\$/mo';
        } else {
          return "\$";
        }
      }
      return "";
    }

    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: label == "The price you pay for this property"
                ? controller.suggestedPrice
                : label == "Message"
                    ? controller.message
                    : null,
            maxLines: label == "Message" ? 4 : 1,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              hintText: hintText(),
              border: const OutlineInputBorder(),
              suffixText: suffixText(),
              suffixStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
