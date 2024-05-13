import 'package:client/link_api.dart';
import 'dart:convert';
import 'package:client/core/class/statusrequest.dart';
import 'package:client/core/functions/checkinternet.dart';
import 'package:client/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UserData {
  static login(String password, String email) async {
    var data = {
      "email": email,
      "password": password,
    };
    if (await checkInternet()) {
      var response = await http.post(Uri.parse(AppLink.login),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $getToken()'
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

  static signUp(
    String firstName,
    String lastName,
    String password,
    String phoneNumber,
    String email,
    String userRole,
    String postalCode,
  ) async {
    var data = {
      "name": "$firstName $lastName",
      "password": password,
      "email": email,
      "phoneNumber": phoneNumber,
      "userRole": userRole,
      "zipCode": postalCode
    };

    if (await checkInternet()) {
      var response = await http.post(Uri.parse(AppLink.register),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $getToken()'
          },
          body: json.encode(data),
          encoding: Encoding.getByName("utf-8"));

          print(response);

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

  static getUser(int id) async {
    if (await checkInternet()) {
      var response = await http
          .get(Uri.parse('${AppLink.users}/$id'), headers: <String, String>{
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

  static verifyAccount(
    int userId,
    List<String> downloadUrls,
  ) async {
    String requestDate =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());

    var data = {
      "userId": userId,
      "requestDate": requestDate,
      "requestStatus": "Pending",
      "identityFiles": downloadUrls
    };
    if (await checkInternet()) {
      var response = await http.post(Uri.parse(AppLink.userIdentities),
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

  static getUserVerification(int id) async {
    if (await checkInternet()) {
      var response = await http.get(Uri.parse('${AppLink.userIdentities}/$id'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${getToken()}',
          });
      print(response);
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

  static Future<dynamic> updateUser(
    int userId,
    String name,
    String email,
    String phoneNumber,
  ) async {
    if (await checkInternet()) {
      try {
        var uri = Uri.parse('${AppLink.users}/$userId');

        var data = {
          "name": name,
          "email": email,
          "phoneNumber": phoneNumber,
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

  static Future<dynamic> updateUserScore(
    int userId,
    String userRole,
  ) async {
    if (await checkInternet()) {
      try {
        var uri = Uri.parse('${AppLink.users}/$userId');

        var data = {
          "userRole": userRole,
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

  static Future<dynamic> updateUserVerified(
    int userId,
    bool isVerified,
  ) async {
    if (await checkInternet()) {
      try {
        var uri = Uri.parse('${AppLink.users}/$userId');

        var data = {
          "isVerified": isVerified,
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

  static Future<dynamic> getListAutoCompleteLawyer(String query) async {
    final Map<String, dynamic> filters = {
      "query": query,
    };

    if (await checkInternet()) {
      final Uri uri = Uri.https("10.0.2.2:7042", "/lawyers", filters);

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

  static Future<dynamic> getListAutoCompleteAgent(String query) async {
    final Map<String, dynamic> filters = {
      "query": query,
    };

    if (await checkInternet()) {
      final Uri uri = Uri.https("10.0.2.2:7042", "/agents", filters);

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

  static getlawyerContacts(int id) async {
    if (await checkInternet()) {
      try {
        final Uri uri =
            Uri.https("10.0.2.2:7042", "/lawyers/$id/basic-contacts");

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
}
