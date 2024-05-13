import 'dart:convert';

import 'package:client/controller/users_auth/login_controller.dart';
import 'package:client/main.dart';
import 'package:client/view/more/upgrade/payment.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AccountUpgrade extends StatefulWidget {
  const AccountUpgrade({Key? key}) : super(key: key);

  @override
  State<AccountUpgrade> createState() => _AccountUpgradeState();
}

class _AccountUpgradeState extends State<AccountUpgrade>
    with AutomaticKeepAliveClientMixin {
  int selectedCardIndex = 0; // Track the index of the selected card
  Map<String, dynamic> userDto = json.decode(sharepref.getString("user")!);

  @override
  bool get wantKeepAlive => true; // Keep the state alive

  @override
  void initState() {
    if (userDto["userRole"] == "Customer") {
      selectedCardIndex = 1;
    } else if (userDto["userRole"] == "Landlord") {
      selectedCardIndex = 2;
    } else if (userDto["userRole"] == "Agent") {
      selectedCardIndex = 3;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return VisibilityDetector(
      key: const Key('accountupgrade'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          userDto = json.decode(sharepref.getString("user")!);
          if (userDto["userRole"] == "Customer") {
            selectedCardIndex = 1;
          } else if (userDto["userRole"] == "Landlord") {
            selectedCardIndex = 2;
          } else if (userDto["userRole"] == "Agent") {
            selectedCardIndex = 3;
          }
          setState(() {});
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Account Upgrade",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CardWidget(
                      index: 0,
                      selectedCardIndex: selectedCardIndex,
                      isSelected: selectedCardIndex == 0,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CardWidget(
                      index: 1,
                      selectedCardIndex: selectedCardIndex,
                      isSelected: selectedCardIndex == 1,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CardWidget(
                      index: 2,
                      selectedCardIndex: selectedCardIndex,
                      isSelected: selectedCardIndex == 2,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: CardWidget(
                      index: 3,
                      selectedCardIndex: selectedCardIndex,
                      isSelected: selectedCardIndex == 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final int index;
  final int selectedCardIndex;
  final bool isSelected;

  const CardWidget({
    required this.index,
    required this.selectedCardIndex,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    String cardType = _getCardType(index);
    String price = _getCardPrice(index);
    List<String> features = _getCardFeatures(index);
    bool showPaymentButton = _shouldShowPaymentButton(index) && !isSelected;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.red : Colors.grey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            cardType,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            price,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features
                .map(
                  (feature) => Column(
                    children: [
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          const Icon(
                            FontAwesomeIcons.check,
                            color: Colors.green,
                            size: 18,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            feature,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                    ],
                  ),
                )
                .toList(),
          ),
          if (showPaymentButton)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  Get.to(() => Payment(
                        selectedCardIndex: index,
                      ));
                },
                minWidth: 200,
                height: 40,
                color: Colors.black87,
                child: const Text(
                  "Payment",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getCardType(int index) {
    switch (index) {
      case 0:
        return 'Basic Account (Free)';
      case 1:
        return 'Customer Sub';
      case 2:
        return 'Landlord Sub';
      case 3:
        return 'Agent Sub';
      default:
        return '';
    }
  }

  String _getCardPrice(int index) {
    switch (index) {
      case 0:
        return 'Included';
      case 1:
        return '\$200';
      case 2:
        return '\$500';
      case 3:
        return '\$1000';
      default:
        return '';
    }
  }

  List<String> _getCardFeatures(int index) {
    switch (index) {
      case 0:
        return [
          'Basic features',
          'Limited storage',
          'No experience',
          'Priority support'
        ];
      case 1:
        return [
          'Access to basic features',
          'Limited access to advanced\nfeatures',
          'Little experience',
          'Priority support'
        ];
      case 2:
        return [
          'Access to more advanced\nfeatures',
          'Preferred by landlords',
          'Greater experience',
          'Priority support',
        ];
      case 3:
        return [
          'Access to all features',
          'Highly sought after by users',
          'People are looking for him',
          'Extensive experience',
          'Priority support',
        ];
      default:
        return [];
    }
  }

  bool _shouldShowPaymentButton(int index) {
    if (index == 0) {
      return false;
    }

    if (selectedCardIndex == 3) {
      return false;
    } else if (selectedCardIndex == 2) {
      if (index == 3) {
        return true;
      } else {
        return false;
      }
    } else if (selectedCardIndex == 1) {
      if (index == 1) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}
