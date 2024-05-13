import 'package:client/controller/bottom_bar/filter_controller.dart';
import 'package:client/controller/map_list/map_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BedBath extends StatefulWidget {
  const BedBath({Key? key}) : super(key: key);

  @override
  _BedBathState createState() => _BedBathState();
}

class _BedBathState extends State<BedBath> {
  MapListController mapListController = Get.put(MapListController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilterController>(
        init: FilterController(),
        builder: (controller) {
          return MaterialButton(
            onPressed: () {
              controller.copyBathButtonTemp();
              controller.copyBedButtonTemp();

              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30))),
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30))),
                        height: MediaQuery.of(context).size.height / 1.95,
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '  Bed / Bath',
                                        style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close,
                                            color: Colors.black, size: 27),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(height: 10),
                                const ReuseBedBathRow(),
                              ],
                            ),
                            Container(height: 20),
                            Container(
                              width: 340,
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onPressed: () {
                                  controller.copyBathButton();
                                  controller.copyBedButton();
                                  controller.formatBedBath();
                                  controller.checkFiltersON();
                                  controller.getProperties();
                                  mapListController.isLoading = true;
                                  Navigator.pop(context);
                                },
                                minWidth: 300,
                                height: 45,
                                color: Colors.black87,
                                child: const Text(
                                  "See  homes",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
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
                width: controller.bedBathON ? 0 : 1.5,
              ),
            ),
            color: controller.bedBathON ? Colors.black : Colors.white,
            child: Text(
              controller.bedBathText,
              style: TextStyle(
                color: controller.bedBathON ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 17,
              ),
            ),
          );
        });
  }
}

class ReuseBedBathRow extends StatefulWidget {
  const ReuseBedBathRow({super.key});

  @override
  State<ReuseBedBathRow> createState() => _ReuseBedBathRowState();
}

class _ReuseBedBathRowState extends State<ReuseBedBathRow> {
  FilterController bedBathController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("    Bedrooms",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
              )),
          Container(
            height: 72,
            child: Obx(() {
              return ListView(
                scrollDirection: Axis.horizontal,
                children: bedBathController.bedroomLabels
                    .map((label) => bedroomButton(label, bedBathController))
                    .toList(),
              );
            }),
          ),
          Container(height: 25),
          const Text("    Bathrooms",
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w500,
              )),
          Container(
            height: 72,
            child: Obx(() {
              return ListView(
                scrollDirection: Axis.horizontal,
                children: bedBathController.bathroomLabels
                    .map((label) => bathroomButton(label, bedBathController))
                    .toList(),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget bedroomButton(String label, FilterController controller) {
    return Container(
      width: label == 'Studio+' ? 90 : 60,
      margin: label == 'Any'
          ? const EdgeInsets.only(top: 8, right: 8, bottom: 8, left: 27)
          : label == '5+'
              ? const EdgeInsets.only(top: 8, right: 27, bottom: 8, left: 8)
              : const EdgeInsets.all(8),
      child: MaterialButton(
        onPressed: () {
          controller.setBedButtonTemp(label);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: const BorderSide(
            color: Colors.black26,
            width: 1.5,
          ),
        ),
        color: controller.isBedButtonTemp(label) ? Colors.black : Colors.white,
        textColor:
            controller.isBedButtonTemp(label) ? Colors.white : Colors.grey[800],
        child: Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  Widget bathroomButton(String label, FilterController controller) {
    return Container(
      width: 60,
      margin: label == 'Any'
          ? const EdgeInsets.only(top: 8, right: 8, bottom: 8, left: 27)
          : label == '5+'
              ? const EdgeInsets.only(top: 8, right: 27, bottom: 8, left: 8)
              : const EdgeInsets.all(8),
      child: MaterialButton(
        onPressed: () {
          controller.setBathButtonTemp(label);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: const BorderSide(
            color: Colors.black26,
            width: 1.5,
          ),
        ),
        color: controller.isBathButtonTemp(label) ? Colors.black : Colors.white,
        textColor: controller.isBathButtonTemp(label)
            ? Colors.white
            : Colors.grey[800],
        child: Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
