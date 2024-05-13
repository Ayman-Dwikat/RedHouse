import 'dart:convert';
import 'package:client/controller/users_auth/signup_controller.dart';
import 'package:client/core/services/network_controller.dart';
import 'package:client/lawyer%20view/lawyer_bottom_bar.dart';
import 'package:client/middleware.dart';
import 'package:client/routes.dart';
import 'package:client/view/bottom_bar/bottom_bar.dart';
import 'package:client/view/more/verification/account_verification.dart';
import 'package:client/view/onboarding/welcoming.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:client/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

late SharedPreferences sharepref;

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  sharepref = await SharedPreferences.getInstance();
  // update user
  SignUpControllerImp controller =
      Get.put(SignUpControllerImp(), permanent: true);
  String? userJson = sharepref.getString("user");
  Map<String, dynamic>? userDto;
  userDto = userJson != null ? json.decode(userJson) : null;
  if (userDto != null) {
    int? id = userDto["id"] as int?;
    await controller.getUser(id!);
  }

  runApp(const MyApp());
  Get.put<NetworkController>(NetworkController(), permanent: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RedHouse',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        fontFamily: "Poppins",
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
      ),
      initialRoute: "/welcoming",
      routes: routes,
      getPages: [
        GetPage(
            name: "/welcoming",
            page: () => const Welcoming(),
            middlewares: [AuthMiddleWare()]),
        GetPage(name: "/bottom-bar", page: () => const BottomBar()),
        GetPage(
            name: "/lawyer-bottom-bar", page: () => const LawyerBottomBar()),
        GetPage(name: "/verification", page: () => const AccountVerification()),
      ],
    );
  }
}
