import 'dart:convert';
import 'package:client/core/class/statusrequest.dart';
import 'package:client/core/functions/checkinternet.dart';
import 'package:client/link_api.dart';
import 'package:client/shared_preferences.dart';
import 'package:client/model/neighborhood/neighborhoodDto.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PropertyData {
  static Future<dynamic> addProperty(
    String propertyType,
    String price,
    String numberOfBedrooms,
    String numberOfBathrooms,
    String squareMeter,
    String propertyDescription,
    DateTime builtYear,
    String view,
    DateTime availableOn,
    String propertyStatus,
    String numberOfUnits,
    String parkingSpots,
    String listingType,
    String isAvailableBasement,
    String listingBy,
    int userId,
    List<String> downloadUrls,
    String streetAddress,
    String city,
    String region,
    String postalCode,
    String country,
    dynamic latitude,
    dynamic longitude,
    List<NeighborhoodDto> propertyNeighborhoods,
  ) async {
    String formattedBuiltYear =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(builtYear);
    String formattedAvailableOn =
        DateFormat('yyyy-MM-ddTHH:mm:ss').format(availableOn);

    var data = {
      "propertyType": propertyType,
      "userId": userId,
      "price": int.tryParse(price) ?? 0,
      "availableOn": formattedAvailableOn,
      "numberOfBedrooms": int.tryParse(numberOfBedrooms) ?? 0,
      "numberOfBathrooms": int.tryParse(numberOfBathrooms) ?? 0,
      "squareMeter": int.tryParse(squareMeter) ?? 0,
      "propertyDescription": propertyDescription,
      "builtYear": formattedBuiltYear,
      "view": view,
      "propertyStatus": propertyStatus,
      "numberOfUnits": int.tryParse(numberOfUnits) ?? 0,
      "parkingSpots": int.tryParse(parkingSpots) ?? 0,
      "listingType": listingType,
      "isAvailableBasement": isAvailableBasement == 'Yes' ? "true" : "false",
      "listingBy": listingBy,
      "locationDto": {
        "streetAddress": streetAddress,
        "city": city,
        "region": region,
        "postalCode": postalCode,
        "country": country,
        "latitude": latitude,
        "longitude": longitude
      },
      "propertyFiles": downloadUrls,
      "neighborhoodDtos": propertyNeighborhoods,
    };
    if (await checkInternet()) {
      var response = await http.post(Uri.parse(AppLink.properties),
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

  static Future<dynamic> getProperties(
    List<String> propertyTypes,
    String minPrice,
    String maxPrice,
    String numberOfBathrooms,
    String numberOfBedrooms,
    String view,
    String listingType,
    List<String> propertyStatus,
    String minPropertySize,
    String maxPropertySize,
    String minBuiltYear,
    String maxBuiltYear,
    String parkingSpots,
    String rentType,
    bool hasBassmentUnit,
  ) async {
    final Map<String, dynamic> filters = {
      "PropertyTypes": propertyTypes,
      "MinPrice": minPrice,
      "MaxPrice": maxPrice,
      "NumberOfBedRooms": numberOfBedrooms,
      "NumberOfBathRooms": numberOfBathrooms,
      "View": view == "Any" ? "" : view,
      "ListingType": listingType,
      "propertyStatus": propertyStatus,
      "minPropertySize": minPropertySize,
      "maxPropertySize": maxPropertySize,
      "minBuiltYear": minBuiltYear,
      "maxBuiltYear": maxBuiltYear,
      "parkingSpots": parkingSpots,
      "rentType": rentType,
      "hasBasement":
          hasBassmentUnit.toString(), // Assuming 1 for true and 0 for false
    };

    if (await checkInternet()) {
      try {
        final Uri uri = Uri.https("10.0.2.2:7042", "/properties", filters);

        var response = await http.get(uri, headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${getToken()}',
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          Map<String, dynamic> responseBody = json.decode(response.body);
          print(responseBody);
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

  static Future<dynamic> getProperty(int id) async {
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

  static Future<dynamic> getListAutoCompleteLocation(String query) async {
    if (await checkInternet()) {
      var response = await http.get(
          Uri.parse('${AppLink.properties}/auto-complete-location/$query'),
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

  static Future<dynamic> getPropertyPriceLastTenYearRent(int propertyId) async {
    if (await checkInternet()) {
      var response = await http.get(
          Uri.parse(
              '${AppLink.properties}/$propertyId/property-history-price-as-rent'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${getToken()}',
          });

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> responseList = json.decode(response.body);

        return (responseList);
      } else {
        return StatusRequest.serverfailure;
      }
    } else {
      return StatusRequest.offlinefailure;
    }
  }

  static Future<dynamic> getPropertyPriceLastTenYearSell(int propertyId) async {
    if (await checkInternet()) {
      var response = await http.get(
          Uri.parse(
              '${AppLink.properties}/$propertyId/property-history-price-as-sell'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${getToken()}',
          });
      var responsebody = response.body;

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> responseList = json.decode(response.body);
        return responseList;
      } else {
        return StatusRequest.serverfailure;
      }
    } else {
      return StatusRequest.offlinefailure;
    }
  }

  static Future<dynamic> getPropertiesForUser(
      int userId, String propertiesFilter) async {
    if (await checkInternet()) {
      try {
        final Map<String, dynamic> filters = {
          "propertiesFilter": propertiesFilter,
        };

        final Uri uri =
            Uri.https("10.0.2.2:7042", "/users/$userId/properties", filters);

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

  static Future<dynamic> getClosestProperties(
      double latitude, double longitude) async {
    if (await checkInternet()) {
      try {
        final Map<String, dynamic> filters = {
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
        };
        final Uri uri =
            Uri.https("10.0.2.2:7042", "properties/closest", filters);

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

  static Future<dynamic> getNeighborhoodsForProperty(int propertyId) async {
    if (await checkInternet()) {
      final Uri uri = Uri.https("10.0.2.2:7042", "/neighborhoods/$propertyId");

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

  static Future<dynamic> updatePropertyStatus(
      int propertyId, String newStatus) async {
    if (await checkInternet()) {
      try {
        var uri = Uri.parse('${AppLink.properties}/$propertyId');

        var data = {
          "propertyStatus": newStatus,
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

  static Future<dynamic> deleteProperty(int id) async {
    if (await checkInternet()) {
      try {
        var response = await http.delete(Uri.parse('${AppLink.properties}/$id'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${getToken()}',
            });

        print(response);

        if (response.statusCode == 200 || response.statusCode == 201) {
          Map responsebody = json.decode(response.body);
          print(responsebody);
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
