import 'package:client/controller/bottom_bar/filter_controller.dart';
import 'package:client/controller/map_list/map_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Price extends StatefulWidget {
  Price({Key? key}) : super(key: key);

  @override
  _PriceState createState() => _PriceState();
}

class _PriceState extends State<Price> {
  MapListController mapListController = Get.put(MapListController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FilterController>(
      init: FilterController(),
      builder: (controller) => MaterialButton(
        onPressed: () {
          controller.maxControllerTemp.text = controller.maxController.text;
          controller.minControllerTemp.text = controller.minController.text;

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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    height: MediaQuery.of(context).viewInsets.bottom > 0
                        ? MediaQuery.of(context).size.height / 1.8
                        : MediaQuery.of(context).size.height / 3.5,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '  Price',
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
                            Container(height: 15),
                            const ReuseRowPrice()
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
                              if (controller.minControllerTemp.text != "" &&
                                  controller.maxControllerTemp.text != "" &&
                                  int.parse(controller.minControllerTemp.text) >
                                      int.parse(
                                          controller.maxControllerTemp.text)) {
                                Get.rawSnackbar(
                                  snackPosition: SnackPosition.TOP,
                                  messageText: const Text(
                                    'The Min limit cannot be greater than the Max limit',
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
                                controller.maxController.text =
                                    controller.maxControllerTemp.text;
                                controller.minController.text =
                                    controller.minControllerTemp.text;
                                controller.formatPriceRange();
                                controller.checkFiltersON();
                                controller.getProperties();
                                mapListController.isLoading = true;
                                Navigator.pop(context);
                              }
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
            width: controller.priceON ? 0 : 1.5,
          ),
        ),
        color: controller.priceON ? Colors.black : Colors.white,
        child: Text(
          controller.priceText,
          style: TextStyle(
            color: controller.priceON ? Colors.white : Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}

class ReuseRowPrice extends StatefulWidget {
  const ReuseRowPrice({Key? key}) : super(key: key);

  @override
  _RowRentPriceState createState() => _RowRentPriceState();
}

class _RowRentPriceState extends State<ReuseRowPrice> {
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
            controller: controller.minControllerTemp,
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
                          controller.minControllerTemp.clear();
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
            controller: controller.maxControllerTemp,
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
                          controller.maxControllerTemp.clear();
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
