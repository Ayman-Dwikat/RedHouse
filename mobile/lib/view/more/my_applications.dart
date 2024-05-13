import 'package:client/view/manage_properties/applications/all_applications.dart';
import 'package:flutter/material.dart';

class MyApplications extends StatelessWidget {
  const MyApplications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Applications",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: const AllApplications(),
    );
  }
}
