import 'dart:convert';
import 'package:client/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleWare extends GetMiddleware {
  Map<String, dynamic>? userDto;

  AuthMiddleWare() {
    String? userJson = sharepref.getString("user");
    userDto = userJson != null ? json.decode(userJson) : null;
  }

  @override
  RouteSettings? redirect(String? route) {
    if (sharepref.getString("first") != null) {
      if (userDto == null) {
        return const RouteSettings(name: "/bottom-bar");
      } else {
        if (userDto!["isVerified"] == true) {
          if (userDto!["userRole"] == "Lawyer") {
            return const RouteSettings(name: "/lawyer-bottom-bar");
          } else {
            return const RouteSettings(name: "/bottom-bar");
          }
        } else {
          return const RouteSettings(name: "/verification");
        }
      }
    }
    return null;
  }
}
