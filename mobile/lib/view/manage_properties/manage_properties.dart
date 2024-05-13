import 'package:client/view/manage_properties/applications/all_applications.dart';
import 'package:client/view/manage_properties/bookings/all_bookings.dart';
import 'package:client/view/manage_properties/offers/all_offers.dart';
import 'package:client/view/manage_properties/properties.dart';
import 'package:flutter/material.dart';

class ManageProperties extends StatefulWidget {
  const ManageProperties({super.key});

  @override
  State<ManageProperties> createState() => _TopNavigationBar();
}

/// AnimationControllers can be created with `vsync: this` because of TickerProviderStateMixin.
class _TopNavigationBar extends State<ManageProperties>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage Properties",
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const <Widget>[
            Tab(child: Text("Properties")),
            Tab(child: Text("Applications")),
            Tab(child: Text("Offers")),
            Tab(child: Text("Bookings")),
          ],
          overlayColor: MaterialStatePropertyAll(Colors.grey[700]),
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
          unselectedLabelColor: Colors.grey[400],
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 17,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          Center(child: Properties()),
          Center(child: AllApplications()),
          Center(child: AllOffers()),
          Center(child: AllBookings()),
        ],
      ),
    );
  }
}
