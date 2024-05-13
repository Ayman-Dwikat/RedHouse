import 'dart:convert';
import 'package:client/data/offers.dart';
import 'package:client/model/offer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfferController extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  String offerTypeSelect = "All";
  String offerStatusSelect = "All";
  String offerToSelect = "Incoming";

  late List<Offer> userOffers;
  Offer? offerIsCreated;
  String responseMessage = "";

  int landlordId = 1;
  int userCreatedId = 1;
  int customerId = 1;
  int propertyId = 1;
  late TextEditingController description;
  DateTime offerExpireDate = DateTime.now();
  DateTime offerDate = DateTime.now();
  late TextEditingController price;
  late String offerStatus = "Pendding";

  @override
  void onInit() {
    description = TextEditingController();
    offerExpireDate = DateTime(2024);
    price = TextEditingController();
    super.onInit();
  }

  createOffer() async {
    var response = await OfferData.createOffer(
      userCreatedId,
      landlordId,
      customerId,
      propertyId,
      price.text,
      description.text,
      offerStatus,
      offerExpireDate,
      offerDate,
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

  getAllOffersForUser(int userId) async {
    var response = await OfferData.getAllOffersForUser(
        userId, offerStatusSelect, offerTypeSelect, offerToSelect);

    print(response);

    if (response['statusCode'] == 200) {
      userOffers = (response['listDto'] as List<dynamic>)
          .map((e) => Offer.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  acceptOffer(int offerId) async {
    var response = await OfferData.acceptOffer(offerId);
  }

  deleteOffer(int id) async {
    var response = await OfferData.deleteOffer(id);
  }

  getOfferForApplication(int propertyId, int landlordId, int customerId) async {
    var response =
        await OfferData.getOfferForApplication(propertyId, landlordId, customerId);

    if (response['statusCode'] == 200) {
      if (response['dto'] != null) {
        offerIsCreated = Offer.fromJson(response['dto'] as Map<String, dynamic>);
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
}
