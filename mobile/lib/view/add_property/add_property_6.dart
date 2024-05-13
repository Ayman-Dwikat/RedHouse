import 'package:client/controller/propertise/properties_controller.dart';
import 'package:client/view/add_property/add_property_7.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProperty6 extends StatefulWidget {
  AddProperty6({Key? key}) : super(key: key);

  @override
  _AddProperty6State createState() => _AddProperty6State();
}

class _AddProperty6State extends State<AddProperty6>
    with SingleTickerProviderStateMixin {
  ManagePropertiesController controller =
      Get.put(ManagePropertiesController(), permanent: true);
  late AnimationController _animationController;
  late Animation<int> _textAnimation;

  Future<void> _selectDateAvialableOn() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.availableDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 20)),
      builder: (BuildContext context, Widget? child) {
         return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color.fromARGB(255, 196, 39, 27),
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child ?? Container(),
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        controller.availableDate = pickedDate;
      });
    }
  }

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
    final List<String> optionsStatus = [
      "Coming soon",
      "Accepting offers",
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
                      Get.to(() => AddProperty7());
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

                      // Property description
                      Container(height: 25),
                      const Text(
                        "Property description",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(height: 5),
                      Container(
                        child: TextFormField(
                          minLines: 5,
                          maxLines: 10,
                          controller: controller.propertyDescription,
                          style: const TextStyle(),
                          decoration: InputDecoration(
                            hintText:
                                "Example: New house in the center of the city, there is close school and very beautiful view",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),

                      // Property status
                      Container(height: 25),
                      const Text(
                        "Property status",
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
                          value: controller.propertyStatus,
                          items: optionsStatus.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              controller.propertyStatus = newValue ?? "";
                              controller.propertyStatus =
                                  controller.propertyStatus;
                            });
                          },
                          isExpanded: true,
                          underline: const SizedBox(),
                        ),
                      ),

                      // When is it available ?
                      if (controller.propertyStatus == "Coming soon")
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 25),
                            const Text(
                              "When is it available ?",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(height: 5),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.9),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: InkWell(
                                onTap: _selectDateAvialableOn,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.availableDate
                                          .toString()
                                          .substring(0, 10),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    IconButton(
                                      onPressed: _selectDateAvialableOn,
                                      icon:
                                          const Icon(Icons.date_range_outlined),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )

                      // Image
                      else
                        Column(
                          children: [
                            Container(height: 10),
                            Container(
                              alignment: Alignment.center,
                              child: Image.asset("assets/images/red-tree.png",
                                  scale: 2.9),
                            ),
                          ],
                        )
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
