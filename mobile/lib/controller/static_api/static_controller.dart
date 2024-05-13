import 'package:client/model/location.dart';
import 'package:client/model/property.dart';
import 'package:client/model/user.dart';
import 'package:get/get.dart';

class StaticController extends GetxController {
  List<Property> favoriteProperties = <Property>[];
  List<Property> searchProperties = <Property>[];
  List<Location> searchLocation = <Location>[];
  List<User> recentlySearchLawyers = <User>[];
  List<User> recentlySelectLawyers = <User>[];
  List<User> recentlySearchAgents = <User>[];
  List<User> recentlySelectAgents = <User>[];

  clearsearchProperties() {
    searchProperties.clear();
    update();
  }

  clearsearchLocation() {
    searchLocation.clear();
    update();
  }

  clearSearchLawyers() {
    recentlySearchLawyers.clear();
    update();
  }

  clearSelectLawyers() {
    recentlySelectLawyers.clear();
    update();
  }

  clearSearchAgents() {
    recentlySearchAgents.clear();
    update();
  }

  clearSelectAgents() {
    recentlySelectAgents.clear();
    update();
  }
}
