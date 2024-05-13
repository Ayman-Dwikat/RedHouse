import 'package:client/controller/contract/offer_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/offer.dart';
import 'package:client/view/card/credit_card.dart';
import 'package:client/view/manage_properties/offers/incoming_offer.dart';
import 'package:client/view/card/style/card_background.dart';
import 'package:client/view/manage_properties/offers/sent_offer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AllOffers extends StatefulWidget {
  const AllOffers({Key? key});

  @override
  _AllOffersState createState() => _AllOffersState();
}

class _AllOffersState extends State<AllOffers>
    with AutomaticKeepAliveClientMixin {
  OfferController controller = Get.put(OfferController());
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
    await controller.getAllOffersForUser(loginController.userDto?["id"]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    const offerStatus = [
      "All",
      "Pending",
      "Accepted",
    ];

    const offerType = [
      "All",
      "For monthly rent",
      "For sell",
    ];

    return VisibilityDetector(
      key: const Key('allOffers'),
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
                  hintText: "Search by offer, customer, landlord name",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 180,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButton<String>(
                    alignment: Alignment.centerLeft,
                    isExpanded: true,
                    value: controller.offerStatusSelect,
                    onChanged: (String? newValue) {
                      setState(() {
                        controller.offerStatusSelect = newValue!;
                        loadData();
                      });
                    },
                    items: offerStatus.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DropdownButton<String>(
                    alignment: Alignment.centerLeft,
                    isExpanded: true,
                    value: controller.offerTypeSelect,
                    onChanged: (String? newValue) {
                      setState(() {
                        controller.offerTypeSelect = newValue!;
                        loadData();
                      });
                    },
                    items: offerType.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
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
                      Tab(text: 'Incoming Offers'),
                      Tab(text: 'Sent Offers'),
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
                      // Content for 'Incoming Offers' tab
                      VisibilityDetector(
                        key: const Key("IncomingOffers"),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 1) {
                            controller.offerToSelect = "Incoming";
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
                              return contentIncomingOffers();
                            }
                          },
                        ),
                      ),

                      // Content for 'Sent Offers' tab
                      VisibilityDetector(
                        key: const Key("SentOffers"),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 1) {
                            controller.offerToSelect = "Sent";
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
                              return contentSentOffers();
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

  Widget contentIncomingOffers() {
    if (controller.userOffers.isEmpty) {
      return const Center(
        child: Text(
          "No any incoming offer",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: controller.userOffers.length,
          itemBuilder: (context, index) {
            Offer offer = controller.userOffers[index];
            EdgeInsets _margin;

            if (index == controller.userOffers.length - 1) {
              _margin = const EdgeInsets.symmetric(vertical: 30);
            } else {
              _margin = const EdgeInsets.only(top: 30);
            }

            String getName() {
              if (offer.landlordId == offer.userCreatedId) {
                return offer.landlord!.name!;
              } else {
                return offer.customer!.name!;
              }
            }

            return GestureDetector(
              onTap: () {
                Get.to(() => IncomingOffer(offer: offer));
                setState(() {});
              },
              child: Container(
                margin: _margin,
                child: CreditCard(
                  type: "offer",
                  offer: offer,
                  index: index,
                  name: getName(),
                  showBackSide: true,
                  frontBackground: CardBackgrounds.black,
                  backBackground: CardBackgrounds.white,
                  showShadow: true,
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget contentSentOffers() {
    if (controller.userOffers.isEmpty) {
      return const Center(
        child: Text(
          "No any sent offer",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: controller.userOffers.length,
          itemBuilder: (context, index) {
            Offer offer = controller.userOffers[index];
            EdgeInsets _margin;

            if (index == controller.userOffers.length - 1) {
              _margin = const EdgeInsets.symmetric(vertical: 30);
            } else {
              _margin = const EdgeInsets.only(top: 30);
            }

            String getName() {
              if (offer.landlordId != offer.userCreatedId) {
                return offer.landlord!.name!;
              } else {
                return offer.customer!.name!;
              }
            }

            return GestureDetector(
              onTap: () {
                Get.to(() => SentOffer(offer: offer));
                setState(() {});
              },
              child: Container(
                margin: _margin,
                child: CreditCard(
                  type: "offer",
                  offer: offer,
                  index: index,
                  name: getName(),
                  showBackSide: true,
                  frontBackground: CardBackgrounds.black,
                  backBackground: CardBackgrounds.white,
                  showShadow: true,
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
