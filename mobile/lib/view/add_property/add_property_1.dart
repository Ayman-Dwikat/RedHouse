import 'dart:async';
import 'package:client/controller/propertise/properties_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/view/add_property/add_property_2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddProperty1 extends StatefulWidget {
  AddProperty1({Key? key}) : super(key: key);

  @override
  _AddProperty1State createState() => _AddProperty1State();
}

class _AddProperty1State extends State<AddProperty1>
    with SingleTickerProviderStateMixin {
  ManagePropertiesController controller =
      Get.put(ManagePropertiesController(), permanent: true);
  LoginControllerImp loginController = Get.put(LoginControllerImp());

  late AnimationController _animationController;
  late Animation<int> _textAnimation;
  bool arePlacemarksAvailable = false;

  Future<void> getLatAndLong() async {
    Position cl = await Geolocator.getCurrentPosition().then((value) => value);
    double lat = cl.latitude;
    double long = cl.longitude;
    controller.currentPosition =
        CameraPosition(target: LatLng(lat, long), zoom: 15);
  }

  @override
  void initState() {
    // Clear all previous values
    setState(() {
      controller.markers = {};
      controller.activeStep = 1;
      controller.price.text = '';
      controller.numberOfBedrooms.text = '';
      controller.numberOfBathrooms.text = '';
      controller.squareMeter.text = '';
      controller.propertyDescription.text = '';
      controller.builtYear = DateTime.now();
      controller.availableDate = DateTime.now();
      controller.propertyStatus = "Coming soon";
      controller.numberOfUnits.text = '';
      controller.parkingSpots.text = '';
      controller.listingType = "For sell";
      controller.isAvaliableBasement = "Yes";
      controller.streetAddress.text = "";
      controller.downloadUrls = [];
      controller.neighborhoodStreet.text = "";
      controller.propertyNeighborhoods = [];
    });

    getLatAndLong();

    // Initialize AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // Create a Tween for the animation
    _textAnimation =
        IntTween(begin: 0, end: "Locate your property location".length)
            .animate(_animationController);

    // Start the animation
    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    getLatAndLong();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ManagePropertiesController>(
      init: ManagePropertiesController(),
      builder: (ManagePropertiesController controller) {
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
                  controller.decreaseActiveStep();
                  print(controller.activeStep);
                  Navigator.pop(context);
                });
              },
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Text(
              "Add Property",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    onPressed: arePlacemarksAvailable
                        ? () {
                            setState(() {
                              controller.increaseActiveStep();
                              print(controller.activeStep);
                              controller.userId =
                                  loginController.userDto?["id"];
                              Get.to(() => AddPropertyNeighbour());
                            });
                          }
                        : () {},
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: arePlacemarksAvailable
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Body
          body: ListView(
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling
            children: [
              controller.easyStepper(),

              // Introduction
              Container(
                margin: const EdgeInsets.only(right: 15, left: 15, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset("assets/images/logo.png", scale: 11),
                    Container(
                      child: AnimatedBuilder(
                        animation: _textAnimation,
                        builder: (context, child) {
                          String animatedText =
                              "Locate your property location"
                                  .substring(0, _textAnimation.value);
                          return Text(
                            animatedText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Google Map
              Container(
                height: 387,
                child: Visibility(
                  visible: true,
                  child: controller.currentPosition == null
                      ? Container(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator())
                      : Expanded(
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: controller.currentPosition!,
                            onCameraMove: (position) {
                              controller.currentPosition = CameraPosition(
                                  target: LatLng(position.target.latitude,
                                      position.target.longitude),
                                  zoom: position.zoom);
                            },
                            onMapCreated: (mapcontroller) {
                              getLatAndLong();
                              controller.mapController1 = mapcontroller;
                            },
                            markers: controller.markers
                                .where((marker) => marker.markerId.value == "1")
                                .toSet(),
                            onTap: (latlng) async {
                              try {
                                List<Placemark> placemarks =
                                    await placemarkFromCoordinates(
                                  latlng.latitude,
                                  latlng.longitude,
                                );
                                final placemark = placemarks[0];
                                print(
                                    "placemark ============================================================================");
                                print(placemark);

                                if (placemarks.isNotEmpty &&
                                    placemark.locality!.isNotEmpty &&
                                    placemark.country!.isNotEmpty &&
                                    placemark.street!.isNotEmpty) {
                                  controller.City = placemark.locality;
                                  controller.PostalCode = placemark.postalCode!;
                                  controller.streetAddress.text =
                                      placemark.street!;
                                  controller.Country = placemark.country;
                                  controller.Region = placemark.locality;
                                  controller.Latitude = latlng.latitude;
                                  controller.Longitude = latlng.longitude;

                                  // Remove the marker with the specified ID
                                  controller.markers.removeWhere(
                                    (marker) => marker.markerId.value == "1",
                                  );

                                  // Add a new marker with ID "1"
                                  controller.markers.add(
                                    Marker(
                                      markerId: const MarkerId("1"),
                                      position: latlng,
                                    ),
                                  );

                                  arePlacemarksAvailable = true;
                                }
                              } catch (e) {
                                Get.defaultDialog(
                                    title: "ُEntered invalid location",
                                    middleText: 'Error: $e');
                              }
                              setState(() {});
                            },
                          ),
                        ),
                ),
              ),

              // Street address
              Container(
                margin: const EdgeInsets.only(
                    top: 15, right: 15, left: 15, bottom: 25),
                child: Form(
                  key: controller.formKey1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: const Text(
                          "Street address",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: controller.streetAddress,
                          readOnly: true,
                          enabled: false,
                          style: const TextStyle(color: Colors.black54),
                          decoration: const InputDecoration(
                            hintText: "Here will appear Street address",
                            hintStyle: TextStyle(color: Colors.black54),
                            suffixIcon: Icon(
                              Icons.map,
                              color: Colors.black54,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
