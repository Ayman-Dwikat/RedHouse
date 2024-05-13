import 'dart:async';
import 'package:client/controller/booking/booking_controller.dart';
import 'package:client/model/booking.dart';
import 'package:client/model/bookingDay.dart';
import 'package:client/view/home_information/booking_code.dart';
import 'package:client/view/history/check_account.dart';
import 'package:client/view/manage_properties/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  _MyBookingState createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> with TickerProviderStateMixin {
  late Booking booking;
  BookingController bookingController = Get.put(BookingController());
  Color primaryColor = const Color.fromARGB(255, 61, 59, 59);

  IconData? currentIcon;
  late Timer timer;

  double width = 0;
  AnimationController? _controllerWidget12;
  Animation<Offset>? _animationWidget12;
  AnimationController? _controllerWidget3;
  Animation<Offset>? _animationWidget3;
  AnimationController? _controllerWidget4;
  Animation<Offset>? _animationWidget4;

  @override
  void initState() {
    super.initState();
    loadData();

    // Status Icons
    if (booking.bookingStatus == "Paused") {
      currentIcon = FontAwesomeIcons.hourglassStart;
    } else if (booking.bookingStatus == "Done") {
      currentIcon = FontAwesomeIcons.circleCheck;
    } else {
      currentIcon = FontAwesomeIcons.calendarCheck;
    }
    startTimer();

    // Initialize a new controller
    _controllerWidget12 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationWidget12 = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controllerWidget12!,
        curve: Curves.easeInOut,
      ),
    );
    _controllerWidget12!.forward(); // Start animation

    // Initialize a new controller
    _controllerWidget3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationWidget3 = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controllerWidget3!,
        curve: Curves.easeInOut,
      ),
    );

    // Initialize a new controller
    _controllerWidget4 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animationWidget4 = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from the bottom
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controllerWidget4!,
        curve: Curves.easeInOut,
      ),
    );

    setState(() {});
  }

  @override
  void dispose() {
    _controllerWidget12!.dispose();
    _controllerWidget3!.dispose();
    _controllerWidget4!.dispose();
    timer.cancel();
    super.dispose();
  }

  void loadData() async {
    booking = Get.arguments as Booking;
  }

  String divideCodeIntoGroups(String code) {
    final RegExp pattern = RegExp(r".{1,3}");
    Iterable<Match> matches = pattern.allMatches(code);
    List<String> groups = matches.map((match) => match.group(0)!).toList();
    return groups.join(" ");
  }

  void startTimer() {
    const Duration duration1 = Duration(seconds: 1);
    const Duration duration2 = Duration(seconds: 2);

    if (booking.bookingStatus == "Paused") {
      timer = Timer.periodic(duration1, (Timer timer) {
        if (mounted) {
          setState(() {
            if (currentIcon == FontAwesomeIcons.hourglassStart) {
              currentIcon = FontAwesomeIcons.hourglassHalf;
            } else if (currentIcon == FontAwesomeIcons.hourglassHalf) {
              currentIcon = FontAwesomeIcons.hourglassEnd;
            } else {
              currentIcon = FontAwesomeIcons.hourglassStart;
            }
          });
        }
      });
    } else if (booking.bookingStatus == "Done") {
      timer = Timer.periodic(duration2, (Timer timer) {
        if (mounted) {
          setState(() {
            if (currentIcon == FontAwesomeIcons.circleCheck) {
              currentIcon = null;
            } else {
              currentIcon ??= FontAwesomeIcons.circleCheck;
            }
          });
        }
      });
    } else {
      timer = Timer.periodic(duration2, (Timer timer) {
        if (mounted) {
          setState(() {
            if (currentIcon == FontAwesomeIcons.calendarCheck) {
              currentIcon = null;
            } else {
              currentIcon ??= FontAwesomeIcons.calendarCheck;
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      // App bar
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        backgroundColor: primaryColor,
      ),

      // Body
      body: ListView(
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
              color: primaryColor,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 25,
                  left: 0,
                  child: Container(
                    height: 77,
                    width: 280,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "Your Booking              ",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 50),
          widget1(),
          widget2(),
          widget3(),
          const SizedBox(height: 20),
          widget4(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget widget1() {
    return SlideTransition(
      position: _animationWidget12!,
      child: SizedBox(
        height: 240,
        child: Stack(
          children: [
            Positioned(
              top: 35,
              left: 20,
              child: Material(
                child: Container(
                  height: 190,
                  width: width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        // color: const Color.fromARGB(255, 91, 89, 89).withOpacity(0.3),
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                        offset: const Offset(-10, 10),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 30,
              child: Card(
                elevation: 10,
                shadowColor: Colors.grey.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  height: 210,
                  width: 150,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          booking.bookingStatus,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Icon(
                            currentIcon,
                            key: currentIcon == null
                                ? null
                                : ValueKey<IconData>(currentIcon!),
                            size: 22,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 50,
                left: 195,
                child: SizedBox(
                  height: 150,
                  width: 170,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('yyyy-MM-dd').format(booking.bookingDate),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        "Landlord",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        (booking.property!.user!.name!.length <= 15)
                            ? booking.property!.user!.name!
                            : '${booking.property!.user!.name!.substring(0, 15)}...',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const Divider(color: Colors.grey),
                      const Text(
                        "Property Code",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        divideCodeIntoGroups(booking.property!.propertyCode),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget widget2() {
    return SlideTransition(
      position: _animationWidget12!,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 35, bottom: 35),
            constraints: BoxConstraints(
              minHeight: 100,
              maxHeight: constraints.maxHeight,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
              color: primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.bookingDays!.length == 1
                        ? "Booking Day"
                        : "Booking Days",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...booking.bookingDays!.map<Widget>((BookingDay days) {
                    bool isDayPassed = days.dayDate.isBefore(DateTime.now());
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          DateFormat('MMM dd', 'en_US').format(days.dayDate),
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                          maxLines: null,
                        ),
                        IconButton(
                          icon: isDayPassed
                              ? const Icon(
                                  FontAwesomeIcons.check,
                                  color: Colors.white,
                                  size: 22,
                                )
                              : const Icon(
                                  FontAwesomeIcons.question,
                                  color: Colors.white,
                                  size: 21,
                                ),
                          onPressed: () {},
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget widget3() {
    return VisibilityDetector(
      key: const Key('twoClicksVisibilityKey'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction == 1.0 && !_controllerWidget3!.isAnimating) {
          _controllerWidget3!.forward();
        }
      },
      child: SlideTransition(
        position: _animationWidget3!,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => HomeWidget(property: booking.property!));
              },
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  "Click here to see property",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
            Container(height: 10),
            InkWell(
              onTap: () {
                Get.to(() => CheckAccount(user: booking.property!.user!));
              },
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  "Click here to see landlord history",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widget4() {
    return VisibilityDetector(
      key: const Key('buttonVisibilityKey'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction == 1.0 && !_controllerWidget4!.isAnimating) {
          _controllerWidget4!.forward();
        }
      },
      child: SlideTransition(
        position: _animationWidget4!,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              if (booking.bookingStatus == "Done")
                deleteBooking()
              else if (booking.bookingStatus == "InProcess")
                seeCode(),
            ],
          ),
        ),
      ),
    );
  }

  Widget seeCode() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          Get.to(() => BookingCode(bookingCode: booking.bookingCode));
        },
        style: ElevatedButton.styleFrom(
          primary: const Color.fromARGB(255, 33, 74, 108),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.eye,
              size: 18,
            ),
            SizedBox(width: 10),
            Text(
              "See Code",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteBooking() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          bookingController.deleteBooking(booking.id);
          setState(() {});
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          primary: const Color.fromARGB(255, 33, 74, 108),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.trash,
              size: 16,
            ),
            SizedBox(width: 10),
            Text(
              "Delete Booking",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
