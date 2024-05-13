import 'package:client/controller/propertise/properties_controller.dart';
import 'package:client/view/add_property/add_property_4.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProperty2 extends StatefulWidget {
  AddProperty2({Key? key}) : super(key: key);

  @override
  _AddProperty2State createState() => _AddProperty2State();
}

class _AddProperty2State extends State<AddProperty2>
    with SingleTickerProviderStateMixin {
  ManagePropertiesController propertyController =
      Get.put(ManagePropertiesController());

  late AnimationController _animationController;
  late Animation<int> _textAnimation;

  @override
  void initState() {
    print(propertyController.propertyNeighborhoods);

    // Initialize AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // Create a Tween for the animation
    _textAnimation = IntTween(
            begin: 0, end: "Enter information about the property type".length)
        .animate(_animationController);

    // Start the animation
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const typeOptions = [
      "House",
      "Apartment Unit",
      "Townhouse",
      "Castle",
      "Entire Department"
    ];

    return GetBuilder<ManagePropertiesController>(
      init: ManagePropertiesController(),
      builder: (ManagePropertiesController controller) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  controller.decreaseActiveStep();
                  print(controller.activeStep);
                  Navigator.pop(context);
                });
              },
            ),
            title: const Text(
              "Add Property",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w600,
              ),
            ),
            actions: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        controller.increaseActiveStep();
                        print(controller.activeStep);
                      });
                      Get.to(() => AddProperty4());
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.5,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Body
          body: ListView(
            physics: const NeverScrollableScrollPhysics(), // Disable scrolling
            children: [
              controller.easyStepper(),
              Container(
                margin: const EdgeInsets.only(right: 15, left: 15, bottom: 25),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Introduction
                      Image.asset("assets/images/logo.png", scale: 11),
                      Container(
                        child: AnimatedBuilder(
                          animation: _textAnimation,
                          builder: (context, child) {
                            String animatedText =
                                "Enter information about the property type"
                                    .substring(0, _textAnimation.value);
                            return Text(
                              animatedText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            );
                          },
                        ),
                      ),

                      // Property type
                      Container(height: 25),
                      const Text(
                        "Property type",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          value: controller.propertyType,
                          items: typeOptions.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                controller.propertyType = newValue;
                              });
                            }
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),
                      ),

                      // Number of units
                      Container(height: 30),
                      const Row(
                        children: [
                          Text(
                            "Number of units",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            " (if needed)",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Container(height: 5),
                      TextFormField(
                        controller: controller.numberOfUnits,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.numbers),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // Listing type
                      Container(height: 35),
                      const Text(
                        "Listing type",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Column(
                        children: [
                          Container(height: 5),
                          RadioListTile(
                            dense: true, // Set to true to reduce the height
                            title: Text(
                              "For daily rent",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            value: "For daily rent",
                            groupValue: controller.listingType,
                            activeColor: const Color.fromARGB(255, 11, 93, 161),
                            onChanged: (value) {
                              setState(() {
                                controller.listingType = value.toString();
                              });
                            },
                          ),
                          RadioListTile(
                            dense: true, // Set to true to reduce the height
                            title: Text(
                              "For monthly rent",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            value: "For monthly rent",
                            groupValue: controller.listingType,
                            activeColor: const Color.fromARGB(255, 11, 93, 161),
                            onChanged: (value) {
                              setState(() {
                                controller.listingType = value.toString();
                              });
                            },
                          ),
                          RadioListTile(
                            dense: true, // Set to true to reduce the height
                            title: Text(
                              "For sell",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            value: "For sell",
                            groupValue: controller.listingType,
                            activeColor: const Color.fromARGB(255, 11, 93, 161),
                            onChanged: (value) {
                              setState(() {
                                controller.listingType = value.toString();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
