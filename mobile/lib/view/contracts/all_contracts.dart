import 'dart:convert';
import 'package:client/controller/contract/contracts_controller.dart';
import 'package:client/main.dart';
import 'package:client/model/contract.dart';
import 'package:client/model/user.dart';
import 'package:client/view/contracts/customer%20contract/customer_contract.dart';
import 'package:client/view/contracts/landlord%20contract/landlord_contract.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AllContracts extends StatefulWidget {
  const AllContracts({Key? key});

  @override
  _AllContractsState createState() => _AllContractsState();
}

class _AllContractsState extends State<AllContracts>
    with AutomaticKeepAliveClientMixin {
  ContractsController controller =
      Get.put(ContractsController(), permanent: true);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {});
  }

  Future<void> loadData() async {
    String? userDtoJson = sharepref.getString("user");
    Map<String, dynamic> userDto = json.decode(userDtoJson ?? "{}");
    User user = User.fromJson(userDto);
    controller.userId = user.id!;
    await controller.getContrcatsForUser();
  }

  String divideCodeIntoGroups(String code) {
    final RegExp pattern = RegExp(r".{1,3}");
    Iterable<Match> matches = pattern.allMatches(code);
    List<String> groups = matches.map((match) => match.group(0)!).toList();
    return groups.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    const contractStatus = [
      "All",
      "Closed",
      "Active",
    ];

    const contractType = [
      "All",
      "For monthly rent",
      "For sell",
    ];

    return VisibilityDetector(
      key: const Key('allcontracts'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          loadData();
          setState(() {});
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Contracts",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            // Search
            const SizedBox(height: 15),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                style: const TextStyle(height: 1.2),
                decoration: InputDecoration(
                  hintText: "Search by contract, customer, landlord name",
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
                    value: controller.contractStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        controller.contractStatus = newValue!;
                        loadData();
                      });
                    },
                    items: contractStatus.map((String option) {
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
                    value: controller.contractType,
                    onChanged: (String? newValue) {
                      setState(() {
                        controller.contractType = newValue!;
                        loadData();
                      });
                    },
                    items: contractType.map((String option) {
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
                      Tab(text: 'Landlord Contracts'),
                      Tab(text: 'Customer Contracts'),
                    ],
                    overlayColor: MaterialStatePropertyAll(Colors.grey[350]),
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.5,
                    ),
                    unselectedLabelColor: Colors.grey[700],
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16.5,
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      // Content for 'Landlord Contracts' tab
                      VisibilityDetector(
                        key: const Key("LandlordContracts"),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 1) {
                            controller.contractTo = "Landlord";
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
                              return contentLandlordContracts();
                            }
                          },
                        ),
                      ),

                      // Content for 'Customer Contracts' tab
                      VisibilityDetector(
                        key: const Key("CustomerContracts"),
                        onVisibilityChanged: (info) {
                          if (info.visibleFraction == 1) {
                            controller.contractTo = "Customer";
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
                              return contentCustomerContracts();
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

  Widget contentLandlordContracts() {
    if (controller.userContracts.isEmpty) {
      return const Center(
        child: Text(
          "No any landlord contract",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemCount: controller.userContracts.length,
          itemBuilder: (context, index) {
            if (index >= controller.userContracts.length) {
              return null; // Return null if index is out of range
            }

            Contract contract = controller.userContracts[index];
            EdgeInsets _margin;

            if (index == controller.userContracts.length - 1) {
              _margin =
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 30);
            } else {
              _margin = const EdgeInsets.only(left: 15, right: 15, top: 30);
            }

            return GestureDetector(
              onTap: () {
                controller.visitLawyerFromContract = true;
                controller.currentContract = contract;
                Get.to(() => LandlordContract(contract: contract));
                setState(() {});
              },
              child: contractStyle(
                contract,
                _margin,
                index,
                true,
              ),
            );
          },
        ),
      );
    }
  }

  Widget contentCustomerContracts() {
    if (controller.userContracts.isEmpty) {
      return const Center(
        child: Text(
          "No any customer contract",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: ListView.builder(
          itemCount: controller.userContracts.length,
          itemBuilder: (context, index) {
            if (index >= controller.userContracts.length) {
              return null; // Return null if index is out of range
            }

            Contract contract = controller.userContracts[index];
            EdgeInsets _margin;

            if (index == controller.userContracts.length - 1) {
              _margin =
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 30);
            } else {
              _margin = const EdgeInsets.only(left: 15, right: 15, top: 30);
            }

            return GestureDetector(
              onTap: () {
                controller.visitLawyerFromContract = true;
                controller.currentContract = contract;
                Get.to(() => CustomerContract(contract: contract));
                setState(() {});
              },
              child: contractStyle(
                contract,
                _margin,
                index,
                false,
              ),
            );
          },
        ),
      );
    }
  }

  Widget contractStyle(
      Contract contract, EdgeInsets _margin, int index, bool landlordContract) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[400]!.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 1,
            offset: const Offset(-3.5, 3.5),
          ),
        ],
      ),
      margin: _margin,
      child: ListTile(
        title: Column(
          children: [
            // Intoducation
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  FontAwesomeIcons.handshake,
                  size: 25,
                  // color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 50),
                  child: Text(
                    "Contract ${index + 1}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      // color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  (DateTime.now().year == contract.startDate.year)
                      ? DateFormat('MM-dd').format(contract.startDate)
                      : DateFormat('yyyy-MM-dd').format(contract.startDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    // color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              (contract.offer!.description.length <= 65)
                  ? contract.offer!.description
                  : '${contract.offer!.description.substring(0, 65)}...',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        isThreeLine: true,
        subtitle: Column(
          children: [
            const SizedBox(height: 15),
            Container(height: 0.7, color: const Color(0xffd92328)),
            const SizedBox(height: 15),
            Text(
              landlordContract == true
                  ? contract.offer!.customer!.name!
                  : contract.offer!.landlord!.name!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                // color: Color(0xffd92328),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              divideCodeIntoGroups(contract.offer!.property!.propertyCode),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                // color: Color(0xffd92328),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      "Price: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      contract.offer!.price.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Color(0xffd92328),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "Status: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      contract.contractStatus,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Color(0xffd92328)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
