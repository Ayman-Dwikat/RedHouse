import 'package:client/controller/contract/offer_controller.dart';
import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/core/functions/validInput.dart';
import 'package:client/model/property.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateOffer extends StatefulWidget {
  int landlordId;
  int customerId;
  Property property;

  CreateOffer({
    Key? key,
    required this.landlordId,
    required this.customerId,
    required this.property,
  }) : super(key: key);

  @override
  _CreateOfferState createState() => _CreateOfferState();
}

class _CreateOfferState extends State<CreateOffer> {
  OfferController offerController = Get.put(OfferController());
  LoginControllerImp loginController = Get.put(LoginControllerImp());
  String message = "";
  String priceError = "";
  String descriptionError = "";

  @override
  void initState() {
    super.initState();
    offerController.price.text = "";
    offerController.offerExpireDate = DateTime.now();
    offerController.description.text = "";
  }

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
        offerController.offerExpireDate = pickedDate;
      });
    }
  }

  String hintText() {
    if (widget.property.listingType == "For rent") {
      return "Enter the monthly rental price";
    } else {
      return "Enter the buy price";
    }
  }

  String suffixText() {
    if (widget.property.listingType == "For rent") {
      return '\$/mo';
    } else {
      return "\$";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Create Offer",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: offerController.formstate,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 20),

                  // Offer Expire Date
                  const Text(
                    "Offer Expire Date",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(height: 5),
                  InkWell(
                    onTap: _selectDateAvialableOn,
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateFormat('yyyy-MM-dd')
                                  .format(offerController.offerExpireDate)),
                              IconButton(
                                onPressed: _selectDateAvialableOn,
                                icon: const Icon(Icons.date_range_outlined),
                              )
                            ],
                          ),
                        )),
                  ),

                  Container(height: 20),

                  // Price
                  const Text(
                    "Price",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  Container(height: 5),
                  TextFormField(
                    validator: (val) {
                      priceError = validInput(val!, 1, 100, "price");
                      return priceError.isNotEmpty ? priceError : null;
                    },
                    controller: offerController.price,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      hintText: widget.property.listingType == "For rent"
                          ? "Enter the monthly rental price"
                          : "Enter the buy price",
                      suffixText: widget.property.listingType == "For rent"
                          ? '\$/mo '
                          : "\$ ",
                      suffixStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Container(height: 20),

                  // Description (Optional)
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
                    controller: offerController.description,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      hintText:
                          "Example: New house in the center of the city, there is close school and very beautiful view",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              Container(height: 25),
              MaterialButton(
                onPressed: () {
                  setState(() {});
                  if (offerController.formstate.currentState!.validate() &&
                      offerController.price.text.isNotEmpty &&
                      offerController.description.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).clearSnackBars();

                    Future<void> addOfferFuture() async {
                      offerController.userCreatedId =
                          loginController.userDto?["id"];
                      offerController.landlordId = widget.landlordId;
                      offerController.customerId = widget.customerId;
                      offerController.propertyId = widget.property.id;
                      await offerController.createOffer();

                      setState(() {
                        message = offerController.responseMessage;
                      });

                      if (message == "Created Successfully") {
                        SnackBar snackBar = SnackBar(
                          content: Text(message),
                          backgroundColor: Colors.blue,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.of(context).pop();
                      }
                    }

                    addOfferFuture();
                  }
                },
                color: const Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(height: 10),
              Container(
                padding: message == ""
                    ? null
                    : const EdgeInsets.only(top: 15, right: 12, left: 10),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
