import 'package:client/controller/bottom_bar/filter_controller.dart';
import 'package:client/view/filter/bedbath_filter.dart';
import 'package:client/view/filter/filter_page.dart';
import 'package:client/view/filter/price_filter.dart';
import 'package:client/view/filter/propertytype_filter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterListView extends StatefulWidget {
  const FilterListView({super.key});

  @override
  State<FilterListView> createState() => _FilterListViewState();
}

class _FilterListViewState extends State<FilterListView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilterController>(
        init: FilterController(),
        builder: (controller) => Container(
              height: 37,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const Text("      "),
                  MaterialButton(
                      onPressed: () {
                        Get.to(() => FilterPage());
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(
                          color: const Color.fromARGB(255, 169, 169, 169),
                          width: controller.filtersON ? 0 : 1.5,
                        ),
                      ),
                      color: controller.filtersON ? Colors.black : Colors.white,
                      child: Row(
                        children: [
                          Icon(
                            Icons.tune,
                            size: 19,
                            color: controller.filtersON
                                ? Colors.white
                                : Colors.black,
                          ),
                          Text(
                            " Filters",
                            style: TextStyle(
                              color: controller.filtersON
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      )),
                  const Text("   "),
                  Price(),
                  const Text("   "),
                  const BedBath(),
                  const Text("   "),
                  const PropertyType(),
                  const Text("      "),
                ],
              ),
            ));
  }
}
