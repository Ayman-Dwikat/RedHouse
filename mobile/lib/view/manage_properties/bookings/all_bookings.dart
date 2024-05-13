import 'package:client/controller/booking/booking_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/booking.dart';
import 'package:client/view/manage_properties/bookings/incoming_booking.dart';
import 'package:client/view/card/credit_card.dart';
import 'package:client/view/card/style/card_background.dart';
import 'package:client/view/manage_properties/bookings/my_booking.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AllBookings extends StatefulWidget {
  const AllBookings({Key? key});

  @override
  _AllBookingsState createState() => _AllBookingsState();
}

class _AllBookingsState extends State<AllBookings>
    with AutomaticKeepAliveClientMixin {
  BookingController bookingController =
      Get.put(BookingController(), permanent: true);
  LoginControllerImp loginController = Get.put(LoginControllerImp());

  @override
  bool get wantKeepAlive => true; // Keep the state alive

  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {});
  }

  void loadData() async {
    await bookingController.getBookingsForUser(loginController.userDto?["id"]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    const applicationStatus = [
      "All",
      "Paused",
      "InProcess",
      "Done",
    ];

    return VisibilityDetector(
      key: const Key('allBookings'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          loadData();
          setState(() {});
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            // Search
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                style: const TextStyle(height: 1.2),
                decoration: InputDecoration(
                  hintText: "Search by book, customer, landlord name",
                  suffixIcon: const Icon(Icons.search),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: const EdgeInsets.all(10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

            // Filters
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DropdownButton<String>(
                alignment: Alignment.centerLeft,
                isExpanded: true,
                value: bookingController.bookingStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    bookingController.bookingStatus = newValue!;
                    loadData();
                  });
                },
                items: applicationStatus.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
            ),

            // TabBar
            const SizedBox(height: 10),
            Expanded(
              child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Scaffold(
                  appBar: TabBar(
                    tabs: const [
                      Tab(text: 'My Bookings'),
                      Tab(text: 'Incoming Bookings'),
                    ],
                    overlayColor: MaterialStatePropertyAll(Colors.grey[350]),
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.5,
                    ),
                    unselectedLabelColor: Colors.grey[700],
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.5,
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      // My Bookings
                      VisibilityDetector(
                        key: const Key("MyBookings"),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 1) {
                            bookingController.bookingTo = "Customer";
                            loadData();
                            setState(() {});
                          }
                        },
                        child: FutureBuilder(
                          future: Future.delayed(const Duration(seconds: 1)),
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey[200],
                                ),
                              );
                            } else {
                              return contentMyBookings();
                            }
                          },
                        ),
                      ),

                      // Incoming Bookings
                      VisibilityDetector(
                        key: const Key("IncomingBookings"),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 1) {
                            bookingController.bookingTo = "Landlord";
                            loadData();
                            setState(() {});
                          }
                        },
                        child: FutureBuilder(
                          future: Future.delayed(const Duration(seconds: 1)),
                          builder: (BuildContext context,
                              AsyncSnapshot<void> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey[200],
                                ),
                              );
                            } else {
                              return contentIncomingBookings();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contentMyBookings() {
    if (bookingController.userBookings.isEmpty) {
      return const Center(
        child: Text(
          "No any booking for you",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: bookingController.userBookings.length,
          itemBuilder: (context, index) {
            Booking booking = bookingController.userBookings[index];

            EdgeInsets _margin;

            if (index == bookingController.userBookings.length - 1) {
              _margin = const EdgeInsets.symmetric(vertical: 30);
            } else {
              _margin = const EdgeInsets.only(top: 30);
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  Get.to(const MyBooking(), arguments: booking);
                });
              },
              child: Container(
                margin: _margin,
                child: CreditCard(
                  type: "booking",
                  booking: booking,
                  index: index,
                  name: booking.property!.user!.name!,
                  showBackSide: true,
                  frontBackground: CardBackgrounds.black,
                  backBackground: CardBackgrounds.white,
                  showShadow: true,
                  height: 175,
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget contentIncomingBookings() {
    if (bookingController.userBookings.isEmpty) {
      return const Center(
        child: Text(
          "No any incoming booking",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: bookingController.userBookings.length,
          itemBuilder: (context, index) {
            Booking booking = bookingController.userBookings[index];

            EdgeInsets _margin;

            if (index == bookingController.userBookings.length - 1) {
              _margin = const EdgeInsets.symmetric(vertical: 30);
            } else {
              _margin = const EdgeInsets.only(top: 30);
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  Get.to(const IncomingBooking(), arguments: booking);
                });
              },
              child: Container(
                margin: _margin,
                child: CreditCard(
                  type: "booking",
                  booking: booking,
                  index: index,
                  name: booking.user!.name!,
                  showBackSide: true,
                  frontBackground: CardBackgrounds.black,
                  backBackground: CardBackgrounds.white,
                  showShadow: true,
                  height: 175,
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
