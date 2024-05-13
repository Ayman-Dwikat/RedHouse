import 'package:client/controller/contract/contracts_controller.dart';
import 'package:client/controller/contract/milestone_controller.dart';
import 'package:client/model/contract.dart';
import 'package:client/model/contractActivity.dart';
import 'package:client/view/contracts/feedback.dart';
import 'package:client/view/home_information/home_information.dart';
import 'package:client/view/lawyer%20seach/lawyer_search.dart';
import 'package:client/view/manage_properties/home_widget.dart';
import 'package:client/view/manage_properties/offers/incoming_offer.dart';
import 'package:client/view/manage_properties/offers/sent_offer.dart';
import 'package:client/view/messages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:client/view/contracts/feedback.dart' as CustomFeedback;

class CustomerDetails extends StatefulWidget {
  final Contract contract;
  const CustomerDetails({Key? key, required this.contract}) : super(key: key);
  @override
  _LandlordDetailsState createState() => _LandlordDetailsState();
}

class _LandlordDetailsState extends State<CustomerDetails> {
  bool showMoreSummary = false;
  String summaryString = "Show more";
  StepperType stepperType = StepperType.vertical;
  ContractsController controller =
      Get.put(ContractsController(), permanent: true);
  MilestoneControllerImp milestonesController =
      Get.put(MilestoneControllerImp());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print(widget.contract);
    print(controller.currentContract);
  }

  String divideCodeIntoGroups(String code) {
    final RegExp pattern = RegExp(r".{1,3}");
    Iterable<Match> matches = pattern.allMatches(code);
    List<String> groups = matches.map((match) => match.group(0)!).toList();
    return groups.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Messgaes Landlord
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        receiverUserEmail:
                            widget.contract.offer!.landlord!.email!,
                        receiverUserID:
                            widget.contract.offer!.landlord!.id.toString(),
                        onMessageSent: () {
                          if (mounted) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  );
                },
                child: Row(
                  children: [
                    const SizedBox(width: 25),
                    Expanded(
                      child: ListTile(
                        title: Text(
                          widget.contract.offer!.landlord!.name!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text("Landlord"),
                      ),
                    ),
                    const Icon(
                      FontAwesomeIcons.solidComment,
                      size: 28,
                    ),
                    const SizedBox(width: 25),
                  ],
                ),
              ),

              // Messgaes Lawyer
              if (widget.contract.lawyer == null)
                InkWell(
                  onTap: () {
                    showSearch(
                      context: context,
                      delegate: LawyerSearch(),
                    );
                  },
                  child: const Row(
                    children: [
                      SizedBox(width: 25),
                      Expanded(
                          child: ListTile(
                        title: Text(
                          "Add Lawyer",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Click to add a lawyer to the contract"),
                      )),
                      Icon(
                        FontAwesomeIcons.add,
                        size: 28,
                      ),
                      SizedBox(width: 25),
                    ],
                  ),
                )
              else
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          receiverUserEmail: widget.contract.lawyer!.email!,
                          receiverUserID: widget.contract.lawyer!.id.toString(),
                          onMessageSent: () {
                            if (mounted) {
                              setState(() {});
                            }
                          },
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      const SizedBox(width: 25),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            widget.contract.lawyer!.name!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text("Lawyer"),
                        ),
                      ),
                      const Icon(
                        FontAwesomeIcons.solidComment,
                        size: 28,
                      ),
                      const SizedBox(width: 25),
                    ],
                  ),
                ),

              // isShouldPay
              if (widget.contract.isShouldPay == 1)
                Container(
                  margin: const EdgeInsets.all(15),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 0,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "The landlord asks you to give a feedback",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffd92328),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "The landlord asks you to pay",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffd92328),
                        ),
                      ),
                    ],
                  ),
                ),

              // Status
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(children: [
                  Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Contarct Status",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: const Text(
                                "Contract status",
                                style: TextStyle(fontSize: 16),
                              )),
                        ],
                      ),
                      Text(
                        widget.contract.contractStatus,
                        style: const TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.black,
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: const Text(
                                "Start date",
                                style: TextStyle(fontSize: 16),
                              )),
                        ],
                      ),
                      Text(
                        widget.contract.startDate.toString().substring(0, 11),
                        style: const TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  if (widget.contract.endDate != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.black,
                            ),
                            Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: const Text(
                                  "Start date",
                                  style: TextStyle(fontSize: 16),
                                )),
                          ],
                        ),
                        Text(
                          widget.contract.endDate.toString().substring(0, 11),
                          style: const TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                ]),
              ),

              // Summary
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(children: [
                  Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Summary",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: const Text(
                                "Contract type",
                                style: TextStyle(fontSize: 15),
                              )),
                        ],
                      ),
                      Text(widget.contract.contractType)
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.black,
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: const Text(
                                "Total price",
                                style: TextStyle(fontSize: 15),
                              )),
                        ],
                      ),
                      Text(widget.contract.offer!.price.toString())
                    ],
                  ),
                  showMoreSummary
                      ? Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Colors.black,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        child: const Text(
                                          "Customer",
                                          style: TextStyle(fontSize: 15),
                                        )),
                                  ],
                                ),
                                Text(widget.contract.offer!.customer!.name!)
                              ],
                            ),
                            if (widget.contract.lawyer != null)
                              Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Colors.black,
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 8),
                                              child: const Text(
                                                "Lawyer",
                                                style: TextStyle(fontSize: 15),
                                              )),
                                        ],
                                      ),
                                      Text(widget.contract.lawyer!.name!)
                                    ],
                                  ),
                                ],
                              ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Colors.black,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        child: const Text(
                                          "Property code",
                                          style: TextStyle(fontSize: 15),
                                        )),
                                  ],
                                ),
                                Text(divideCodeIntoGroups(widget
                                    .contract.offer!.property!.propertyCode))
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Colors.black,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        child: const Text(
                                          "Start date",
                                          style: TextStyle(fontSize: 15),
                                        )),
                                  ],
                                ),
                                Text(widget.contract.startDate
                                    .toString()
                                    .substring(0, 11))
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Colors.black,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        child: const Text(
                                          "Earnings",
                                          style: TextStyle(fontSize: 15),
                                        )),
                                  ],
                                ),
                                Text(widget.contract.earnings.toString())
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Colors.black,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        child: const Text(
                                          "Contract status",
                                          style: TextStyle(fontSize: 15),
                                        )),
                                  ],
                                ),
                                Text(widget.contract.contractStatus)
                              ],
                            ),
                            if (widget.contract.endDate != null)
                              Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            size: 8,
                                            color: Colors.black,
                                          ),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 8),
                                              child: const Text(
                                                "Start date",
                                                style: TextStyle(fontSize: 16),
                                              )),
                                        ],
                                      ),
                                      Text(
                                        widget.contract.endDate
                                            .toString()
                                            .substring(0, 11),
                                        style: const TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Colors.black,
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        child: Text(
                                          widget.contract.isShouldPay == 1
                                              ? "Landlord ask you to pay"
                                              : "Landlord not ask you to pay",
                                          style: const TextStyle(fontSize: 15),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container(),
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        showMoreSummary = !showMoreSummary;
                      });
                    },
                    child: Container(
                        width: 500,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 25),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          !showMoreSummary ? "Show more" : "Show less",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        )),
                  )
                ]),
              ),

              // Description
              Container(
                margin: const EdgeInsets.all(15), // Adjust the margin as needed
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(children: [
                  Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )),
                  Container(
                    height: 15,
                  ),
                  Container(
                    child: Text(
                      widget.contract.offer!.description,
                      style: const TextStyle(fontSize: 15.5),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (widget.contract.offer!.landlordId ==
                          widget.contract.offer!.userCreatedId) {
                        Get.to(() => SentOffer(offer: widget.contract.offer!));
                      } else {
                        Get.to(
                            () => IncomingOffer(offer: widget.contract.offer!));
                      }
                    },
                    child: Container(
                        width: 500,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Text(
                          "View original offer",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Get.to(() => HomeWidget(
                          property: widget.contract.offer!.property!));
                    },
                    child: Container(
                        width: 500,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: BorderRadius.circular(15)),
                        child: const Text(
                          "View property",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        )),
                  ),
                ]),
              ),

              // Recent Activity
              Container(
                margin: const EdgeInsets.all(15), // Adjust the margin as needed
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(children: [
                  Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Recent Activity",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )),
                  Container(
                    height: 15,
                  ),
                  Row(children: [
                    Container(
                        margin: const EdgeInsets.only(right: 68),
                        child: const Text("Date")),
                    const Text("Description")
                  ]),
                  Container(
                    height: 0.8,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    color: const Color.fromARGB(255, 80, 80, 80),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 30),
                                    child: Text(
                                      activities[index]
                                          .activityDate
                                          .toString()
                                          .substring(0, 10),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        activities[index].activityDescription,
                                        softWrap: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (activities.length - 1 != index)
                              Container(
                                height: 0.8,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                color: const Color.fromARGB(255, 80, 80, 80),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ]),
              ),

              // Feedback
              Container(
                margin: const EdgeInsets.all(15), // Adjust the margin as needed
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(children: [
                  Container(
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Feedback",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      )),
                  Container(height: 15),
                  if (widget.contract.lawyer != null)
                    Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "You can provide feedback about the customer and the lawyer, and you can ask them to provide feedback",
                          style: TextStyle(fontSize: 15),
                        ))
                  else
                    Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "You can provide feedback about the customer, and you can ask he to provide feedback",
                          style: TextStyle(fontSize: 15),
                        )),
                  Container(height: 30),
                  const Icon(
                    Icons.feed_rounded,
                    size: 50,
                  ),
                  Container(height: 5),
                  MaterialButton(
                    onPressed: () {
                      Get.to(() => CustomFeedback.Feedback(
                            contractId: widget.contract.id,
                            userId: widget.contract.offer!.landlordId,
                          ));
                    },
                    child: Container(
                      width: 500,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 7),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text(
                        "Give feedback about the landlord",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Get.to(() => CustomFeedback.Feedback(
                            contractId: widget.contract.id,
                            userId: widget.contract.lawyerId!,
                          ));
                    },
                    child: Container(
                      width: 500,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 7),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(15)),
                      child: const Text(
                        "Give feedback about the lawyer",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      await milestonesController.updateShouldPay(
                          widget.contract.id, 1);
                    },
                    child: Container(
                      width: 500,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Text(
                        "Ask for feedback",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                ]),
              ),
              Container(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}

List<ContractActivity> activities = [
  ContractActivity(
      id: 1,
      contractId: 1,
      activityDate: DateTime(2023, 11, 1),
      activityDescription: "The customer create new milestone 'Monthy Boills'"),
  ContractActivity(
      id: 1,
      contractId: 1,
      activityDate: DateTime(2023, 11, 1),
      activityDescription:
          "The customer create new milestone This contract doesn’t have any feedback right nowThis contract doesn’t have any feedback right now"),
  ContractActivity(
      id: 1,
      contractId: 1,
      activityDate: DateTime(2023, 11, 1),
      activityDescription:
          "The landlord approved the new milestone, status paid"),
  ContractActivity(
      id: 1,
      contractId: 1,
      activityDate: DateTime(2023, 11, 4),
      activityDescription: "The landlord ask customer to pay "),
  ContractActivity(
      id: 1,
      contractId: 1,
      activityDate: DateTime(2023, 11, 4),
      activityDescription:
          "The contract not done, the customer did not pay all the price, status is active"),
  ContractActivity(
      id: 1,
      contractId: 1,
      activityDate: DateTime(2023, 11, 4),
      activityDescription: "The landlord ask to give feedback"),
  ContractActivity(
      id: 1,
      contractId: 1,
      activityDate: DateTime(2023, 11, 6),
      activityDescription: "The landlord reject new milestone"),
  ContractActivity(
      id: 1,
      contractId: 1,
      activityDate: DateTime(2023, 11, 12),
      activityDescription:
          "The contract done, the customer paid the dues in full, status is closed"),
  ContractActivity(
      id: 1,
      contractId: 1,
      activityDate: DateTime(2023, 11, 20),
      activityDescription: "The customer give feedback"),
];
