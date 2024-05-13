import 'package:client/controller/bottom_bar/filter_controller.dart';
import 'package:client/controller/map_list/map_list_controller.dart';
import 'package:client/controller/static_api/static_controller.dart';
import 'package:client/model/location.dart';
import 'package:client/model/property.dart';
import 'package:client/view/notification/notifications.dart';
import 'package:client/view/search/location_list_tile.dart';
import 'package:client/view/search/property_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SearchBarRow extends StatefulWidget {
  final VoidCallback onToggleView;

  const SearchBarRow({
    Key? key,
    required this.onToggleView,
  }) : super(key: key);

  @override
  State<SearchBarRow> createState() => _SearchBarRowState();
}

class _SearchBarRowState extends State<SearchBarRow> {
  MapListController controller = Get.put(MapListController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: CustomSearch(),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                height: 50,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(239, 239, 239, 10),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 13),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.search_outlined,
                          size: 26,
                        ),
                      ),
                    ),
                    Container(width: 12),
                    Container(
                      width: 200,
                      child: Obx(() {
                        return Text(
                          controller.currentLocationName.value == ""
                              ? "City, ZIP, School, Address"
                              : "Area in ${controller.currentLocationName.value}",
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black45,
                          ),
                          overflow: TextOverflow.ellipsis,
                        );
                      }),
                    ),
                    Container(width: 8),
                  ],
                ),
              ),
            ),
            Container(width: 10),
            InkWell(
              onTap: () {
                Get.to(() => const Notifications());
              },
              child: Stack(
                children: [
                  const Icon(
                    FontAwesomeIcons.solidBell,
                    size: 27,
                    color: Colors.black,
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
                      child: const Center(
                        child: Text(
                          "2",
                          style: TextStyle(
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
            GestureDetector(
              onTap: () {
                widget.onToggleView();
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                width: 82,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Icon(
                        controller.isListIcon
                            ? Icons.format_list_bulleted
                            : Icons.map_outlined,
                        color: Colors.black,
                        size: controller.isListIcon ? 27 : 28,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        controller.isListIcon ? "List" : "Map",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: controller.isListIcon ? 20 : 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  FilterController filterController = Get.put(FilterController());

  Future<void> loadData() async {
    await filterController.getListAutoCompleteLocation(query);
    print(filterController.listAutoCompleteLocation);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return theme.copyWith(
      appBarTheme: const AppBarTheme(),
      textTheme: theme.textTheme.copyWith(
        headline6: const TextStyle(
          fontSize: 18,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query == "")
        IconButton(
          onPressed: () async {},
          icon: const Icon(Icons.keyboard_voice, size: 30, color: Colors.black),
        )
      else
        IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close, size: 27, color: Colors.black),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back, size: 27, color: Colors.black),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text("");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query != "") {
      return FutureBuilder<void>(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                const Divider(
                  height: 1.5,
                  color: Colors.grey,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filterController.listAutoCompleteLocation.length,
                    itemBuilder: (context, index) {
                      Location location =
                          filterController.listAutoCompleteLocation[index];

                      return LocationListTile(
                        location: location,
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      );
    } else {
      return Scaffold(
        body: GetBuilder<StaticController>(
            init: StaticController(),
            builder: (StaticController staticController) {
              return ListView(
                children: [
                  const Divider(
                    height: 1.5,
                    color: Colors.grey,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: filterController.listingType
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 3.0,
                              ),
                            ),
                          ),
                          child: Text(
                            'Buy',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: filterController.listingType
                                  ? Colors.black
                                  : Colors.black45,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: !filterController.listingType
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 3.0,
                              ),
                            ),
                          ),
                          child: Text(
                            'Rent',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                              color: !filterController.listingType
                                  ? Colors.black
                                  : Colors.black45,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 1.5,
                    color: Colors.grey,
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            // Add your logic here for handling the tap event
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.my_location,
                                  size: 22,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Use current location",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1.5,
                          color: Colors.grey,
                        ),
                        InkWell(
                          onTap: () {
                            // Add your logic here for handling the tap event
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.car,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Tracking my location",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1.5,
                          color: Colors.grey,
                        ),

                        // Recently Search
                        const SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Recently Search",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            if (staticController.searchLocation.isNotEmpty)
                              InkWell(
                                onTap: () {
                                  staticController.clearsearchLocation();
                                },
                                child: const Text(
                                  "Clear all",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 196, 39, 27),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (staticController.searchLocation.isEmpty)
                          const Text(
                            "You have not searched for any location",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          )
                        else
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: staticController.searchLocation.length,
                            itemBuilder: (context, index) {
                              Location location =
                                  staticController.searchLocation[index];

                              return LocationListTile(
                                location: location,
                              );
                            },
                          ),

                        // Recently Viewed
                        const SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Recently Viewed",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            if (staticController.searchProperties.isNotEmpty)
                              InkWell(
                                onTap: () {
                                  staticController.clearsearchProperties();
                                },
                                child: const Text(
                                  "Clear all",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 196, 39, 27),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (staticController.searchProperties.isEmpty)
                          const Text(
                            "You have not searched for any property",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          )
                        else
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: staticController.searchProperties.length,
                            itemBuilder: (context, index) {
                              Property property =
                                  staticController.searchProperties[index];

                              return PropertyListTile(
                                property: property,
                              );
                            },
                          ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              );
            }),
      );
    }
  }
}
