import 'dart:convert';
import 'package:client/core/class/statusrequest.dart';
import 'package:client/core/functions/checkinternet.dart';
import 'package:client/link_api.dart';
import 'package:client/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class OfferData {
  static createOffer(
    int userCreatedId,
    int landlordId,
    int customerId,
    int propertyId,
    String price,
    String description,
    String offerStatus,
    DateTime offerExpireDate,
    DateTime offerDate,
  ) async {
    String formattedOfferExpireDate =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(offerExpireDate);
    String formattedOfferDate =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(offerDate);

    var data = {
      "userCreatedId": userCreatedId,
      "landlordId": landlordId,
      "customerId": customerId,
      "propertyId": propertyId,
      "price": int.tryParse(price) ?? 0,
      "description": description,
      "offerStatus": "Pending",
      "offerExpires": formattedOfferExpireDate,
      "offerDate": formattedOfferDate,
    };
    if (await checkInternet()) {
      var response = await http.post(Uri.parse(AppLink.offers),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $getToken()()'
          },
          body: json.encode(data),
          encoding: Encoding.getByName("utf-8"));
      return (response);
    } else {
      return (StatusRequest.offlinefailure);
    }
  }

  static getAllOffersForUser(int userId, String? offerStatus, String? offerType,
      String? offerTo) async {
    final Map<String, dynamic> filters = {
      "offerStatus": offerStatus,
      "offerType": offerType,
      "offerTo": offerTo,
    };

    if (await checkInternet()) {
      final Uri uri =
          Uri.https("10.0.2.2:7042", "/users/$userId/offers", filters);

      var response = await http.get(uri, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${getToken()}',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = json.decode(response.body);

        return (responsebody);
      } else {
        return StatusRequest.serverfailure;
      }
    } else {
      return StatusRequest.offlinefailure;
    }
  }

  static acceptOffer(int offerId) async {
    if (await checkInternet()) {
      var response = await http.post(
          Uri.parse('${AppLink.offers}/$offerId/accept'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${getToken()}',
          });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = json.decode(response.body);
        return (responsebody);
      } else {
        return StatusRequest.serverfailure;
      }
    } else {
      return StatusRequest.offlinefailure;
    }
  }

  static deleteOffer(int id) async {
    if (await checkInternet()) {
      var response = await http
          .delete(Uri.parse('${AppLink.offers}/$id'), headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${getToken()}',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = json.decode(response.body);
        return (responsebody);
      } else {
        return StatusRequest.serverfailure;
      }
    } else {
      return StatusRequest.offlinefailure;
    }
  }

  static getOfferForApplication(int propertyId, int landlordId, int customerId) async {
    final Map<String, dynamic> filters = {
      "propertyId": propertyId.toString(),
      "landlordId": landlordId.toString(),
      "customerId": customerId.toString(),
    };

    if (await checkInternet()) {
      final Uri uri = Uri.https("10.0.2.2:7042", "/offers/is-created", filters);

      var response = await http.get(uri, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${getToken()}',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = json.decode(response.body);

        return (responsebody);
      } else {
        return StatusRequest.serverfailure;
      }
    } else {
      return StatusRequest.offlinefailure;
    }
  }
}
