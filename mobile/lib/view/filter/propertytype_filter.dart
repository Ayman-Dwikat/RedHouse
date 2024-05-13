import 'package:client/controller/bottom_bar/filter_controller.dart';
import 'package:client/controller/map_list/map_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PropertyType extends StatefulWidget {
  const PropertyType({Key? key}) : super(key: key);

  @override
  _PropertyTypeState createState() => _PropertyTypeState();
}

class _PropertyTypeState extends State<PropertyType> {
  FilterController controller = Get.put(FilterController());
  MapListController mapListController = Get.put(MapListController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilterController>(
      init: FilterController(),
      builder: (controller) {
        return MaterialButton(
          onPressed: () {
            controller.houseTemp = controller.house;
            controller.apartmentTemp = controller.apartment;
            controller.townhouseTemp = controller.townhouse;
            controller.castleTemp = controller.castle;
            controller.departmentTemp = controller.department;

            showModalBottomSheet(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(30))),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      height: MediaQuery.of(context).size.height / 1.76,
                      child: Column(
                        children: [
                          const ReusePropertType(),
                          Container(
                            width: 340,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () {
                                controller.house = controller.houseTemp;
                                controller.apartment = controller.apartmentTemp;
                                controller.townhouse = controller.townhouseTemp;
                                controller.castle = controller.castleTemp;
                                controller.department = controller.departmentTemp;
                                controller.formatPropertyTypes();
                                controller.checkFiltersON();
                                controller.getProperties();
                                mapListController.isLoading = true;
                                Navigator.pop(context);
                              },
                              minWidth: 300,
                              height: 45,
                              color: Colors.black87,
                              child: const Center(
                                child: Text(
                                  "See  homes",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
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
            );
          },
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(
              color: Colors.grey,
              width: controller.propertyTypeON ? 0 : 1.5,
            ),
          ),
          color: controller.propertyTypeON ? Colors.black : Colors.white,
          child: Container(
            width: 121,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                controller.propertyTypeText,
                style: TextStyle(
                  color: controller.propertyTypeON ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      }
    );
  }
}

class ReusePropertType extends StatefulWidget {
  const ReusePropertType({Key? key}) : super(key: key);

  @override
  State<ReusePropertType> createState() => _BuyPropertTypeState();
}

class _BuyPropertTypeState extends State<ReusePropertType> {
  FilterController controller = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PropertyTypeSheetHeading(),
        Container(height: 5),
        CheckboxListTile(
          title: Text(
            "House",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          value: controller.houseTemp,
          onChanged: (value) {
            setState(() {
              controller.houseTemp = value!;
            });
          },
          activeColor: const Color.fromARGB(255, 11, 93, 161),
        ),
        CheckboxListTile(
          title: Text(
            "Apartment Unit",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          value: controller.apartmentTemp,
          onChanged: (value) {
            setState(() {
              controller.apartmentTemp = value!;
            });
          },
          activeColor: const Color.fromARGB(255, 11, 93, 161),
        ),
        CheckboxListTile(
          title: Text(
            "Townhouse",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          value: controller.townhouseTemp,
          onChanged: (value) {
            setState(() {
              controller.townhouseTemp = value!;
            });
          },
          activeColor: const Color.fromARGB(255, 11, 93, 161),
        ),
        CheckboxListTile(
          title: Text(
            "Castle",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          value: controller.castleTemp,
          onChanged: (value) {
            setState(() {
              controller.castleTemp = value!;
            });
          },
          activeColor: const Color.fromARGB(255, 11, 93, 161),
        ),
        CheckboxListTile(
          title: Text(
            "Entire Department",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          value: controller.departmentTemp,
          onChanged: (value) {
            setState(() {
              controller.departmentTemp = value!;
            });
          },
          activeColor: const Color.fromARGB(255, 11, 93, 161),
        ),
        Container(height: 15),
      ],
    );
  }
}

class PropertyTypeSheetHeading extends StatelessWidget {
  const PropertyTypeSheetHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '  Property type',
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 27),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
