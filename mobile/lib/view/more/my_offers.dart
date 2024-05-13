import 'package:client/view/manage_properties/bookings/all_bookings.dart';
import 'package:client/view/manage_properties/offers/all_offers.dart';
import 'package:flutter/material.dart';

class MyOffers extends StatelessWidget {
  const MyOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Offers",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: const AllOffers(),
    );
  }
}
