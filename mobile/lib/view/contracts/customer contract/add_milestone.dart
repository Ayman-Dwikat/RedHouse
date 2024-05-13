import 'package:client/controller/contract/milestone_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/core/functions/validInput.dart';
import 'package:client/model/contract.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddMilestone extends StatefulWidget {
  final Contract contract;
  const AddMilestone({Key? key, required this.contract}) : super(key: key);

  @override
  _AddMilestoneState createState() => _AddMilestoneState();
}

class _AddMilestoneState extends State<AddMilestone> {
  MilestoneControllerImp controller = Get.put(MilestoneControllerImp());
  LoginControllerImp loginController = Get.put(LoginControllerImp());

  String nameError = "";
  String amountError = "";
  String descriptionError = "";

  Future<void> _selectDateAvialableOn() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
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
        controller.milestoneDate = pickedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller.amount.text = "";
    controller.milestoneDate = DateTime.now();
    controller.milestoneName.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Add Milestone",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: controller.formstate,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 30),
                  const Text(
                    "Milestone Name",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(height: 5),
                  TextFormField(
                    validator: (val) {
                      nameError = validInput(val!, 4, 100, "price");
                      return nameError.isNotEmpty ? nameError : null;
                    },
                    controller: controller.milestoneName,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      hintText: "Milestone name",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(height: 5),
                  Container(height: 15),
                  const Text(
                    "Amount",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(height: 5),
                  TextFormField(
                    validator: (val) {
                      amountError = validInput(val!, 1, 100, "price");
                      return amountError.isNotEmpty ? amountError : null;
                    },
                    controller: controller.amount,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      hintText: "\$0.00",
                      suffixText: "\$ ",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(height: 5),
                  Container(height: 15),
                  const Text(
                    "Due Date",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(height: 5),
                  InkWell(
                    onTap: _selectDateAvialableOn,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.5,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              Text(DateFormat('yyyy-MM-dd')
                                  .format(controller.milestoneDate)),
                            ],
                          ),
                          IconButton(
                            onPressed: _selectDateAvialableOn,
                            icon: const Icon(Icons.date_range_outlined),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(height: 5),
                  Container(height: 15),
                  const Text(
                    "Description",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(height: 5),
                  TextFormField(
                    validator: (val) {
                      descriptionError =
                          validInput(val!, 10, 100, "description");
                      return descriptionError.isNotEmpty
                          ? descriptionError
                          : null;
                    },
                    minLines: 7,
                    maxLines: 10,
                    controller: controller.description,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      hintText:
                          "Example: The pre-agreed payment has been paid, the rest will be paid later",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(height: 5),
                ],
              ),
              Container(height: 25),
              MaterialButton(
                onPressed: () async {
                  setState(() {});
                  if (controller.formstate.currentState!.validate() &&
                      controller.milestoneName.text.isNotEmpty &&
                      controller.amount.text.isNotEmpty &&
                      controller.description.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    SnackBar snackBar = const SnackBar(
                      content: Text("Added Successfully"),
                      backgroundColor: Colors.blue,
                    );

                    await controller.addMilestone(widget.contract.id);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                height: 40,
                color: const Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
