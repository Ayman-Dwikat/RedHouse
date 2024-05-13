import 'dart:convert';
import 'package:client/core/class/statusrequest.dart';
import 'package:client/core/functions/checkinternet.dart';
import 'package:client/link_api.dart';
import 'package:client/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ContractsData {
  static getContrcatsForUser(
    int userId,
    String contractStatus,
    String contractType,
    String contractTo,
  ) async {
    final Map<String, dynamic> filters = {
      "contractStatus": contractStatus,
      "contractType": contractType,
      "contractTo": contractTo,
    };

    if (await checkInternet()) {
      try {
        final Uri uri =
            Uri.https("10.0.2.2:7042", "/users/$userId/contracts", filters);

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
      } catch (e) {
        return StatusRequest.serverfailure;
      }
    } else {
      return StatusRequest.offlinefailure;
    }
  }

  static getContrcatsForLawyer(
    int lawyerId,
    String contractStatus,
    String contractType,
  ) async {
    final Map<String, dynamic> filters = {
      "contractStatus": contractStatus,
      "contractType": contractType,
    };

    if (await checkInternet()) {
      try {
        final Uri uri =
            Uri.https("10.0.2.2:7042", "/lawyers/$lawyerId/contracts", filters);

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
      } catch (e) {
        return StatusRequest.serverfailure;
      }
    } else {
      return StatusRequest.offlinefailure;
    }
  }

  static getContractForOffer(int offerId) async {
    if (await checkInternet()) {
      final Uri uri = Uri.https("10.0.2.2:7042", "/contracts/offers/$offerId");

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

  static addLawyerToContract(int contractId, int lawyerId) async {
    if (await checkInternet()) {
      final Uri uri = Uri.https(
          "10.0.2.2:7042", "/contracts/$contractId/lawyers/$lawyerId");

      var response = await http.put(uri, headers: <String, String>{
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
