import 'package:client/core/class/statusrequest.dart';
import 'package:client/data/properties.dart';
import 'package:client/model/neighborhood/neighborhoodDto.dart';
import 'package:client/model/property.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ManagePropertiesController extends GetxController {
  GlobalKey<FormState> formKey1 = GlobalKey<FormState>(); // In AddProperty1
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>(); // In AddNeighbour
  GoogleMapController? mapController1; // In AddProperty1
  GoogleMapController? mapController2; // In AddNeighbour
  int activeStep = 0;

  TextEditingController price = TextEditingController();
  TextEditingController numberOfBedrooms = TextEditingController();
  TextEditingController numberOfBathrooms = TextEditingController();
  TextEditingController squareMeter = TextEditingController();
  TextEditingController propertyDescription = TextEditingController();
  TextEditingController numberOfUnits = TextEditingController();
  TextEditingController parkingSpots = TextEditingController();
  TextEditingController streetAddress = TextEditingController();
  DateTime builtYear = DateTime.now();
  DateTime availableDate = DateTime.now();
  String propertyType = "House";
  String view = "City";
  String propertyStatus = "Accepting offers";
  String listingType = "For sell";
  String listingBy = "Landlord";
  String isAvaliableBasement = "Yes";
  List<String> downloadUrls = [];
  int userId = 0;
  StatusRequest statusRequest = StatusRequest.loading;

  String? City;
  String? Region;
  late String PostalCode;
  String? Country;
  double? Latitude;
  double? Longitude;

  String propertiesFilter = "All properties";
  int propertiesUserId = 0;
  List<Property> userProperties = [];
  CameraPosition? currentPosition;
  Set<Marker> markers = {}; // Empty marker
  List<NeighborhoodDto> propertyNeighborhoods = [];
  TextEditingController neighborhoodStreet = TextEditingController();
  bool isUploading = false; // Add a flag for uploading photos

  // The closest properties to your location
  List<Property> closestProperties = [];
  Set<Marker> allMarkers = {};

  addProperty() async {
    if (formKey1.currentState!.validate()) {
      statusRequest = StatusRequest.loading;
      var response = await PropertyData.addProperty(
          propertyType,
          price.text,
          numberOfBedrooms.text,
          numberOfBathrooms.text,
          squareMeter.text,
          propertyDescription.text,
          builtYear,
          view,
          availableDate,
          propertyStatus,
          numberOfUnits.text,
          parkingSpots.text,
          listingType,
          isAvaliableBasement,
          listingBy,
          userId,
          downloadUrls,

          // For location
          streetAddress.text,
          City!,
          Region!,
          PostalCode,
          Country!,
          Latitude,
          Longitude,
          propertyNeighborhoods);

      if (response['statusCode'] == 200) {
      } else {
        Get.defaultDialog(
          title: "Error",
          middleText:
              "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
        );
        statusRequest = StatusRequest.failure;
      }
    }
    update();
  }

  getPropertiesUser() async {
    var response = await PropertyData.getPropertiesForUser(
        propertiesUserId, propertiesFilter);

    if (response is Map<String, dynamic>) {
      if (response['statusCode'] == 200) {
        userProperties = (response['listDto'] as List<dynamic>)
            .map((e) => Property.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        Get.defaultDialog(
          title: "Error",
          middleText:
              "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
        );
      }
    }
  }

  getNeighborhoodsForProperty(int propertyId) async {
    var response = await PropertyData.getNeighborhoodsForProperty(propertyId);

    if (response['statusCode'] == 200) {
      propertyNeighborhoods = (response['listDto'] as List<dynamic>)
          .map((e) => NeighborhoodDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  getClosestProperties(double latitude, double longitude) async {
    var response = await PropertyData.getClosestProperties(latitude, longitude);

    if (response['statusCode'] == 200) {
      closestProperties = (response['listDto'] as List<dynamic>)
          .map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  updatePropertyStatus(int propertyId, String newStatus) async {
    var response =
        await PropertyData.updatePropertyStatus(propertyId, newStatus);

    if (response is Map<String, dynamic> && response['statusCode'] == 200) {
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  deleteProperty(int id) async {
    var response = await PropertyData.deleteProperty(id);
    print(response);
  }

  // ALL this for front end
  void increaseActiveStep() {
    activeStep++;
    update();
  }

  void decreaseActiveStep() {
    activeStep--;
    update();
  }

  Widget easyStepper() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: EasyStepper(
        finishedStepBackgroundColor: const Color(0xffd92328),
        activeStepBorderColor: Colors.black,
        stepShape: StepShape.circle,
        lineStyle: const LineStyle(),
        activeStep: activeStep,
        activeStepTextColor: Colors.black87,
        finishedStepTextColor: Colors.black87,
        internalPadding: 0,
        fitWidth: true,
        showLoadingAnimation: false,
        stepRadius: 5,
        showStepBorder: false,
        steps: [
          EasyStep(
            customStep: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.grey,
              child: CircleAvatar(
                radius: 7,
                backgroundColor:
                    activeStep >= 1 ? const Color(0xffd92328) : Colors.grey,
              ),
            ),
            topTitle: true,
          ),
          EasyStep(
            customStep: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.grey,
              child: CircleAvatar(
                radius: 7,
                backgroundColor:
                    activeStep >= 2 ? const Color(0xffd92328) : Colors.grey,
              ),
            ),
          ),
          EasyStep(
            customStep: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.grey,
              child: CircleAvatar(
                radius: 7,
                backgroundColor:
                    activeStep >= 3 ? const Color(0xffd92328) : Colors.grey,
              ),
            ),
            topTitle: true,
          ),
          EasyStep(
            customStep: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.grey,
              child: CircleAvatar(
                radius: 7,
                backgroundColor:
                    activeStep >= 4 ? const Color(0xffd92328) : Colors.grey,
              ),
            ),
          ),
          EasyStep(
            customStep: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.grey,
              child: CircleAvatar(
                radius: 7,
                backgroundColor:
                    activeStep >= 5 ? const Color(0xffd92328) : Colors.grey,
              ),
            ),
          ),
          EasyStep(
            customStep: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.grey,
              child: CircleAvatar(
                radius: 7,
                backgroundColor:
                    activeStep >= 6 ? const Color(0xffd92328) : Colors.grey,
              ),
            ),
          ),
          EasyStep(
            customStep: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.grey,
              child: CircleAvatar(
                radius: 7,
                backgroundColor:
                    activeStep >= 7 ? const Color(0xffd92328) : Colors.grey,
              ),
            ),
          ),
          EasyStep(
            customStep: CircleAvatar(
              radius: 8,
              backgroundColor: Colors.grey,
              child: CircleAvatar(
                radius: 7,
                backgroundColor:
                    activeStep >= 8 ? const Color(0xffd92328) : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
