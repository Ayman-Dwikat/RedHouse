import 'package:client/controller/bottom_bar/filter_controller.dart';
import 'package:client/view/bottom_bar/bottom_bar.dart';
import 'package:client/view/filter/filter_elements.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FilterPage extends StatefulWidget {
  FilterPage({Key? key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage>
    with AutomaticKeepAliveClientMixin {
  FilterController controller = Get.put(FilterController(), permanent: true);

  @override
  bool get wantKeepAlive => true; // Keep the state alive

  @override
  void initState() {
    super.initState();

    // Property type
    controller.houseTemp = controller.house;
    controller.apartmentTemp = controller.apartment;
    controller.townhouseTemp = controller.townhouse;
    controller.castleTemp = controller.castle;
    controller.departmentTemp = controller.department;
    // Price
    controller.maxControllerTemp.text = controller.maxController.text;
    controller.minControllerTemp.text = controller.minController.text;
    // Property view
    controller.viewTemp = controller.view;
    // Bed Bath
    controller.copyBathButtonTemp();
    controller.copyBedButtonTemp();
    // Listing by
    controller.listingByTemp = controller.listingBy;
    // Property size
    controller.sizeMaxTemp.text = controller.sizeMax.text;
    controller.sizeMinTemp.text = controller.sizeMin.text;
    // Rent type
    controller.rentTypeTemp = controller.rentType;
    // Property status
    controller.comingSoonTemp = controller.comingSoon;
    controller.acceptingOffersTemp = controller.acceptingOffers;
    controller.underContractTemp = controller.underContract;
    // Parking spots
    controller.parkingSpotsTemp.text = controller.parkingSpots.text;
    // Basement
    controller.basementTemp = controller.basement;
    // Year built
    controller.yearBuiltMaxTemp.text = controller.yearBuiltMax.text;
    controller.yearBuiltMinTemp.text = controller.yearBuiltMin.text;
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
      length: 2,
      initialIndex: controller.listingType ? 0 : 1,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  'Filters',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(() {
                    controller.houseTemp = true;
                    controller.apartmentTemp = true;
                    controller.townhouseTemp = true;
                    controller.castleTemp = true;
                    controller.department = true;
                    controller.maxControllerTemp.text = "";
                    controller.minControllerTemp.text = "";
                    controller.viewTemp = "Any";
                    controller.setBedButtonTemp("Any");
                    controller.setBathButtonTemp("Any");
                    controller.listingByTemp = "Any";
                    controller.sizeMaxTemp.text = "";
                    controller.sizeMinTemp.text = "";
                    controller.parkingSpotsTemp.text = "";
                    controller.yearBuiltMaxTemp.text = "";
                    controller.yearBuiltMinTemp.text = "";
                    controller.basementTemp = true;
                    controller.comingSoonTemp = true;
                    controller.acceptingOffersTemp = true;
                    controller.underContractTemp = true;
                    controller.rentTypeTemp = "All";
                  });
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 17.5,
                  ),
                ),
              ),
            ],
          ),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Buy'),
              Tab(text: 'Rent'),
            ],
            overlayColor: MaterialStatePropertyAll(Colors.grey[700]),
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
            unselectedLabelColor: Colors.grey[400],
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // For Buy
            VisibilityDetector(
              key: const Key("BuyFilter"),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 1) {
                  controller.tabType = true;
                }
              },
              child: FutureBuilder(
                future: Future.delayed(const Duration(seconds: 1)),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey[200],
                      ),
                    );
                  } else {
                    return const FilterElements();
                  }
                },
              ),
            ),

            // For Rent
            VisibilityDetector(
              key: const Key("RentFilter"),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 1) {
                  controller.tabType = false;
                }
              },
              child: FutureBuilder(
                future: Future.delayed(const Duration(seconds: 1)),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey[200],
                      ),
                    );
                  } else {
                    return const FilterElements();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
