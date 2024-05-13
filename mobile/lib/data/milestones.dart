import 'dart:convert';
import 'package:client/core/class/statusrequest.dart';
import 'package:client/core/functions/checkinternet.dart';
import 'package:client/link_api.dart';
import 'package:client/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class MilestoneData {
  static addMilestone(int contractId, String milestoneName, String description,
      DateTime milestoneDate, String amount, String milestoneStatus) async {
    String formattedmilestoneDate =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(milestoneDate);

    var data = {
      "contractId": contractId,
      "milestoneName": milestoneName,
      "description": description,
      "milestoneDate": formattedmilestoneDate,
      "amount": int.tryParse(amount) ?? 0,
      "milestoneStatus": "Pending"
    };
    if (await checkInternet()) {
      var response = await http.post(Uri.parse(AppLink.milestones),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $getToken()()'
          },
          body: json.encode(data),
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = json.decode(response.body);
        return (responsebody);
      } else {
        return (StatusRequest.serverfailure);
      }
    } else {
      return (StatusRequest.offlinefailure);
    }
  }

  static getAllMilestonesForContract(int contractId) async {
    if (await checkInternet()) {
      final Uri uri =
          Uri.https("10.0.2.2:7042", "/contracts/$contractId/milestones");

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

  static Future<dynamic> updateMilestoneStatus(int id, String newStatus) async {
    if (await checkInternet()) {
      try {
        var uri = Uri.parse('${AppLink.milestones}/$id');

        var data = {
          "milestoneStatus": newStatus,
        };

        var response = await http.put(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${getToken()}',
          },
          body: json.encode(data),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> responseBody = json.decode(response.body);

          return responseBody;
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

  static getContractById(int id) async {
    if (await checkInternet()) {
      final Uri uri = Uri.https("10.0.2.2:7042", "/contracts/$id");

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

  static Future<dynamic> updateShouldPay(int id, int newStatus) async {
    if (await checkInternet()) {
      try {
        var uri = Uri.parse('${AppLink.contracts}/$id');

        var data = {
          "isShouldPay": newStatus,
        };

        var response = await http.put(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${getToken()}',
          },
          body: json.encode(data),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> responseBody = json.decode(response.body);

          return responseBody;
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
}
