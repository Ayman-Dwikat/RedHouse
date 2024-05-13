import 'dart:convert';
import 'package:client/core/class/statusrequest.dart';
import 'package:client/core/functions/checkinternet.dart';
import 'package:client/link_api.dart';
import 'package:client/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ComplaintData {
  static sendComplaint(int userId, String description) async {
    var data = {
      "userId": userId,
      "description": description,
    };

    if (await checkInternet()) {
      var response = await http.post(
        Uri.parse(AppLink.complaints),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${getToken()}',
        },
        body: json.encode(data),
        encoding: Encoding.getByName("utf-8"),
      );

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
}
