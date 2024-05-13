import 'package:client/data/contracts.dart';
import 'package:client/model/contract.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContractsController extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  String contractStatus = "All";
  String contractType = "All";
  String contractTo = "Landlord";
  int userId = 1;
  List<Contract> userContracts = [];
  List<Contract> lawyerContracts = [];
  Contract? contractIsCreated;
  String responseMessage = "";

  Contract? currentContract;
  bool visitLawyerFromContract = true;

  getContrcatsForUser() async {
    var response = await ContractsData.getContrcatsForUser(
      userId,
      contractStatus,
      contractType,
      contractTo,
    );
    if (response is Map<String, dynamic>) {
      if (response['statusCode'] == 200) {
        userContracts = (response['listDto'] as List<dynamic>)
            .map((e) => Contract.fromJson(e as Map<String, dynamic>))
            .toList();
        print(userContracts);
      } else {
        Get.defaultDialog(
          title: "Error",
          middleText:
              "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
        );
      }
    }
  }

  getContrcatsForLawyer() async {
    var response = await ContractsData.getContrcatsForLawyer(
      userId,
      contractStatus,
      contractType,
    );

    print(response);
    if (response is Map<String, dynamic>) {
      if (response['statusCode'] == 200) {
        lawyerContracts = (response['listDto'] as List<dynamic>)
            .map((e) => Contract.fromJson(e as Map<String, dynamic>))
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

  getContractForOffer(int offerId) async {
    var response = await ContractsData.getContractForOffer(offerId);

    if (response['statusCode'] == 200) {
      if (response['dto'] != null) {
        contractIsCreated =
            Contract.fromJson(response['dto'] as Map<String, dynamic>);
      }
      responseMessage = response['message'];
      print(responseMessage);
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  addLawyerToContract(int contractId, int lawyerId) async {
    var response =
        await ContractsData.addLawyerToContract(contractId, lawyerId);

    print(response);
    if (response is Map<String, dynamic>) {
      if (response['statusCode'] == 200) {
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
}
