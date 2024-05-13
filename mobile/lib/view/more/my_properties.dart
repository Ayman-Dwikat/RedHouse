import 'package:client/view/manage_properties/properties.dart';
import 'package:flutter/material.dart';

class MyProperties extends StatelessWidget {
  const MyProperties({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Properties",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: const Properties(),
    );
  }
}
