import 'package:client/controller/propertise/properties_controller.dart';
import 'package:client/view/add_property/add_property_6.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddProperty5 extends StatefulWidget {
  AddProperty5({Key? key}) : super(key: key);

  @override
  _AddProperty5State createState() => _AddProperty5State();
}

class _AddProperty5State extends State<AddProperty5>
    with SingleTickerProviderStateMixin {
  ManagePropertiesController controller =
      Get.put(ManagePropertiesController(), permanent: true);
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

  Future<void> _selectDateBuitYear() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: controller.builtYear,
      firstDate: DateTime.utc(1980, 1, 1),
      lastDate: DateTime.now(),
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
        controller.builtYear = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      Get.to(() => AddProperty6());
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

                      // Property space
                      Container(height: 25),
                      const Row(
                        children: [
                          Text(
                            "Property space",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            " (in meters)",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Container(height: 5),
                      TextFormField(
                        controller: controller.squareMeter,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.square_foot),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          contentPadding: const EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // Number of bedrooms
                      Container(height: 30),
                      const Text(
                        "Number of bedrooms",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(height: 5),
                      TextFormField(
                        controller: controller.numberOfBedrooms,
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

                      // Number of bathrooms
                      Container(height: 30),
                      const Text(
                        "Number of bathrooms",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      ),
                      Container(height: 5),
                      TextFormField(
                        controller: controller.numberOfBathrooms,
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

                      // Built year
                      const SizedBox(height: 30),
                      const Text(
                        "Built year",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.8),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: InkWell(
                          onTap: _selectDateBuitYear,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                controller.builtYear
                                    .toString()
                                    .substring(0, 10),
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                onPressed: _selectDateBuitYear,
                                icon: const Icon(Icons.date_range_outlined),
                              )
                            ],
                          ),
                        ),
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
