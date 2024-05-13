import 'package:client/controller/bottom_bar/filter_controller.dart';
import 'package:client/controller/map_list/map_list_controller.dart';
import 'package:client/view/filter/bedbath_filter.dart';
import 'package:client/view/filter/price_filter.dart';
import 'package:client/view/filter/propertytype_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterElements extends StatefulWidget {
  const FilterElements({Key? key}) : super(key: key);

  @override
  State<FilterElements> createState() => _RentFilterState();
}

class _RentFilterState extends State<FilterElements> {
  MapListController mapListController = Get.put(MapListController());
  FilterController controller = Get.put(FilterController(), permanent: true);
  late bool house;
  late bool apartment;
  late bool townhouse;
  late bool castle;
  late bool department;

  @override
  Widget build(BuildContext context) {
    const options = [
      "Any",
      "City",
      "Village",
      "Mountain",
      "Beach",
      "Island",
    ];

    const listingBy = [
      "Any",
      "Agent",
      "Landlord",
      "Customer",
    ];

    const rentType = [
      "All",
      "For daily",
      "For monthly",
    ];

    String formatPropertyTypes() {
      if (controller.houseTemp &&
          controller.apartmentTemp &&
          controller.townhouseTemp &&
          controller.castleTemp &&
          controller.departmentTemp) {
        return 'Any';
      } else {
        List<String> selectedTypes = [];
        if (controller.houseTemp) {
          selectedTypes.add('House');
        }
        if (controller.apartmentTemp) {
          selectedTypes.add('Apartment Unit');
        }
        if (controller.townhouseTemp) {
          selectedTypes.add('Townhouse');
        }
        if (controller.castleTemp) {
          selectedTypes.add('Castle');
        }
        if (controller.departmentTemp) {
          selectedTypes.add('Entire Department');
        }
        return selectedTypes.join(', ');
      }
    }

    return GetBuilder<FilterController>(
        init: FilterController(),
        builder: (controller) => Container(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        // Property Type
                        MaterialButton(
                          onPressed: () {
                            house = controller.houseTemp;
                            apartment = controller.apartmentTemp;
                            townhouse = controller.townhouseTemp;
                            castle = controller.castleTemp;
                            department = controller.departmentTemp;
                            showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30))),
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(30))),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              1.8,
                                      child: Column(
                                        children: [
                                          const ReusePropertType(),
                                          Container(
                                            width: 340,
                                            child: MaterialButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  house = controller.houseTemp;
                                                  apartment =
                                                      controller.apartmentTemp;
                                                  townhouse =
                                                      controller.townhouseTemp;
                                                  castle =
                                                      controller.castleTemp;
                                                  department =
                                                      controller.departmentTemp;
                                                });

                                                Navigator.pop(context);
                                              },
                                              minWidth: 300,
                                              height: 45,
                                              color: Colors.black87,
                                              child: const Center(
                                                child: Text(
                                                  "Apply",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ).whenComplete(() {
                              setState(() {
                                controller.houseTemp = house;
                                controller.apartmentTemp = apartment;
                                controller.townhouseTemp = townhouse;
                                controller.castleTemp = castle;
                                controller.departmentTemp = department;
                              });
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(" Property Type",
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w500,
                                  )),
                              Container(height: 4),
                              Text(
                                formatPropertyTypes(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Price
                        Container(height: 30),
                        const Text("    Price",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(height: 10),
                        const ReuseRowPrice(),

                        // BedBathRow
                        Container(height: 30),
                        const ReuseBedBathRow(),

                        // Property View
                        Container(height: 30),
                        const Text("    Property View",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[700]!,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: DropdownButton<String>(
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                            value: controller.viewTemp,
                            items: options.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  controller.viewTemp = newValue;
                                });
                              }
                            },
                            isExpanded: true,
                            underline: const SizedBox(),
                          ),
                        ),

                        // Listing By
                        Container(height: 30),
                        const Text("    Listing By",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[700]!,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: DropdownButton<String>(
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                            value: controller.listingByTemp,
                            items: listingBy.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  controller.listingByTemp = newValue;
                                });
                              }
                            },
                            isExpanded: true,
                            underline: const SizedBox(),
                          ),
                        ),

                        // Property Size
                        Container(height: 30),
                        const Text("    Property Size",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(height: 10),
                        const HomeSize(),

                        // Rent Type
                        if (controller.listingType == false)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(height: 30),
                              const Text("    Rent Type",
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w500,
                                  )),
                              Container(height: 10),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 13),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[700]!,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: DropdownButton<String>(
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                  value: controller.rentTypeTemp,
                                  items: rentType.map((String option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        controller.rentTypeTemp = newValue;
                                      });
                                    }
                                  },
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                ),
                              ),
                            ],
                          ),

                        // Property Status
                        Container(height: 30),
                        const Text("    Property Status",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            children: [
                              CheckboxListTile(
                                title: Text(
                                  "Coming Soon",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                value: controller.comingSoonTemp,
                                onChanged: (value) {
                                  setState(() {
                                    controller.comingSoonTemp = value!;
                                  });
                                },
                                activeColor:
                                    const Color.fromARGB(255, 11, 93, 161),
                              ),
                              CheckboxListTile(
                                title: Text(
                                  "Accepting Offers",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                value: controller.acceptingOffersTemp,
                                onChanged: (value) {
                                  setState(() {
                                    controller.acceptingOffersTemp = value!;
                                  });
                                },
                                activeColor:
                                    const Color.fromARGB(255, 11, 93, 161),
                              ),
                              CheckboxListTile(
                                title: Text(
                                  "Pending & Under Contract",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                value: controller.underContractTemp,
                                onChanged: (value) {
                                  setState(() {
                                    controller.underContractTemp = value!;
                                  });
                                },
                                activeColor:
                                    const Color.fromARGB(255, 11, 93, 161),
                              ),
                            ],
                          ),
                        ),

                        // Parking Spots
                        Container(height: 30),
                        const Text("    Parking Spots",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(height: 10),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                            controller: controller.parkingSpotsTemp,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.numbers),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),

                        // Basement
                        Container(height: 30),
                        const Text("    Basement",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: CheckboxListTile(
                            title: Text(
                              "Has Basement",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            value: controller.basementTemp,
                            onChanged: (value) {
                              setState(() {
                                controller.basementTemp = value!;
                              });
                            },
                            activeColor: const Color.fromARGB(255, 11, 93, 161),
                          ),
                        ),

                        // Year Built
                        Container(height: 30),
                        const Text("    Year Built",
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                            )),
                        Container(height: 10),
                        const YearBuilt(),

                        // End
                        Container(height: 20),
                      ],
                    ),
                  ),

                  // Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 13, horizontal: 16),
                    child: MaterialButton(
                      onPressed: () {
                        if ((controller.minControllerTemp.text != "" &&
                                controller.maxControllerTemp.text != "" &&
                                int.parse(controller.minControllerTemp.text) >
                                    int.parse(
                                        controller.maxControllerTemp.text)) ||
                            (controller.sizeMinTemp.text != "" &&
                                controller.sizeMaxTemp.text != "" &&
                                int.parse(controller.sizeMinTemp.text) >
                                    int.parse(controller.sizeMaxTemp.text)) ||
                            (controller.yearBuiltMinTemp.text != "" &&
                                controller.yearBuiltMaxTemp.text != "" &&
                                int.parse(controller.yearBuiltMinTemp.text) >
                                    int.parse(
                                        controller.yearBuiltMaxTemp.text))) {
                          Get.rawSnackbar(
                            snackPosition: SnackPosition.TOP,
                            messageText: const Text(
                              'The minimum limit can`t be greater than the maximum',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            isDismissible: false,
                            duration: const Duration(seconds: 3),
                            backgroundColor: Colors.red[400]!,
                            icon: const Icon(
                              Icons.warning,
                              color: Colors.white,
                              size: 35,
                            ),
                            margin: EdgeInsets.zero,
                            snackStyle: SnackStyle.GROUNDED,
                          );
                        } else {
                          if (controller.tabType == false) {
                            controller.listingType = false;
                          } else {
                            controller.listingType = true;
                          }

                          // Property type
                          controller.house = controller.houseTemp;
                          controller.apartment = controller.apartmentTemp;
                          controller.townhouse = controller.townhouseTemp;
                          controller.castle = controller.castleTemp;
                          controller.department = controller.departmentTemp;

                          // Price
                          controller.maxController.text =
                              controller.maxControllerTemp.text;
                          controller.minController.text =
                              controller.minControllerTemp.text;

                          // Bed Bath
                          controller.copyBathButton();
                          controller.copyBedButton();

                          // Property view
                          controller.view = controller.viewTemp;

                          // Listing by
                          controller.listingBy = controller.listingByTemp;

                          // Property size
                          controller.sizeMax.text = controller.sizeMaxTemp.text;
                          controller.sizeMin.text = controller.sizeMinTemp.text;

                          // Rent type
                          controller.rentType = controller.rentTypeTemp;

                          // Property status
                          controller.comingSoon = controller.comingSoonTemp;
                          controller.acceptingOffers =
                              controller.acceptingOffersTemp;
                          controller.underContract =
                              controller.underContractTemp;

                          // Parking spots
                          controller.parkingSpots.text =
                              controller.parkingSpotsTemp.text;

                          // Basement
                          controller.basement = controller.basementTemp;

                          // Year built
                          controller.yearBuiltMax.text =
                              controller.yearBuiltMaxTemp.text;
                          controller.yearBuiltMin.text =
                              controller.yearBuiltMinTemp.text;

                          // // //
                          controller.formatPriceRange();
                          controller.formatBedBath();
                          controller.formatPropertyTypes();
                          controller.checkFiltersON();
                          controller.getProperties();
                          // mapListController.isLoading = true;

                          Navigator.pop(context);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minWidth: 300,
                      height: 45,
                      color: Colors.black87,
                      child: const Center(
                        child: Text(
                          "See homes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}

// Others widgets
// Others widgets
// Others widgets
// Others widgets

class HomeSize extends StatefulWidget {
  const HomeSize({Key? key}) : super(key: key);

  @override
  _RentHomeSizeState createState() => _RentHomeSizeState();
}

class _RentHomeSizeState extends State<HomeSize> {
  FilterController controller = Get.put(FilterController());

  final FocusNode _focusMinNode = FocusNode();
  final FocusNode _focusMAxNode = FocusNode();
  bool clearMin = false;
  bool clearMax = false;

  @override
  void initState() {
    super.initState();
    _focusMinNode.addListener(() {
      setState(() {
        clearMin = _focusMinNode.hasFocus;
      });
    });
    _focusMAxNode.addListener(() {
      setState(() {
        clearMax = _focusMAxNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusMinNode.dispose();
    _focusMAxNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16),
        Expanded(
          child: TextField(
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
            controller: controller.sizeMinTemp,
            focusNode: _focusMinNode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "No min",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffix: clearMin
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          controller.sizeMinTemp.clear();
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 15,
                            color: Colors.white,
                          )),
                    )
                  : null,
            ),
          ),
        ),
        Container(width: 15),
        Expanded(
          child: TextField(
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
            controller: controller.sizeMaxTemp,
            focusNode: _focusMAxNode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "No max",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffix: clearMax
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          controller.sizeMaxTemp.clear();
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 15,
                            color: Colors.white,
                          )),
                    )
                  : null,
            ),
          ),
        ),
        Container(width: 16),
      ],
    );
  }
}

class YearBuilt extends StatefulWidget {
  const YearBuilt({Key? key}) : super(key: key);

  @override
  _RentYearBuiltState createState() => _RentYearBuiltState();
}

class _RentYearBuiltState extends State<YearBuilt> {
  FilterController controller = Get.put(FilterController());

  final FocusNode _focusMinNode = FocusNode();
  final FocusNode _focusMAxNode = FocusNode();
  bool clearMin = false;
  bool clearMax = false;

  @override
  void initState() {
    super.initState();
    _focusMinNode.addListener(() {
      setState(() {
        clearMin = _focusMinNode.hasFocus;
      });
    });
    _focusMAxNode.addListener(() {
      setState(() {
        clearMax = _focusMAxNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusMinNode.dispose();
    _focusMAxNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 16),
        Expanded(
          child: TextField(
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
            controller: controller.yearBuiltMinTemp,
            focusNode: _focusMinNode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "No min",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffix: clearMin
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          controller.yearBuiltMinTemp.clear();
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 15,
                            color: Colors.white,
                          )),
                    )
                  : null,
            ),
          ),
        ),
        Container(width: 15),
        Expanded(
          child: TextField(
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
            controller: controller.yearBuiltMaxTemp,
            focusNode: _focusMAxNode,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "No max",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              suffix: clearMax
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          controller.yearBuiltMax.clear();
                        });
                      },
                      child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 15,
                            color: Colors.white,
                          )),
                    )
                  : null,
            ),
          ),
        ),
        Container(width: 16),
      ],
    );
  }
}
