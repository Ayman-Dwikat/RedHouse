import 'dart:async';
import 'package:client/controller/map_list/map_list_controller.dart';
import 'package:client/controller/static_api/static_controller.dart';
import 'package:client/model/property.dart';
import 'package:client/view/bottom_bar/bottom_bar.dart';
import 'package:client/view/home_information/home_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class FavoriteProperties extends StatefulWidget {
  const FavoriteProperties({super.key});

  @override
  State<FavoriteProperties> createState() => _FavoritePropertiesState();
}

class _FavoritePropertiesState extends State<FavoriteProperties>
    with AutomaticKeepAliveClientMixin {
  StaticController staticController = Get.put(StaticController());
  late bool _isLoading;
  late Timer _timer;

  @override
  bool get wantKeepAlive => true; // Keep the state alive

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    loadData();
    super.initState();
  }

  void loadData() {
    _timer = Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Favorite properties",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Stack(
              children: [
                const Icon(
                  FontAwesome.cart_plus,
                  size: 29,
                  color: Colors.white,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 17,
                    height: 17,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: Center(
                      child: Text(
                        staticController.favoriteProperties.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: VisibilityDetector(
          key: const Key('Favorite'),
          onVisibilityChanged: (info) {
            loadData();
          },
          child: _FavoriteProperties()),
    );
  }

  Widget _FavoriteProperties() {
    if (staticController.favoriteProperties.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsetsDirectional.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                "You have not added any property to your favorites",
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 17),
              Container(
                width: 255,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Get.offAll(() => const BottomBar());
                  },
                  height: 45,
                  color: Colors.black87,
                  child: const Center(
                    child: Text(
                      "Add property to favorite",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // ListView builder for homes
    return ListView.builder(
      itemCount: staticController.favoriteProperties.length,
      itemBuilder: (context, index) {
        final Property property =
            staticController.favoriteProperties.elementAt(index);

        bool isFavorite =
            staticController.favoriteProperties.contains(property);

        return InkWell(
          onTap: () {
            Get.to(() => HomeInformation(property: property));
          },
          child: Container(
            margin:
                const EdgeInsets.only(top: 25, bottom: 20, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Brokered by the ${property.listingBy} ',
                            style: TextStyle(
                              color: Colors.grey[700],
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
                const SizedBox(height: 1),
                if (property.propertyFiles != null &&
                    property.propertyFiles!.isNotEmpty)
                  Stack(
                    children: [
                      if (_isLoading)
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: Image.network(
                              property.propertyFiles![0].downloadUrls!,
                              width: double.infinity,
                              height: 220,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
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
                              ),
                            ),

                            // This favorite icon to add home to favorite homes
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
                                    staticController.favoriteProperties
                                        .remove(property);

                                    snackBar = const SnackBar(
                                      content: Text("Removed Successfully"),
                                      backgroundColor: Colors.red,
                                    );
                                  }
                                  // If it is not in favourites
                                  else {
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
                        ),
                    ],
                  ),
                Container(
                  padding: const EdgeInsets.only(left: 4, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromARGB(255, 196, 39, 27),
                            ),
                          ),
                          Text(
                            " ${property.listingType}",
                            style: const TextStyle(fontSize: 17.5),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "\$${NumberFormat.decimalPattern().format(property.price)}${property.listingType == "For rent" ? "/mo" : ""}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        property.propertyType,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 196, 39, 27),
                        ),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${property.numberOfBedRooms} ',
                              style: const TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 196, 39, 27),
                              ),
                            ),
                            const TextSpan(
                              text: 'bedrooms, ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '${property.numberOfBathRooms} ',
                              style: const TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 196, 39, 27),
                              ),
                            ),
                            const TextSpan(
                              text: 'bathrooms, ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '${property.squareMetersArea} ',
                              style: const TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 196, 39, 27),
                              ),
                            ),
                            const TextSpan(
                              text: 'meters',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.location!.streetAddress,
                                style: const TextStyle(fontSize: 14.5),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                "${property.location!.city}, ${property.location!.country}",
                                style: const TextStyle(fontSize: 14.5),
                              ),
                            ],
                          ),
                          Container(
                            width: 180,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: const BorderSide(
                                    color: Colors.black, width: 1.4),
                              ),
                              onPressed: () {
                                Get.to(
                                    () => HomeInformation(property: property));
                              },
                              height: 37,
                              child: const Center(
                                child: Text(
                                  "Check availability",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
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
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
