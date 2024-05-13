import 'dart:convert';
import 'package:client/data/applications.dart';
import 'package:client/model/application.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApplicationsController extends GetxController {
  List<Application> applications = [];
  List<Application> approvedApplicationsForUser = [];
  Application? applicationIsCreated;
  String responseMessage = "";

  String applicationType = "All";
  String applicationStatus = "All";
  String applicationTo = "Customer";

  int propertyId = 1;
  int userId = 1; // customer id
  DateTime applicationDate = DateTime.now();
  TextEditingController message = TextEditingController();
  String _applicationStatus = "Pendding";
  TextEditingController suggestedPrice = TextEditingController();

  addApplication() async {
    var response = await ApplicationData.addApplication(
      propertyId,
      userId,
      applicationDate,
      message.text,
      _applicationStatus,
      int.tryParse(suggestedPrice.text) ?? 0,
    );

    Map responsebody = json.decode(response.body);
    responseMessage = responsebody["message"];

    if (responsebody.length != 1) {
      if (responsebody['statusCode'] == 200) {
      } else {
        Get.defaultDialog(
          title: "Error",
          middleText:
              "statusCode: ${responsebody['statusCode']}, exceptions: ${responsebody['exceptions']}",
        );
      }
    }
  }

  getApplications(int userId) async {
    var response = await ApplicationData.getApplications(
        userId, applicationStatus, applicationType, applicationTo);

    if (response['statusCode'] == 200) {
      applications = (response['listDto'] as List<dynamic>)
          .map((e) => Application.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  approvedApplication(int id) async {
    var response = await ApplicationData.approvedApplication(id);
  }

  deleteApplication(int id) async {
    var response = await ApplicationData.deleteApplication(id);
  }

  // Get all approved applications for user, to open messages between customer and landlord
  getApprovedApplicationsForUser(int userId) async {
    var response = await ApplicationData.getApprovedApplicationsForUser(userId);

    if (response is Map<String, dynamic>) {
      if (response['statusCode'] == 200) {
        approvedApplicationsForUser = (response['listDto'] as List<dynamic>)
            .map((e) => Application.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        Get.defaultDialog(
          title: "Error",
          middleText:
              "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
        );
      }
    }
  }

  updateApplicationStatus(int applicationId, String newStatus) async {
    var response =
        await ApplicationData.updateApplicationStatus(applicationId, newStatus);

    if (response is Map<String, dynamic> && response['statusCode'] == 200) {
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  getApplicationForUser(int propertyId, int customerId) async {
    var response =
        await ApplicationData.getApplicationForUser(propertyId, customerId);

    if (response['statusCode'] == 200) {
      if (response['dto'] != null) {
        applicationIsCreated =
            Application.fromJson(response['dto'] as Map<String, dynamic>);
      }
      responseMessage = response['message'];
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }
}
