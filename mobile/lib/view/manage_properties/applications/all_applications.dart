import 'dart:async';
import 'package:client/controller/application/applications_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/model/application.dart';
import 'package:client/view/manage_properties/applications/incoming_application.dart';
import 'package:client/view/manage_properties/applications/sent_application.dart';
import 'package:client/view/card/credit_card.dart';
import 'package:client/view/card/style/card_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AllApplications extends StatefulWidget {
  const AllApplications({Key? key});

  @override
  _AllApplicationsState createState() => _AllApplicationsState();
}

class _AllApplicationsState extends State<AllApplications>
    with AutomaticKeepAliveClientMixin {
  ApplicationsController controller =
      Get.put(ApplicationsController(), permanent: true);
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
    await controller.getApplications(loginController.userDto?["id"]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    const applicationStatus = [
      "All",
      "Pending",
      "Approved",
    ];

    final List<String> applicationType = [
      "All",
      "For daily rent",
      "For monthly rent",
      "For sell",
    ];

    return VisibilityDetector(
      key: const Key('allApplications'),
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
                  hintText: "Search by property code, customer, landlord name",
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
                    value: controller.applicationStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        controller.applicationStatus = newValue!;
                        loadData();
                      });
                    },
                    items: applicationStatus.map((String option) {
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
                    value: controller.applicationType,
                    onChanged: (String? newValue) {
                      setState(() {
                        controller.applicationType = newValue!;
                        loadData();
                      });
                    },
                    items: applicationType.map((String option) {
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
                      Tab(text: 'Incoming Applications'),
                      Tab(text: 'Sent Applications'),
                    ],
                    overlayColor: MaterialStatePropertyAll(Colors.grey[350]),
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    unselectedLabelColor: Colors.grey[700],
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      // Content for 'Incoming Applications' tab
                      VisibilityDetector(
                        key: const Key("IncomingApplications"),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 1) {
                            controller.applicationTo = "Landlord";
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
                              return contentIncomingApplications();
                            }
                          },
                        ),
                      ),

                      // Content for 'Sent Applications' tab
                      VisibilityDetector(
                        key: const Key("SentApplications"),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 1) {
                            controller.applicationTo = "Customer";
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
                              return contentSentApplications();
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

  Widget contentIncomingApplications() {
    if (controller.applications.isEmpty) {
      return const Center(
        child: Text(
          "No any incoming application",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemCount: controller.applications.length,
          itemBuilder: (context, index) {
            if (index >= controller.applications.length) {
              return null; // Return null if index is out of range
            }

            Application application = controller.applications[index];
            EdgeInsets _margin;

            if (index == controller.applications.length - 1) {
              _margin = const EdgeInsets.symmetric(vertical: 30);
            } else {
              _margin = const EdgeInsets.only(top: 30);
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  Get.to(const IncomingApplication(), arguments: application);
                });
              },
              child: Container(
                margin: _margin,
                child: CreditCard(
                  type: "application",
                  application: application,
                  index: index,
                  name: application.user.name!,
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

  Widget contentSentApplications() {
    if (controller.applications.isEmpty) {
      return const Center(
        child: Text(
          "No any sent application",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemCount: controller.applications.length,
          itemBuilder: (context, index) {
            if (index >= controller.applications.length) {
              return null; // Return null if index is out of range
            }

            Application application = controller.applications[index];
            EdgeInsets _margin;

            if (index == controller.applications.length - 1) {
              _margin = const EdgeInsets.symmetric(vertical: 30);
            } else {
              _margin = const EdgeInsets.only(top: 30);
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  Get.to(const SentApplication(), arguments: application);
                });
              },
              child: Container(
                margin: _margin,
                child: CreditCard(
                  type: "application",
                  application: application,
                  index: index,
                  name: application.property.user!.name!,
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
