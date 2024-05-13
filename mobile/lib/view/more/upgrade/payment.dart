import 'dart:convert';
import 'package:client/controller/booking/booking_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/controller/users_auth/signup_controller.dart';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class Payment extends StatefulWidget {
  final int selectedCardIndex;
  const Payment({
    Key? key,
    required this.selectedCardIndex,
  }) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  BookingController bookingController = Get.put(BookingController());
  SignUpControllerImp controller =
      Get.put(SignUpControllerImp(), permanent: true);
  Map<String, dynamic> userDto = json.decode(sharepref.getString("user")!);
  int cardType = 1;
  bool checkStep1 = false;



  void handleRadio(Object? e) => setState(() {
        cardType = e as int;
      });

  String _hintText() {
    switch (cardType) {
      case 1:
        return "Amazon Pay";
      case 2:
        return "Credit Card";
      case 3:
        return "Paypal";
      case 4:
        return "Google Pay";

      default:
        return "";
    }
  }

  Widget _hintImage() {
    switch (cardType) {
      case 1:
        return Image.asset(
          "assets/images/amazon-pay.png",
          width: 77,
        );
      case 2:
        return SizedBox(
          width: 72,
          child: Row(
            children: [
              Image.asset(
                "assets/images/visa.png",
                width: 35,
                height: 35,
              ),
              const SizedBox(width: 5),
              Image.asset(
                "assets/images/mastercard.png",
                width: 28,
                height: 28,
              ),
            ],
          ),
        );
      case 3:
        return Image.asset(
          "assets/images/paypal.png",
          width: 70,
        );
      case 4:
        return Image.asset(
          "assets/images/google-pay.png",
          width: 75,
        );

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Payment",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              // Amazon Pay
              InkWell(
                onTap: () {
                  cardType = 1;
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 0),
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    border: cardType == 1
                        ? Border.all(width: 1.3, color: const Color(0xFFDB3022))
                        : Border.all(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 1,
                                groupValue: cardType,
                                onChanged: handleRadio,
                                activeColor: const Color(0xFFDB3022),
                              ),
                              Text(
                                "Amazon Pay",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: cardType == 1
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/images/amazon-pay.png",
                            width: 82,
                            height: 82,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Credit Card
              InkWell(
                onTap: () {
                  cardType = 2;
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 0),
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    border: cardType == 2
                        ? Border.all(width: 1.3, color: const Color(0xFFDB3022))
                        : Border.all(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 2,
                                groupValue: cardType,
                                onChanged: handleRadio,
                                activeColor: const Color(0xFFDB3022),
                              ),
                              Text(
                                "Credit Card",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: cardType == 2
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Image.asset(
                            "assets/images/visa.png",
                            width: 39,
                            height: 39,
                          ),
                          const SizedBox(width: 4),
                          Image.asset(
                            "assets/images/mastercard.png",
                            width: 32,
                            height: 32,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Paypal
              InkWell(
                onTap: () {
                  cardType = 3;
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 0),
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    border: cardType == 3
                        ? Border.all(width: 1.3, color: const Color(0xFFDB3022))
                        : Border.all(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 3,
                                groupValue: cardType,
                                onChanged: handleRadio,
                                activeColor: const Color(0xFFDB3022),
                              ),
                              Text(
                                "Paypal",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: cardType == 3
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/images/paypal.png",
                            width: 77,
                            height: 77,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Google Pay
              InkWell(
                onTap: () {
                  cardType = 4;
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 0),
                  width: size.width,
                  height: 55,
                  decoration: BoxDecoration(
                    border: cardType == 4
                        ? Border.all(width: 1.3, color: const Color(0xFFDB3022))
                        : Border.all(width: 0.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio(
                                value: 4,
                                groupValue: cardType,
                                onChanged: handleRadio,
                                activeColor: const Color(0xFFDB3022),
                              ),
                              Text(
                                "Google Pay",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: cardType == 4
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Image.asset(
                            "assets/images/google-pay.png",
                            width: 82,
                            height: 82,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 60),
              Form(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card number
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.grey[200], // Background color
                    ),
                    child: TextFormField(
                      controller: bookingController.cardNumber,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(16),
                        CardNumberInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        hintText: _hintText(),
                        border: InputBorder.none, // Hide the border
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 7),
                          child: _hintImage(),
                        ),
                      ),
                    ),
                  ),

                  if (checkStep1)
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "Card Number must 16 digits",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.red[500],
                          fontSize: 15,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Cardholder name
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.grey[200], // Background color
                    ),
                    child: TextFormField(
                      controller: bookingController.cardName,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(10),
                        hintText: "Cardholder name",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Icon(
                            FontAwesomeIcons.userGroup,
                            size: 20,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (checkStep1)
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "Cardholder Name is required",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.red[500],
                          fontSize: 15,
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // CCV and MM/YY
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.grey[200], // Background color
                        ),
                        child: TextFormField(
                          controller: bookingController.cardCCV,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(10),
                            hintText: "CCV",
                            suffixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Icon(
                                FontAwesomeIcons.solidAddressCard,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      )),
                      const SizedBox(width: 15),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          color: Colors.grey[200], // Background color
                        ),
                        child: TextFormField(
                          controller: bookingController.cardDate,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            CardMonthInputFormatter(),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(10),
                            hintText: "MM/YY",
                            suffixIcon: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Icon(
                                FontAwesomeIcons.calendar,
                                size: 20,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),

                  if (checkStep1)
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        "CCV must 4 digits      Date is required",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.red[500],
                          fontSize: 14.5,
                        ),
                      ),
                    ),
                ],
              )),

              const SizedBox(height: 20),
              MaterialButton(
                minWidth: 500,
                height: 40,
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () async {
                  // Remove any non-digit characters
                  String sanitizedValue = bookingController.cardNumber.text
                      .replaceAll(RegExp(r'\D'), '');

                  if (sanitizedValue.length != 16 ||
                      bookingController.cardCCV.text.length != 4 ||
                      bookingController.cardDate.text.length != 5 ||
                      bookingController.cardName.text.isEmpty) {
                    setState(() {
                      checkStep1 = true;
                    });
                  } else {
                  setState(() {
                    checkStep1 = false;
                  });
                  ScaffoldMessenger.of(context).clearSnackBars();
                  SnackBar snackBar = const SnackBar(
                    content: Text("Upgrade Successfully"),
                    backgroundColor: Colors.blue,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  if (widget.selectedCardIndex == 1) {
                    controller.userRole = "Customer";
                  } else if (widget.selectedCardIndex == 2) {
                    controller.userRole = "Landlord";
                  } else {
                    controller.userRole = "Agent";
                  }
                  await controller.updateUserScore(userDto["id"]);
                  await controller.getUser(userDto["id"]);
                  userDto = json.decode(sharepref.getString("user")!);

                  controller.email.text = userDto["email"];
                  controller.firstName.text = userDto["name"];
                  controller.phoneNumber.text =
                      userDto["phoneNumber"].toString();
                  Navigator.pop(context);

                  }
                },
                child: const Text(
                  "PAY",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;

      if (index % 4 == 0 && inputData.length != index) {
        buffer.write("  ");
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.toString().length),
    );
  }
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var newText = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (var i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      int index = i + 1;

      if (index % 2 == 0 && newText.length != index) {
        buffer.write("/");
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.toString().length),
    );
  }
}
