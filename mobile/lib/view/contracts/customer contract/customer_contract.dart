import 'package:client/controller/contract/contracts_controller.dart';
import 'package:client/model/contract.dart';
import 'package:client/view/contracts/customer%20contract/customer_detalis.dart';
import 'package:client/view/contracts/customer%20contract/customer_overview.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CustomerContract extends StatefulWidget {
  Contract contract;
  CustomerContract({Key? key, required this.contract}) : super(key: key);

  @override
  State<CustomerContract> createState() => _LandlordContractState();
}

class _LandlordContractState extends State<CustomerContract>
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
      key: const Key('CustomerContract'),
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
                    child: Text('Proppose new contract'),
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
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.handshake,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(width: 25),
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
                      Center(
                          child: CustomerOverview(contract: widget.contract)),
                      Center(child: CustomerDetails(contract: widget.contract)),
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
