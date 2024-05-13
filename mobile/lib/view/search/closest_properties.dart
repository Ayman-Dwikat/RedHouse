// ignore_for_file: sized_box_for_whitespace

import 'dart:async';
import 'package:client/controller/bottom_bar/filter_controller.dart';
import 'package:client/controller/propertise/properties_controller.dart';
import 'package:client/controller/static_api/static_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/property.dart';
import 'package:client/view/bottom_bar/bottom_bar.dart';
import 'package:client/view/home_information/home_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ClosestProperties extends StatefulWidget {
  const ClosestProperties({Key? key}) : super(key: key);

  @override
  _ClosestPropertiesState createState() => _ClosestPropertiesState();
}

class _ClosestPropertiesState extends State<ClosestProperties>
    with SingleTickerProviderStateMixin {
  ManagePropertiesController propertiesController =
      Get.put(ManagePropertiesController());
  FilterController filterController = Get.put(FilterController());
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  StaticController staticController = Get.put(StaticController());
  PageController _pageController = PageController();

  CameraPosition? currentPosition;
  GoogleMapController? mapController;

  late BitmapDescriptor icon;
  bool isListIcon = true;

  @override
  void initState() {
    loadClosestProperties();
    setState(() {});
    super.initState();
  }

  Future<void> loadClosestProperties() async {
    icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/current-location.png",
    );

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng centerCoordinates = LatLng(position.latitude, position.longitude);

    if (mounted) {
      setState(() {
        currentPosition = CameraPosition(
          target: centerCoordinates,
          zoom: 12,
        );
      });
    }

    if (currentPosition != null) {
      await propertiesController.getClosestProperties(
        currentPosition!.target.latitude,
        currentPosition!.target.longitude,
      );
    }

    // Filter closestProperties based on conditions
    propertiesController.closestProperties =
        propertiesController.closestProperties
            .where(
              (property) =>
                  property.userId != loginController.userDto?["id"] &&
                  (filterController.listingType
                      ? property.listingType == "For sell"
                      : property.listingType != "For sell"),
            )
            .toList();

    propertiesController.allMarkers = propertiesController.closestProperties
        .map((property) => Marker(
              markerId: MarkerId(property.id.toString()),
              position: LatLng(
                property.location?.latitude ?? 0.0,
                property.location?.longitude ?? 0.0,
              ),
              icon: property.userId == loginController.userDto?["id"]
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueViolet)
                  : filterController.listingType
                      ? BitmapDescriptor.defaultMarker
                      : BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue),
              onTap: () {
                Get.to(() => HomeInformation(property: property));
              },
            ))
        .toSet();

    propertiesController.allMarkers.add(
      Marker(
        markerId: const MarkerId('site_location'),
        position: centerCoordinates,
        icon: icon,
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              Get.off(() => const BottomBar());
            });
          },
        ),
        title: const Text(
          "Closest Properties",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isListIcon = !isListIcon;
                });
              },
              child: SizedBox(
                width: 82,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Icon(
                        isListIcon
                            ? Icons.format_list_bulleted
                            : Icons.map_outlined,
                        color: Colors.white,
                        size: isListIcon ? 21 : 22.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        isListIcon ? "List" : "Map",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isListIcon ? 17 : 14.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (isListIcon) mapWidget() else listWidget(),
        ],
      ),
    );
  }

  Widget mapWidget() {
    if (currentPosition != null) {
      return Expanded(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: currentPosition!,
          onMapCreated: (controller) {
            mapController = controller;
          },
          myLocationButtonEnabled: true,
          markers: propertiesController.allMarkers,
        ),
      );
    } else {
      // return Expanded(
      //   child: Center(
      //     child: CircularProgressIndicator(
      //       backgroundColor: Colors.grey[200],
      //     ),
      //   ),
      // );
      return const LinearProgressIndicator(
        backgroundColor: Colors.black,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        minHeight: 3,
      );
    }
  }

  Widget listWidget() {
    if (propertiesController.closestProperties.isEmpty) {
      return Expanded(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              SvgPicture.asset(
                'assets/images/house_searching.svg',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 30),
              const Text(
                "Oops! No results found",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "There are no properties in\nthe vicinity of you",
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      return Expanded(
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          itemCount: propertiesController.closestProperties.length,
          itemBuilder: (context, index) {
            final Property property =
                propertiesController.closestProperties.elementAt(index);

            // Check if property with the same ID exists in favoriteProperties
            bool isFavorite = staticController.favoriteProperties
                .any((favProperty) => favProperty.id == property.id);

            return Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 12.0,
                  spreadRadius: 0.2,
                  offset: Offset(
                    3.0,
                    3.0,
                  ),
                )
              ]),
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: InkWell(
                onTap: () {
                  Get.to(() => HomeInformation(property: property));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'Brokered by the ${property.listingBy} ',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                  ),
                                ),
                                TextSpan(
                                  text: property.user!.name,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 196, 39, 27),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 1),
                          Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),

                      const SizedBox(width: 1),

                      // Image
                      if (property.propertyFiles != null &&
                          property.propertyFiles!.isNotEmpty)
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                              child: Image.network(
                                property.propertyFiles![0].downloadUrls!,
                                width: double.infinity,
                                height: 220,
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.black12,
                                      highlightColor: Colors.black26,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20)),
                                        child: Container(
                                          width: double.infinity,
                                          height: 220,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),

                            // To add the house to favorites
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: InkWell(
                                onTap: () async {
                                  setState(() {});
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  SnackBar snackBar;

                                  // If it is in favourites
                                  if (isFavorite) {
                                    setState(() {
                                      isFavorite = false;
                                    });
                                    // Remove property with the same ID from favoriteProperties
                                    staticController.favoriteProperties
                                        .removeWhere((favProperty) =>
                                            favProperty.id == property.id);
                                    snackBar = const SnackBar(
                                      content: Text("Removed Successfully"),
                                      backgroundColor: Colors.red,
                                    );
                                  } else {
                                    // If it is not in favourites
                                    setState(() {
                                      isFavorite = true;
                                    });
                                    staticController.favoriteProperties
                                        .add(property);
                                    snackBar = const SnackBar(
                                      content: Text("Added Successfully"),
                                      backgroundColor: Colors.blue,
                                    );
                                  }

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                child: Container(
                                  width: 29,
                                  height: 29,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        149, 224, 224, 224),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: const Color.fromARGB(
                                          255, 196, 39, 27),
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        Container(),

                      const SizedBox(height: 20),

                      // Container
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                          color: Color.fromARGB(255, 196, 39, 27),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.listingType,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                "${property.location!.city}, ${property.location!.country}, ${property.location!.streetAddress}",
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 50),
                              Text(
                                "\$${NumberFormat.decimalPattern().format(property.price)} ${property.listingType == "For monthly rent" ? "/ monthly" : property.listingType == "For daily rent" ? "/ daily" : ""}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 1),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${property.numberOfBedRooms} ',
                                      style: const TextStyle(
                                        fontSize: 16.5,
                                        color:
                                            Color.fromARGB(255, 235, 233, 233),
                                      ),
                                    ),
                                    const TextSpan(
                                      text: 'bedrooms,  ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${property.numberOfBathRooms} ',
                                      style: const TextStyle(
                                        fontSize: 16.5,
                                        color:
                                            Color.fromARGB(255, 235, 233, 233),
                                      ),
                                    ),
                                    const TextSpan(
                                      text: 'bathrooms,  ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${property.squareMetersArea} ',
                                      style: const TextStyle(
                                        fontSize: 16.5,
                                        color:
                                            Color.fromARGB(255, 235, 233, 233),
                                      ),
                                    ),
                                    const TextSpan(
                                      text: 'meters',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      // button
                      Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 1.4,
                                ),
                              ),
                              onPressed: () {
                                Get.to(
                                    () => HomeInformation(property: property));
                              },
                              height: 40,
                              child: const Center(
                                child: Text(
                                  "Check availability",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
