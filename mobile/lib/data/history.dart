import 'dart:convert';
import 'package:client/core/class/statusrequest.dart';
import 'package:client/core/functions/checkinternet.dart';
import 'package:client/link_api.dart';
import 'package:client/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class UserHistoryData {
  static sendFeedback(
      int userId, int contractId, String feedback, int rating) async {
    var data = {
      "userId": userId,
      "contractId": contractId,
      "feedback": feedback,
      "rating": rating,
    };
    if (await checkInternet()) {
      var response = await http.post(Uri.parse(AppLink.userHistories),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $getToken()()'
          },
          body: json.encode(data),
          encoding: Encoding.getByName("utf-8"));
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = json.decode(response.body);
        print(responsebody);
        return (responsebody);
      } else {
        return (StatusRequest.serverfailure);
      }
    } else {
      return (StatusRequest.offlinefailure);
    }
  }

  static getUserHistory(int userId) async {
    final Map<String, dynamic> filters = {"userId": userId.toString()};

    if (await checkInternet()) {
      final Uri uri = Uri.https("10.0.2.2:7042", "/user-history", filters);

      var response = await http.get(uri, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${getToken()}',
      });
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = json.decode(response.body);
        print(responsebody["listDto"]);

        return (responsebody);
      } else {
        return StatusRequest.serverfailure;
      }
    } else {
      return StatusRequest.offlinefailure;
    }
  }

  static getPropertyHistory(int propertId) async {
    if (await checkInternet()) {
      final Uri uri =
          Uri.https("10.0.2.2:7042", "/properties/$propertId/property-history");

      var response = await http.get(uri, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${getToken()}',
      });
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map responsebody = json.decode(response.body);
        print(responsebody["listDto"]);

        return (responsebody);
      } else {
        return StatusRequest.serverfailure;
      }
    } else {
      return StatusRequest.offlinefailure;
    }
  }
}
