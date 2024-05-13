import 'dart:convert';
import 'package:client/core/class/statusrequest.dart';
import 'package:client/core/functions/checkinternet.dart';
import 'package:client/link_api.dart';
import 'package:client/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ApplicationData {
  static addApplication(
    int propertyId,
    int userId,
    DateTime applicationDate,
    String message,
    String applicationStatus,
    int suggestedPrice,
  ) async {
    String formattedapplicationDate =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(applicationDate);

    var data = {
      "propertyId": propertyId,
      "userId": userId,
      "applicationDate": formattedapplicationDate,
      "message": message,
      "applicationStatus": applicationStatus,
      "suggestedPrice": suggestedPrice,
    };

    if (await checkInternet()) {
      var response = await http.post(Uri.parse(AppLink.applications),
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

  static getApplications(int userId, String? applicationStatus,
      String? applicationType, String? applicationTo) async {
    final Map<String, dynamic> filters = {
      "applicationStatus": applicationStatus,
      "applicationType": applicationType,
      "applicationTo": applicationTo,
    };

    if (await checkInternet()) {
      final Uri uri =
          Uri.https("10.0.2.2:7042", "users/$userId/applications", filters);

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

  static getApplication(int id) async {
    if (await checkInternet()) {
      var response = await http.get(Uri.parse('${AppLink.properties}/$id'),
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

  static approvedApplication(int id) async {
    if (await checkInternet()) {
      var response = await http.post(
          Uri.parse('${AppLink.applications}/$id/approve'),
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

  static deleteApplication(int id) async {
    if (await checkInternet()) {
      var response = await http.delete(Uri.parse('${AppLink.applications}/$id'),
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

  // Get all approved applications for user, to open messages between customer and landlord
  static getApprovedApplicationsForUser(int userId) async {
    if (await checkInternet()) {
      try {
        final Uri uri =
            Uri.https("10.0.2.2:7042", "/users/$userId/approved-applications");

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

  static Future<dynamic> updateApplicationStatus(
      int applicationId, String newStatus) async {
    if (await checkInternet()) {
      try {
        var uri = Uri.parse('${AppLink.applications}/$applicationId');

        var data = {
          "applicationStatus": newStatus,
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

  static getApplicationForUser(int propertyId, int customerId) async {
    final Map<String, dynamic> filters = {
      "propertyId": propertyId.toString(),
      "customerId": customerId.toString(),
    };

    if (await checkInternet()) {
      final Uri uri =
          Uri.https("10.0.2.2:7042", "/applications/is-created", filters);

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
