import 'package:client/controller/propertise/properties_controller.dart';
import 'package:client/view/add_property/add_property_5.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProperty4 extends StatefulWidget {
  AddProperty4({Key? key}) : super(key: key);

  @override
  _AddProperty4State createState() => _AddProperty4State();
}

class _AddProperty4State extends State<AddProperty4>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<int> _textAnimation;

  @override
  void initState() {
    // Initialize AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    // Create a Tween for the animation
    _textAnimation = IntTween(
            begin: 0, end: "Enter more information about your property".length)
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
    const viewOptions = [
      "City",
      "Village",
      "Mountain",
      "Beach",
      "Island",
    ];
    const optionBool = ["Yes", "No"];

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
                      Get.to(() => AddProperty5());
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
          body: SingleChildScrollView(
            // physics: const NeverScrollableScrollPhysics(), // Disable scrolling
            child: Column(
              children: [
                controller.easyStepper(),
                Container(
                  margin:
                      const EdgeInsets.only(right: 15, left: 15, bottom: 25),
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
                                  "Enter more information about your property"
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

                        // Property price
                        Container(height: 25),
                        const Text(
                          "Property price",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(height: 5),
                        Container(
                          child: TextFormField(
                            controller: controller.price,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.money),
                              hintText: "Example: 2000",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding: const EdgeInsets.all(10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),

                        // Parking spots
                        Container(height: 30),
                        const Text(
                          "Parking spots",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(height: 5),
                        TextFormField(
                          controller: controller.parkingSpots,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.numbers),
                            hintText: "Example: 3",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        // Is available basement ?
                        Container(height: 30),
                        const Text(
                          "Is available basement ?",
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
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: DropdownButton<String>(
                            value: controller.isAvaliableBasement,
                            items: optionBool.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  controller.isAvaliableBasement = newValue;
                                });
                              }
                            },
                            isExpanded: true,
                            underline: const SizedBox(),
                          ),
                        ),

                        // Property view
                        Container(height: 30),
                        const Text(
                          "Property view",
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
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: DropdownButton<String>(
                            value: controller.view,
                            items: viewOptions.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  controller.view = newValue;
                                });
                              }
                            },
                            isExpanded: true,
                            underline: const SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
