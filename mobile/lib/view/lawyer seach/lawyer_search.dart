import 'package:client/controller/bottom_bar/filter_controller.dart';
import 'package:client/controller/static_api/static_controller.dart';
import 'package:client/controller/users_auth/signup_controller.dart';
import 'package:client/model/location.dart';
import 'package:client/model/property.dart';
import 'package:client/model/user.dart';
import 'package:client/view/lawyer%20seach/lawyer_list_tile.dart';
import 'package:client/view/search/location_list_tile.dart';
import 'package:client/view/search/property_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LawyerSearch extends SearchDelegate {
  SignUpControllerImp controller =
      Get.put(SignUpControllerImp(), permanent: true);

  Future<void> loadData() async {
    await controller.getListAutoCompleteLawyer(query);
    print(controller.listAutoCompleteLawyer);
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
                    itemCount: controller.listAutoCompleteLawyer.length,
                    itemBuilder: (context, index) {
                      User user = controller.listAutoCompleteLawyer[index];

                      return LawyerListTile(
                        lawyer: user,
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
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            if (staticController
                                .recentlySearchLawyers.isNotEmpty)
                              InkWell(
                                onTap: () {
                                  staticController.clearSearchLawyers();
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
                        if (staticController.recentlySearchLawyers.isEmpty)
                          const Text(
                            "You have not searched for any lawyer",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          )
                        else
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                staticController.recentlySearchLawyers.length,
                            itemBuilder: (context, index) {
                              User user =
                                  staticController.recentlySearchLawyers[index];

                              return LawyerListTile(
                                lawyer: user,
                              );
                            },
                          ),

                        // Recently Select
                        const SizedBox(height: 60),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Recently Select",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            if (staticController
                                .recentlySelectLawyers.isNotEmpty)
                              InkWell(
                                onTap: () {
                                  staticController.clearSelectLawyers();
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
                        if (staticController.recentlySelectLawyers.isEmpty)
                          const Text(
                            "You have not selected any lawyer",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          )
                        else
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                staticController.recentlySelectLawyers.length,
                            itemBuilder: (context, index) {
                              User user =
                                  staticController.recentlySelectLawyers[index];

                              return LawyerListTile(
                                lawyer: user,
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
