import 'package:client/controller/bottom_bar/filter_controller.dart';
import 'package:client/controller/map_list/map_list_controller.dart';
import 'package:client/controller/static_api/static_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/property.dart';
import 'package:client/view/home_information/home_information.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../filter/filter_page.dart';

class ListWidget extends StatefulWidget {
  ListWidget({Key? key}) : super(key: key);

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget>
    with AutomaticKeepAliveClientMixin {
  StaticController staticController = Get.put(StaticController());
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  MapListController mapListController = Get.put(MapListController());
  FilterController filterController =
      Get.put(FilterController(), permanent: true);
  bool isWidgetVisible = false; // Add a variable to track visibility

  @override
  bool get wantKeepAlive => true; // Keep the state alive

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (mapListController.visibleProperties.isEmpty) {
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
                "Try changing or removing some of your filters or adjusting your\n search area",
                style: TextStyle(fontSize: 17),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 17),
              SizedBox(
                width: 190,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () {
                    Get.to(() => FilterPage());
                  },
                  height: 45,
                  color: Colors.black87,
                  child: const Center(
                    child: Text(
                      "Edit search",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
    return GetBuilder<MapListController>(
        init: MapListController(),
        builder: (MapListController controller) {
          return VisibilityDetector(
            key: const Key('List'),
            onVisibilityChanged: (info) {
              if (info.visibleFraction == 1) {
                isWidgetVisible = true;
                setState(() {});
              } else {
                isWidgetVisible = false;
              }
            },
            child: ListView.builder(
              itemCount: mapListController.visibleProperties.length,
              itemBuilder: (context, index) {
                final Property property =
                    mapListController.visibleProperties.elementAt(index);

                // Check if property with the same ID exists in favoriteProperties
                bool isFavorite = staticController.favoriteProperties
                    .any((favProperty) => favProperty.id == property.id);

                return InkWell(
                  onTap: () {
                    Get.to(() => HomeInformation(property: property));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.only(bottom: 35, left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (property.userId !=
                                loginController.userDto?["id"])
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'Brokered by the ${property.user!.userRole} ',
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
                              )
                            else
                              Text.rich(
                                TextSpan(
                                  text: 'This is your property',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 12.5,
                                  ),
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "\$${NumberFormat.decimalPattern().format(property.price)} ${property.listingType == "For monthly rent" ? "/ monthly" : property.listingType == "For daily rent" ? "/ daily" : ""}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 170,
                                        child: Text(
                                          property.location!.streetAddress,
                                          style:
                                              const TextStyle(fontSize: 14.5),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      SizedBox(
                                        width: 170,
                                        child: Text(
                                          "${property.location!.city}, ${property.location!.country}",
                                          style:
                                              const TextStyle(fontSize: 14.5),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 180,
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        side: const BorderSide(
                                            color: Colors.black, width: 1.4),
                                      ),
                                      onPressed: () {
                                        Get.to(() => HomeInformation(
                                            property: property));
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
            ),
          );
        });
  }
}
