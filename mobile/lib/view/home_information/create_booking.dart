import 'package:client/controller/booking/booking_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/property.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateBooking extends StatefulWidget {
  final Property property;

  CreateBooking({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  _CreateBookingState createState() => _CreateBookingState();
}

class _CreateBookingState extends State<CreateBooking>
    with SingleTickerProviderStateMixin {
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  BookingController bookingController =
      Get.put(BookingController(), permanent: true);

  late AnimationController _animationController;
  late Animation<int> _textAnimation1;
  late Animation<int> _textAnimation2;
  int currentStep = 0;
  int cardType = 1;
  bool _animationPlayed = false;

  bool checkStep0 = false;
  bool checkStep1 = false;

  void handleRadio(Object? e) => setState(() {
        cardType = e as int;
      });

  continueStep() {
    if (currentStep < 2) {
      setState(() {
        currentStep = currentStep + 1;
      });
    }
  }

  cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1;
      });
    }
  }

  nextStep0() {
    if (bookingController.bookingDays.isEmpty) {
      setState(() {
        checkStep0 = true;
      });
    } else {
      setState(() {
        checkStep0 = false;
      });
      continueStep();
    }
  }

  nextStep1() {
    // Remove any non-digit characters
    String sanitizedValue =
        bookingController.cardNumber.text.replaceAll(RegExp(r'\D'), '');

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
      continueStep();
    }
  }

  void nextStep2() async {
    ScaffoldMessenger.of(context).clearSnackBars();

    Future<void> addBookingFuture() async {
      bookingController.propertyId = widget.property.id;
      bookingController.userId = loginController.userDto?["id"];
      await bookingController.createBooking();

      Navigator.of(context).pop();

      SnackBar snackBar = const SnackBar(
        content: Text("Booking Done Successfully"),
        backgroundColor: Colors.blue,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    await addBookingFuture(); // await the Future
  }

  @override
  void initState() {
    bookingController.bookingDays.clear();

    // Initialize AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // Create a Tween for the animation
    _textAnimation1 = IntTween(
            begin: 0,
            end: "Now you can book the property according to the available days"
                .length)
        .animate(_animationController);

    _textAnimation2 = IntTween(
            begin: 0,
            end:
                "You can now confirm the previous steps, and later you can use your booking code to guarantee your booking when it comes"
                    .length)
        .animate(_animationController);

    // Start the animation
    _animationController.forward();

    loadData();

    _animationPlayed = false;
    bookingController.cardCCV.text = "";
    bookingController.cardDate.text = "";
    bookingController.cardName.text = "";
    bookingController.cardNumber.text = "";

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void loadData() async {
    await bookingController.getBookingDaysForProperty(widget.property.id);
    print(bookingController.preBookedDays);
    print(bookingController.bookingDays);

    setState(() {});
  }

  Future<void> _selectAvailableDates() async {
    DateTime currentDate = DateTime.now();
    DateTime tomorrow =
        DateTime(currentDate.year, currentDate.month, currentDate.day + 1);
    DateTime lastDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day + 32);

    DateTime? firstAvailableDate = findFirstAvailableDate(tomorrow, lastDate);

    if (firstAvailableDate == null) {
      // No available date found, show dialog
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
                constraints: const BoxConstraints(maxHeight: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "All days are booked",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        "All days from tomorrow through the month are booked",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ButtonBar(children: [
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
                    ]),
                  ],
                ),
              ),
            ),
          );
        },
      );
      return;
    }

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: firstAvailableDate,
      firstDate: tomorrow,
      lastDate: lastDate,
      selectableDayPredicate: (DateTime date) {
        // Prevent selection of dates in the bookingdays list
        if (bookingController.preBookedDays.contains(date)) {
          return false; // Date is booked, not selectable
        }

        return true; // Date is available and not in the bookingdays list, selectable
      },
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color.fromARGB(255, 196, 39, 27),
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child ?? Container(),
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        checkStep0 = false;
        if (!bookingController.bookingDays.contains(selectedDate)) {
          bookingController.bookingDays.add(selectedDate);
        }
      });
    }

    print(bookingController.bookingDays);
  }

  DateTime? findFirstAvailableDate(DateTime start, DateTime end) {
    DateTime currentDate = start;
    while (currentDate.isBefore(end)) {
      if (!bookingController.preBookedDays.contains(currentDate)) {
        return currentDate;
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return null; // No available date found
  }

  @override
  Widget build(BuildContext context) {
    if (currentStep == 2 && !_animationPlayed) {
      // Play the animation when entering Step 2 for the first time
      _animationController.reset();
      _animationController.forward();
      _animationPlayed = true;
    }

    return Scaffold(
      // App bar
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
        title: const Text(
          "Create Booking",
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Body
      body: Theme(
        data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.black)),
        child: ListView(
          children: [
            Stepper(
                physics: const NeverScrollableScrollPhysics(),
                currentStep: currentStep,
                // onStepContinue: continueStep,
                onStepCancel: cancelStep,
                controlsBuilder:
                    (BuildContext context, ControlsDetails controlsDetails) {
                  final isLastStep = currentStep == 2;
                  final isFistStep = currentStep == 0;
                  return Container(
                    margin: const EdgeInsets.only(top: 60),
                    child: Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            height: 35,
                            color: Colors.black,
                            onPressed: isFistStep
                                ? nextStep0
                                : isLastStep
                                    ? nextStep2
                                    : nextStep1,
                            child: Text(
                              isLastStep
                                  ? "CONFIRM"
                                  : isFistStep
                                      ? "NEXT"
                                      : "PAY",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isFistStep ? 16 : null,
                              ),
                            ),
                          ),
                        ),
                        isFistStep
                            ? const SizedBox(width: 0)
                            : const SizedBox(width: 12),
                        if (currentStep != 0)
                          Expanded(
                            child: MaterialButton(
                              height: 35,
                              color: Colors.grey,
                              onPressed: controlsDetails.onStepCancel,
                              child: const Text(
                                "BACK",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                steps: [
                  // Step 0
                  Step(
                    state: currentStep > 0
                        ? StepState.complete
                        : StepState.indexed,
                    isActive: currentStep >= 0,
                    title: const Text(
                      "Booking days",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    content: bookingDays(),
                  ),

                  // Step 1
                  Step(
                    state: currentStep > 1
                        ? StepState.complete
                        : StepState.indexed,
                    isActive: currentStep >= 1,
                    title: const Text(
                      "payment",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    content: payment(),
                  ),

                  // Step 2
                  Step(
                    isActive: currentStep >= 2,
                    title: const Text(
                      "Complete",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    content: complete(),
                  ),
                ])
          ],
        ),
      ),
    );
  }

  Widget bookingDays() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),

          // Introduction
          Container(
            child: AnimatedBuilder(
              animation: _textAnimation1,
              builder: (context, child) {
                String animatedText =
                    "Now you can book the property according to the available days"
                        .substring(0, _textAnimation1.value);
                return Text(
                  animatedText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),

          // Select Booking Days
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: checkStep0 ? Colors.red[500]! : Colors.black,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: InkWell(
              onTap: _selectAvailableDates,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Booking Days",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: checkStep0 ? Colors.red[500] : Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: _selectAvailableDates,
                    icon: Icon(
                      Icons.date_range_outlined,
                      color: checkStep0 ? Colors.red[500] : Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ),

          if (checkStep0)
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                "Select Booking Days is required",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.red[500],
                  fontSize: 15,
                ),
              ),
            ),

          const SizedBox(height: 20),

          // Booking Days
          if (bookingController.bookingDays.isNotEmpty)
            Column(
              children: [
                ...bookingController.bookingDays.map<Widget>((DateTime date) {
                  return ListTile(
                    title: Text(
                      DateFormat('MMM dd', 'en_US').format(date),
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Remove the date from the list
                        setState(() {
                          bookingController.bookingDays.remove(date);
                        });
                      },
                    ),
                  );
                }).toList(),

                // Price
                Divider(
                  height: 30,
                  color: Colors.grey[500],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price per night",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      "\$${widget.property.price}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total price",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      "\$${widget.property.price * bookingController.bookingDays.length}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.red[500],
                      ),
                    )
                  ],
                ),
              ],
            )
          else
            Text(
              "You have not booked any days yet, book your days now",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
        ],
      ),
    );
  }

  Widget payment() {
    Size size = MediaQuery.of(context).size;

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
            width: 74,
          );

        default:
          return Container();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          const SizedBox(height: 30),

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
                    : Border.all(width: 0.3, color: Colors.grey),
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
                              color: cardType == 1 ? Colors.black : Colors.grey,
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
                    : Border.all(width: 0.3, color: Colors.grey),
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
                              color: cardType == 2 ? Colors.black : Colors.grey,
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
                    : Border.all(width: 0.3, color: Colors.grey),
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
                              color: cardType == 3 ? Colors.black : Colors.grey,
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
                    : Border.all(width: 0.3, color: Colors.grey),
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
                              color: cardType == 4 ? Colors.black : Colors.grey,
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
        ],
      ),
    );
  }

  Widget complete() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),

          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
                alignment: Alignment.centerLeft,
                height: 130,
                width: 150,
                child: Image.asset("assets/images/red-tree.png")),
          ),

          // Introduction
          Container(
            alignment: Alignment.centerLeft,
            child: AnimatedBuilder(
              animation: _textAnimation2,
              builder: (context, child) {
                String animatedText =
                    "You can now confirm the previous steps, and later you can use your booking code to guarantee your booking when it comes"
                        .substring(0, _textAnimation2.value);
                return Text(
                  animatedText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                );
              },
            ),
          ),
        ],
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
