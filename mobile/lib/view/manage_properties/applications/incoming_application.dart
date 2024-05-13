import 'package:client/controller/application/applications_controller.dart';
import 'package:client/controller/contract/offer_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/application.dart';
import 'package:client/view/history/check_account.dart';
import 'package:client/view/manage_properties/home_widget.dart';
import 'package:client/view/manage_properties/offers/create_offer.dart';
import 'package:client/view/manage_properties/offers/incoming_offer.dart';
import 'package:client/view/manage_properties/offers/sent_offer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:visibility_detector/visibility_detector.dart';

class IncomingApplication extends StatefulWidget {
  const IncomingApplication({super.key});

  @override
  _IncomingApplicationState createState() => _IncomingApplicationState();
}

class _IncomingApplicationState extends State<IncomingApplication>
    with TickerProviderStateMixin {
  late Application application;
  ApplicationsController controller = Get.put(ApplicationsController());
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  OfferController offerController = Get.put(OfferController());

  IconData? iconPending;
  IconData? iconApproved;
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
    iconPending = FontAwesomeIcons.hourglassStart;
    iconApproved = FontAwesomeIcons.circleCheck;
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
    application = Get.arguments as Application;
    await offerController.getOfferForApplication(
      application.propertyId,
      application.property.userId,
      application.userId,
    );
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

    timer = Timer.periodic(duration1, (Timer timer) {
      if (mounted) {
        setState(() {
          if (iconPending == FontAwesomeIcons.hourglassStart) {
            iconPending = FontAwesomeIcons.hourglassHalf;
          } else if (iconPending == FontAwesomeIcons.hourglassHalf) {
            iconPending = FontAwesomeIcons.hourglassEnd;
          } else {
            iconPending = FontAwesomeIcons.hourglassStart;
          }
        });
      }
    });

    timer = Timer.periodic(duration2, (Timer timer) {
      if (mounted) {
        setState(() {
          if (iconApproved == FontAwesomeIcons.circleCheck) {
            iconApproved = null;
          } else {
            iconApproved ??= FontAwesomeIcons.circleCheck;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      // App bar
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 77, 138),
      ),

      // Body
      body: ListView(
        children: [
          Container(
            height: 160,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
              color: Color.fromARGB(255, 23, 77, 138),
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
                    child: const Center(
                      child: Text(
                        "Your Application         ",
                        style: TextStyle(
                          color: Color.fromARGB(255, 23, 77, 138),
                          fontSize: 22,
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
                    color: const Color.fromARGB(255, 23, 77, 138),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          application.applicationStatus,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        if (application.applicationStatus == "Pending")
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Icon(
                              iconPending,
                              key: iconPending == null
                                  ? null
                                  : ValueKey<IconData>(iconPending!),
                              size: 22,
                              color: Colors.white,
                            ),
                          )
                        else
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: Icon(
                              iconApproved,
                              key: iconApproved == null
                                  ? null
                                  : ValueKey<IconData>(iconApproved!),
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
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
                        DateFormat('yyyy-MM-dd')
                            .format(application.applicationDate),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Color.fromARGB(255, 23, 77, 138),
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        "Customer",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        (application.user.name!.length <= 15)
                            ? application.user.name!
                            : '${application.user.name!.substring(0, 15)}...',
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
                        divideCodeIntoGroups(application.property.propertyCode),
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
                const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 30),
            constraints: BoxConstraints(
              minHeight: 160,
              maxHeight: constraints.maxHeight,
            ),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(50),
              ),
              color: Color.fromARGB(255, 23, 77, 138),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price
                  if (application.suggestedPrice != 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Suggested Price",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          application.suggestedPrice!.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  else
                    const Text(
                      "There is no suggested price",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),

                  // Messgae
                  const SizedBox(height: 35),
                  if (application.message.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Message",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          application.message,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          maxLines: null,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    )
                  else
                    const Text(
                      "There is no message",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
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
                Get.to(() => HomeWidget(property: application.property));
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
                child: const Text(
                  "Click here to see property",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 23, 77, 138),
                  ),
                ),
              ),
            ),
            Container(height: 10),
            InkWell(
              onTap: () {
                Get.to(() => CheckAccount(user: application.user));
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
                child: const Text(
                  "Click here to see customer history",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 23, 77, 138),
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 30),
              // Show "Approve" "Ignore"
              if (application.applicationStatus == "Pending")
                approveIgnoreButton(),

              if (application.applicationStatus == "Approved")
                if (application.property.listingType == "For daily rent")
                  // Show "Stop Booking"
                  bookingButton()
                else
                  // Show "Create Offer" or "See Offer"
                  offerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget approveIgnoreButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 40,
          width: 168,
          child: ElevatedButton(
            onPressed: () {
              controller.approvedApplication(application.id);
              application.applicationStatus = "Approved";
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Approve",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Container(
          height: 40,
          width: 168,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: ElevatedButton(
            onPressed: () {
              controller.deleteApplication(application.id);
              setState(() {});
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Ignore",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget offerButton() {
    if (offerController.responseMessage == "Created") {
      return SizedBox(
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            if (offerController.offerIsCreated!.userCreatedId ==
                loginController.userDto?["id"]) {
              Get.to(() => SentOffer(offer: offerController.offerIsCreated!));
            } else {
              Get.to(
                  () => IncomingOffer(offer: offerController.offerIsCreated!));
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
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
                size: 17,
              ),
              SizedBox(width: 10),
              Text(
                "See Offer",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            Get.to(
              () => CreateOffer(
                landlordId: application.property.userId,
                customerId: application.userId,
                property: application.property,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                FontAwesomeIcons.add,
                size: 17,
              ),
              SizedBox(width: 10),
              Text(
                "Create Offer",
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

  Widget bookingButton() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () async {
          await controller.updateApplicationStatus(application.id, "Pending");
          application.applicationStatus = "Pending";
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.solidHand,
              size: 17,
            ),
            SizedBox(width: 10),
            Text(
              "Stop Booking",
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
