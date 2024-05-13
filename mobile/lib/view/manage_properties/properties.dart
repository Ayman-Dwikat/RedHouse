import 'dart:async';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/controller/propertise/properties_controller.dart';
import 'package:client/view/add_property/add_property_1.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:client/model/property.dart';
import 'package:client/view/home_information/home_information.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Properties extends StatefulWidget {
  const Properties({Key? key}) : super(key: key);

  @override
  _AllPropertiesState createState() => _AllPropertiesState();
}

const propertiesFilterList = [
  "All properties",
  "Rented properties",
  "Purchased properties",
  "Posted properties",
  "Properties that have been rented",
  "Properties that have been sold"
];

class _AllPropertiesState extends State<Properties>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = true; // Add a boolean variable for loading data from api
  ManagePropertiesController controller = Get.put(ManagePropertiesController());
  LoginControllerImp loginController = Get.put(LoginControllerImp());

  @override
  bool get wantKeepAlive => true; // Keep the state alive

  Future<void> getLatAndLong() async {
    Position cl = await Geolocator.getCurrentPosition().then((value) => value);
    double lat = cl.latitude;
    double long = cl.longitude;
    controller.currentPosition =
        CameraPosition(target: LatLng(lat, long), zoom: 13);
  }

  @override
  void initState() {
    super.initState();
    loadData();
    getLatAndLong();
    setState(() {});
  }

  Future<void> loadData() async {
    var id = loginController.userDto?["id"];
    if (id == null || id <= 0) return;
    controller.propertiesUserId = id;
    await controller.getPropertiesUser();

    if (mounted) {
      setState(() {
        isLoading = false; // Set isLoading to false when data is loaded
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.grey[200],
        ),
      );
    }

    return VisibilityDetector(
      key: const Key('UserProperties'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          loadData(); // Call your initialization logic here
        }
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: controller.userProperties.isEmpty
            ? null
            : SizedBox(
                height: 40,
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    Get.to(() => AddProperty1());
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  icon: const Icon(
                    Icons.add,
                    size: 22,
                  ),
                  label: const Text("Add property"),
                ),
              ),

        // Body
        body: Column(
          children: [
            Container(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: 360,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: DropdownButton<String>(
                alignment: Alignment.centerLeft,
                isExpanded: true,
                value: controller.propertiesFilter,
                onChanged: (String? newValue) {
                  setState(() {
                    controller.propertiesFilter = newValue!;
                    loadData();
                  });
                },
                items: propertiesFilterList.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
            ),
            Container(height: 10),

            // userProperties isEmpty
            if (controller.userProperties.isEmpty)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
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
                    "You did not offer a property for",
                    style: TextStyle(fontSize: 17),
                  ),
                  const Text(
                    "sell or rent.",
                    style: TextStyle(fontSize: 17),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 200,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        Get.to(() => AddProperty1());
                      },
                      height: 45,
                      color: Colors.black87,
                      child: const Center(
                        child: Text(
                          "Add property",
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
              )

            // userProperties isNotEmpty
            else
              Expanded(
                child: ListView.builder(
                  itemCount: controller.userProperties.length,
                  itemBuilder: (context, index) {
                    Property property =
                        controller.userProperties.elementAt(index);
                    return InkWell(
                      onTap: () {
                        Get.to(() => HomeInformation(property: property));
                      },
                      child: Column(
                        children: [
                          Container(
                            margin:
                                index == (controller.userProperties.length - 1)
                                    ? const EdgeInsets.only(
                                        top: 25,
                                        bottom: 65,
                                        left: 15,
                                        right: 15)
                                    : const EdgeInsets.only(
                                        top: 10,
                                        bottom: 20,
                                        left: 15,
                                        right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (property.userId ==
                                    loginController.userDto?["id"])
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {},
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          child: Icon(
                                            FontAwesomeIcons.share,
                                            size: 16,
                                            color:
                                                Color.fromARGB(255, 25, 23, 23),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          child: Icon(
                                            FontAwesomeIcons.pencil,
                                            size: 16,
                                            color:
                                                Color.fromARGB(255, 25, 23, 23),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Theme(
                                                data: ThemeData(
                                                  dialogBackgroundColor:
                                                      Colors.white,
                                                ),
                                                child: Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxHeight: 450),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 30,
                                                                  left: 20,
                                                                  right: 20),
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                property.propertyStatus !=
                                                                        "Under contract"
                                                                    ? "Are you sure you want to delete the property?"
                                                                    : "This property is under contract and you cannot delete it now",
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 19,
                                                                ),
                                                              ),
                                                              if (property
                                                                      .propertyStatus !=
                                                                  "Under contract")
                                                                Text(
                                                                  "\nIf you delete the property, everything related to it, such as contracts and booking, will also be deleted",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                            .grey[
                                                                        600],
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 15),
                                                          child: ButtonBar(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  if (property
                                                                          .propertyStatus !=
                                                                      "Under contract")
                                                                    Container(
                                                                      width:
                                                                          210,
                                                                      height:
                                                                          40,
                                                                      color: Colors
                                                                          .red,
                                                                      child:
                                                                          MaterialButton(
                                                                        onPressed:
                                                                            () async {
                                                                          ScaffoldMessenger.of(context)
                                                                              .clearSnackBars();

                                                                          await controller
                                                                              .deleteProperty(property.id);

                                                                          setState(
                                                                              () {});

                                                                          SnackBar
                                                                              snackBar =
                                                                              const SnackBar(
                                                                            content:
                                                                                Text("Deleted Successfully"),
                                                                            backgroundColor:
                                                                                Colors.red,
                                                                          );
                                                                          ScaffoldMessenger.of(context)
                                                                              .showSnackBar(snackBar);

                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          "Delete Property",
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  else
                                                                    Container(
                                                                      width:
                                                                          210,
                                                                      height:
                                                                          40,
                                                                      color: Colors
                                                                          .blue,
                                                                      child:
                                                                          MaterialButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child:
                                                                            const Text(
                                                                          "OK",
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  const SizedBox(
                                                                      width: 5),
                                                                  SizedBox(
                                                                    height: 40,
                                                                    child:
                                                                        MaterialButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                          const Text(
                                                                        "Close",
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontSize:
                                                                              17.5,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          child: Icon(
                                            FontAwesomeIcons.trash,
                                            size: 16,
                                            color:
                                                Color.fromARGB(255, 25, 23, 23),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                // Image
                                if (property.propertyFiles != null &&
                                    property.propertyFiles!.isNotEmpty)
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20)),
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
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                  )
                                else
                                  Container(),

                                Container(
                                  padding:
                                      const EdgeInsets.only(left: 4, top: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromARGB(
                                                  255, 196, 39, 27),
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
                                          color:
                                              Color.fromARGB(255, 196, 39, 27),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${property.numberOfBedRooms} ',
                                              style: const TextStyle(
                                                fontSize: 16.5,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 196, 39, 27),
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
                                              text:
                                                  '${property.numberOfBathRooms} ',
                                              style: const TextStyle(
                                                fontSize: 16.5,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 196, 39, 27),
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
                                              text:
                                                  '${property.squareMetersArea} ',
                                              style: const TextStyle(
                                                fontSize: 16.5,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 196, 39, 27),
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
                                                  property
                                                      .location!.streetAddress,
                                                  style: const TextStyle(
                                                      fontSize: 14.5),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              const SizedBox(height: 1),
                                              SizedBox(
                                                width: 170,
                                                child: Text(
                                                  "${property.location!.city}, ${property.location!.country}",
                                                  style: const TextStyle(
                                                      fontSize: 14.5),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                    color: Colors.black,
                                                    width: 1.4),
                                              ),
                                              onPressed: () {
                                                Get.to(() => HomeInformation(
                                                    property: property));
                                              },
                                              height: 37,
                                              child: const Center(
                                                child: Text(
                                                  "Show details",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.5,
                                                    fontWeight: FontWeight.w600,
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
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
