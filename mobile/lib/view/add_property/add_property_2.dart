import 'package:client/model/neighborhood/locationNeighborhood.dart';
import 'package:client/model/neighborhood/neighborhoodDto.dart';
import 'package:client/view/add_property/add_property_3.dart';
import 'package:client/controller/propertise/properties_controller.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddPropertyNeighbour extends StatefulWidget {
  AddPropertyNeighbour({Key? key}) : super(key: key);

  @override
  _AddPropertyNeighbourState createState() => _AddPropertyNeighbourState();
}

class _AddPropertyNeighbourState extends State<AddPropertyNeighbour>
    with SingleTickerProviderStateMixin {
  String neighborhoodType = "Select Neighborhood Type";

  ManagePropertiesController propertyController =
      Get.put(ManagePropertiesController());

  late AnimationController _animationController;
  late Animation<int> _textAnimation;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  // Give icon for each neighborhood
  void addCustomerIcon() {
    if (neighborhoodType == "Parking") {
      BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), "assets/images/parking.png")
          .then(
        (icon) {
          setState(() {
            markerIcon = icon;
          });
        },
      );
    } else if (neighborhoodType == "School") {
      BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), "assets/images/school.png")
          .then(
        (icon) {
          setState(() {
            markerIcon = icon;
          });
        },
      );
    } else if (neighborhoodType == "Hospital") {
      BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), "assets/images/hospital.png")
          .then(
        (icon) {
          setState(() {
            markerIcon = icon;
          });
        },
      );
    } else if (neighborhoodType == "Mosque") {
      BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), "assets/images/mosque.png")
          .then(
        (icon) {
          setState(() {
            markerIcon = icon;
          });
        },
      );
    } else if (neighborhoodType == "Gymnasium") {
      BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), "assets/images/gym.png")
          .then(
        (icon) {
          setState(() {
            markerIcon = icon;
          });
        },
      );
    } else if (neighborhoodType == "Gas Station") {
      BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), "assets/images/gas-station.png")
          .then(
        (icon) {
          setState(() {
            markerIcon = icon;
          });
        },
      );
    } else if (neighborhoodType == "ATM") {
      BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), "assets/images/atm.png")
          .then(
        (icon) {
          setState(() {
            markerIcon = icon;
          });
        },
      );
    }
  }

  @override
  void initState() {
    print(propertyController.markers);

    // Initialize AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // Create a Tween for the animation
    _textAnimation =
        IntTween(begin: 0, end: "Locate property neighborhoods".length)
            .animate(_animationController);

    // Start the animation
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const options = [
      "Select Neighborhood Type",
      "Park",
      "School",
      "Hospital",
      "Mosque",
      "Gymnasium",
      "Gas Station",
      "ATM",
    ];

    return GetBuilder<ManagePropertiesController>(
      init: ManagePropertiesController(),
      builder: (ManagePropertiesController controller) {
        return Scaffold(
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
                    onPressed: () {
                      setState(() {
                        controller.increaseActiveStep();
                        print(controller.activeStep);
                      });
                      Get.to(() => AddProperty2());
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
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
                          String animatedText = "Locate property neighborhoods"
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

              // Googel Map
              Container(
                height: 320,
                child: Visibility(
                  visible: true,
                  child: controller.currentPosition == null
                      ? Container(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        )
                      : Expanded(
                          child: GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition: controller.currentPosition!,
                            onMapCreated: (mapcontroller) {
                              controller.mapController2 = mapcontroller;
                            },
                            markers: controller.markers,
                            onTap: (latlng) async {
                              print(controller.markers);
                              print(controller.propertyNeighborhoods);
                              print(neighborhoodType);

                              if (neighborhoodType !=
                                  "Select Neighborhood Type") {
                                try {
                                  List<Placemark> placemarks =
                                      await placemarkFromCoordinates(
                                          latlng.latitude, latlng.longitude);

                                  if (placemarks.isNotEmpty) {
                                    final placemark = placemarks[0];
                                    controller.neighborhoodStreet.text =
                                        placemark.street!;

                                    // Remove the marker with the specified ID
                                    controller.markers.removeWhere(
                                      (marker) =>
                                          marker.markerId.value ==
                                          neighborhoodType,
                                    );
                                    // Remove the neighborhood with the neighborhood type
                                    controller.propertyNeighborhoods
                                        .removeWhere(
                                      (neighborhood) =>
                                          neighborhood.neighborhoodType ==
                                          neighborhoodType,
                                    );

                                    // Add a new marker
                                    controller.markers.add(
                                      Marker(
                                        markerId: MarkerId(neighborhoodType),
                                        position: latlng,
                                        infoWindow:
                                            InfoWindow(title: neighborhoodType),
                                        icon: markerIcon,
                                      ),
                                    );
                                    // Add a new neighborhood
                                    controller.propertyNeighborhoods
                                        .add(NeighborhoodDto(
                                      neighborhoodType: neighborhoodType,
                                      location: LocationNeighborhood(
                                        city: placemark.locality,
                                        postalCode: placemark.postalCode!,
                                        country: placemark.country,
                                        region: placemark.locality,
                                        streetAddress: placemark.street,
                                        latitude: latlng.latitude,
                                        longitude: latlng.longitude,
                                      ),
                                    ));
                                  }
                                } catch (e) {
                                  Get.defaultDialog(
                                      title: "ُEntered invalid location",
                                      middleText: 'Error: $e');
                                }
                                print(controller.markers);
                                print(controller.propertyNeighborhoods);
                                setState(() {});
                              }
                            },
                          ),
                        ),
                ),
              ),

              // Street address and Dropdown Button
              Container(
                margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
                child: Form(
                  key: controller.formKey2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          value: neighborhoodType,
                          items: options.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                neighborhoodType = newValue;
                                addCustomerIcon();
                              });
                            }
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),
                      ),
                      const SizedBox(height: 15),
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
                          controller: controller.neighborhoodStreet,
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
