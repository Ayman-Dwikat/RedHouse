import 'dart:async';
import 'package:client/controller/contract/contracts_controller.dart';
import 'package:client/controller/contract/offer_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/offer.dart';
import 'package:client/model/user.dart';
import 'package:client/view/contracts/customer%20contract/customer_contract.dart';
import 'package:client/view/contracts/landlord%20contract/landlord_contract.dart';
import 'package:client/view/history/check_account.dart';
import 'package:client/view/manage_properties/home_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SentOffer extends StatefulWidget {
  final Offer offer;
  const SentOffer({Key? key, required this.offer}) : super(key: key);
  @override
  _SentOfferState createState() => _SentOfferState();
}

class _SentOfferState extends State<SentOffer> with TickerProviderStateMixin {
  OfferController controller = Get.put(OfferController());
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  ContractsController contractsController = Get.put(ContractsController());
  Color primaryColor = const Color.fromARGB(255, 122, 104, 214);

  late String userType;
  late User userName;

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
    getName();

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
    await contractsController.getContractForOffer(
      widget.offer.id,
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

  void getName() {
    if (widget.offer.landlordId != widget.offer.userCreatedId) {
      userName = widget.offer.landlord!;
      userType = "Landlord";
    } else {
      userName = widget.offer.customer!;
      userType = "Customer";
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      // App bar
      appBar: AppBar(
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
                        "Your Offer                   ",
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
                        // color: Colors.grey.withOpacity(0.4),
                        color: const Color.fromARGB(255, 94, 66, 231)
                            .withOpacity(0.4),
                        // color: Colors.grey.withOpacity(0.4),
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
                    //  color: Color.fromARGB(255, 94, 66, 231),
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.offer.offerStatus,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        if (widget.offer.offerStatus == "Pending")
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
                      DateFormat('yyyy-MM-dd').format(widget.offer.offerDate),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      userType,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      (userName.name!.length <= 15)
                          ? userName.name!
                          : '${userName.name!.substring(0, 15)}...',
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
                      divideCodeIntoGroups(widget.offer.property!.propertyCode),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
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
                  // Price
                  if (widget.offer.price != 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Offer Price",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.offer.price.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black45,
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
                  if (widget.offer.description.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          widget.offer.description,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black45,
                          ),
                          maxLines: null,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    )
                  else
                    const Text(
                      "There is no description",
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
                Get.to(() => HomeWidget(property: widget.offer.property!));
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
                userType == "Customer"
                    ? Get.to(() => CheckAccount(user: widget.offer.customer!))
                    : Get.to(() => CheckAccount(user: widget.offer.landlord!));
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
                  userType == "Customer"
                      ? "Click here to see customer history"
                      : "Click here to see landlord history",
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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(height: 30),
              // Show "Delete Offer"
              if (widget.offer.offerStatus == "Pending")
                deleteButton()
              // Show "See Contract"
              else
                contractButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget deleteButton() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          controller.deleteOffer(widget.offer.id);
          setState(() {});
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          primary: const Color.fromARGB(185, 0, 0, 0),
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
              "Delete Offer",
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

  Widget contractButton() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          contractsController.visitLawyerFromContract = true;
          contractsController.currentContract =
              contractsController.contractIsCreated!;
          if (widget.offer.landlordId == loginController.userDto?["id"]) {
            Get.to(() => LandlordContract(
                contract: contractsController.contractIsCreated!));
          } else {
            contractsController.visitLawyerFromContract = true;
            contractsController.currentContract =
                contractsController.contractIsCreated!;
            Get.to(() => CustomerContract(
                contract: contractsController.contractIsCreated!));
          }
        },
        style: ElevatedButton.styleFrom(
          primary: const Color.fromARGB(185, 0, 0, 0),
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
              "See Contract",
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
