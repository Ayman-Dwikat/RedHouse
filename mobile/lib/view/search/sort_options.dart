import 'package:client/controller/map_list/map_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SortOptionsWidget extends StatefulWidget {
  final bool isListIcon;
  final int resultsCount;

  SortOptionsWidget({
    required this.isListIcon,
    required this.resultsCount,
  });

  @override
  _SortOptionsWidgetState createState() => _SortOptionsWidgetState();
}

class _SortOptionsWidgetState extends State<SortOptionsWidget> {
  MapListController controller = Get.put(MapListController());
  int _temporaryValue = 1;
  String selectedText = "Default";

  String getSelectedText(int selectedValue) {
    switch (selectedValue) {
      case 1:
        return "Default";
      case 2:
        return "Lowest price";
      case 3:
        return "Highest price";
      case 4:
        return "Lowest space";
      case 5:
        return "Highest space";
      default:
        return "Default";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: widget.isListIcon ? 0.0 : 55.5,
      child: Visibility(
        visible: !widget.isListIcon,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    right: 25, left: 25, bottom: 5, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      " ${controller.visibleProperties.length} results",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(30)),
                          ),
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(30)),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  height:
                                      MediaQuery.of(context).size.height / 1.8,
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                '  Sort by',
                                                style: TextStyle(
                                                    fontSize: 27,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.close,
                                                    color: Colors.black,
                                                    size: 27),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                          RadioListTile<int>(
                                            value: 1,
                                            groupValue: _temporaryValue,
                                            title: const Text("Default"),
                                            onChanged: (value) {
                                              setState(() {
                                                _temporaryValue = value!;
                                              });
                                            },
                                            activeColor: Colors.green,
                                          ),
                                          RadioListTile<int>(
                                            value: 2,
                                            groupValue: _temporaryValue,
                                            title: const Text("Lowest price"),
                                            onChanged: (value) {
                                              setState(() {
                                                _temporaryValue = value!;
                                              });
                                            },
                                            activeColor: Colors.green,
                                          ),
                                          RadioListTile<int>(
                                            value: 3,
                                            groupValue: _temporaryValue,
                                            title: const Text("Highest price"),
                                            onChanged: (value) {
                                              setState(() {
                                                _temporaryValue = value!;
                                              });
                                            },
                                            activeColor: Colors.green,
                                          ),
                                          RadioListTile<int>(
                                            value: 4,
                                            groupValue: _temporaryValue,
                                            title: const Text("Lowest space"),
                                            onChanged: (value) {
                                              setState(() {
                                                _temporaryValue = value!;
                                              });
                                            },
                                            activeColor: Colors.green,
                                          ),
                                          RadioListTile<int>(
                                            value: 5,
                                            groupValue: _temporaryValue,
                                            title: const Text("Highest space"),
                                            onChanged: (value) {
                                              setState(() {
                                                _temporaryValue = value!;
                                              });
                                            },
                                            activeColor: Colors.green,
                                          ),
                                        ],
                                      ),
                                      Container(height: 15),
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            controller.selectedValue =
                                                _temporaryValue;
                                            selectedText = getSelectedText(
                                                _temporaryValue);

                                            // Rearrange properties based on the selected value
                                            controller.rearrangeProperties();
                                          });
                                          Navigator.pop(context);
                                        },
                                        minWidth: 300,
                                        height: 45,
                                        color: Colors.black87,
                                        child: const Text(
                                          "Apply",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ).whenComplete(() {
                          setState(() {
                            _temporaryValue = controller.selectedValue;
                          });
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            selectedText,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1.0, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}
