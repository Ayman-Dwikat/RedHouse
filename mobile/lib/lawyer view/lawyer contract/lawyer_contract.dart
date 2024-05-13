import 'package:client/controller/contract/contracts_controller.dart';
import 'package:client/lawyer%20view/lawyer%20contract/lawyer_details.dart';
import 'package:client/lawyer%20view/lawyer%20contract/lawyer_overview.dart';
import 'package:client/model/contract.dart';
import 'package:client/view/contracts/landlord%20contract/landlord_details.dart';
import 'package:client/view/contracts/landlord%20contract/landlord_overview.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LawyerContract extends StatefulWidget {
  Contract contract;
  LawyerContract({Key? key, required this.contract}) : super(key: key);

  @override
  State<LawyerContract> createState() => _LandlordContractState();
}

class _LandlordContractState extends State<LawyerContract>
    with AutomaticKeepAliveClientMixin {
  ContractsController controller =
      Get.put(ContractsController(), permanent: true);

  @override
  bool get wantKeepAlive => true; // Keep the state alive

  @override
  void initState() {
    super.initState();
    print(widget.contract);
    print(controller.currentContract);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return VisibilityDetector(
      key: const Key('LandlordContract'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction == 1) {
          widget.contract = controller.currentContract!;
          setState(() {});
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Contract",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            PopupMenuButton<String>(
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'Option 1',
                    child: Text('Request customer  to pay'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Option 2',
                    child: Text('Request public feedback'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Option 3',
                    child: Text('Add lawyer'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Option 4',
                    child: Text('Send message to customer'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Option 5',
                    child: Text('Send message to lawyer'),
                  ),
                ];
              },
              icon: const Icon(Icons.more_vert_outlined, color: Colors.white),
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 25),
                Expanded(
                    child: ListTile(
                  title: Text(
                    widget.contract.offer!.landlord!.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Landlord"),
                )),
                Expanded(
                    child: ListTile(
                  title: Text(
                    widget.contract.offer!.customer!.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Customer"),
                )),
              ],
            ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: Scaffold(
                  appBar: TabBar(
                    tabs: const [
                      Tab(child: Text("Overview")),
                      Tab(child: Text("Details")),
                    ],
                    overlayColor: MaterialStatePropertyAll(Colors.grey[350]),
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                    unselectedLabelColor: Colors.grey[700],
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 17,
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      Center(child: LawyerOverview(contract: widget.contract)),
                      Center(child: LawyerDetails(contract: widget.contract)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
