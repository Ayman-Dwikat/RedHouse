import 'package:client/controller/contract/milestone_controller.dart';
import 'package:client/model/contract.dart';
import 'package:client/view/contracts/customer%20contract/add_milestone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CustomerOverview extends StatefulWidget {
  Contract contract;
  CustomerOverview({Key? key, required this.contract}) : super(key: key);
  @override
  _LandlordOverviewState createState() => _LandlordOverviewState();
}

class _LandlordOverviewState extends State<CustomerOverview>
    with AutomaticKeepAliveClientMixin {
  StepperType stepperType = StepperType.vertical;
  bool isLoading = true; // Add a boolean variable for loading state
  MilestoneControllerImp milestonesController =
      Get.put(MilestoneControllerImp());

  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {});
  }

  void loadData() async {
    await milestonesController.getAllMilestonesForContract(widget.contract.id);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return VisibilityDetector(
      key: const Key('CustomerOverview'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          loadData();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Earnings
                Container(
                  margin: const EdgeInsets.all(25),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(children: [
                    Container(
                        alignment: Alignment.topLeft,
                        child: const Text(
                          "Earnings",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    Container(height: 25),
                    StepProgressIndicator(
                      totalSteps: widget.contract.offer!.price,
                      currentStep: widget.contract.earnings.toInt(),
                      size: 10,
                      padding: 0,
                      selectedColor: Colors.yellow,
                      unselectedColor: Colors.cyan,
                      roundedEdges: const Radius.circular(10),
                      selectedGradientColor: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xffd92328), Color(0xffd92328)],
                      ),
                      unselectedGradientColor: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.grey, Colors.grey],
                      ),
                    ),
                    Container(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: Colors.black26,
                            ),
                            Text(
                              "    Total price",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${widget.contract.offer!.price}\$",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    Container(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.circle,
                              color: Colors.black26,
                            ),
                            Text(
                              "    Received",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "${widget.contract.earnings.toInt()}\$",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ]),
                ),

                // Milestone timeline
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  alignment: Alignment.center,
                  child: const Text(
                    'Milestone timeline',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 25, bottom: 25),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: milestonesController.milestones.length + 1,
                    itemBuilder: (context, index) {
                      return milestonesController.milestones.length != index
                          ? Container(
                              margin: const EdgeInsets.only(right: 25),
                              child: TimelineTile(
                                beforeLineStyle: LineStyle(
                                  color: milestonesController.milestones[index]
                                                  .milestoneStatus ==
                                              'Paid' ||
                                          milestonesController.milestones[index]
                                                  .milestoneStatus ==
                                              'Rejected'
                                      ? const Color(0xffd92328)
                                      : const Color.fromARGB(118, 60, 58, 58),
                                  thickness: 0.8,
                                ),

                                ////////////////////
                                indicatorStyle: IndicatorStyle(
                                  height: 20,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  indicatorXY: 0,
                                  color: milestonesController.milestones[index]
                                                  .milestoneStatus ==
                                              'Paid' ||
                                          milestonesController.milestones[index]
                                                  .milestoneStatus ==
                                              'Rejected'
                                      ? const Color(0xffd92328)
                                      : const Color.fromARGB(
                                          255, 211, 211, 211),
                                  width: 28,
                                  iconStyle: IconStyle(
                                    iconData: milestonesController
                                                .milestones[index]
                                                .milestoneStatus ==
                                            'Paid'
                                        ? Icons.done
                                        : milestonesController.milestones[index]
                                                    .milestoneStatus ==
                                                'Rejected'
                                            ? Icons.close
                                            : Icons.question_mark,
                                    color: milestonesController
                                                    .milestones[index]
                                                    .milestoneStatus ==
                                                'Paid' ||
                                            milestonesController
                                                    .milestones[index]
                                                    .milestoneStatus ==
                                                'Rejected'
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),

                                ////////////////////
                                endChild: Container(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 20),
                                  alignment: const Alignment(0.0, 0),
                                  child: Column(
                                    children: [
                                      Text(
                                        milestonesController
                                            .milestones[index].milestoneName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        milestonesController
                                            .milestones[index].description,
                                        style: const TextStyle(
                                          fontSize: 14.5,
                                        ),
                                      ),
                                      Container(height: 25),

                                      // Date
                                      Row(
                                        children: [
                                          Text(
                                            DateFormat('yyyy-MM-dd').format(
                                                DateTime.parse(
                                                    milestonesController
                                                        .milestones[index]
                                                        .milestoneDate)),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(height: 5),

                                      // price and status
                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            child: Text(
                                              "\$${milestonesController.milestones[index].amount}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Chip(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 7),
                                            shadowColor:
                                                const Color(0xffd92328),
                                            label: Text(
                                              milestonesController
                                                  .milestones[index]
                                                  .milestoneStatus,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            backgroundColor: Colors.white,
                                            labelStyle: const TextStyle(
                                              color: Color(0xffd92328),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 28,
                              margin: const EdgeInsets.only(top: 15),
                              child: TimelineTile(
                                isFirst: index == 0,
                                isLast: true,
                                beforeLineStyle: const LineStyle(
                                  color: Color.fromARGB(255, 42, 42, 42),
                                  thickness: 0.6,
                                ),
                                indicatorStyle: IndicatorStyle(
                                  color: const Color(0xffd92328),
                                  width: 28,
                                  iconStyle: IconStyle(
                                    iconData: Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                                endChild: Container(
                                  alignment: const Alignment(-1.0, 0),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      Get.to(AddMilestone(
                                          contract: widget.contract));
                                    },
                                    child: const Text(
                                      "Propose new milestone",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
