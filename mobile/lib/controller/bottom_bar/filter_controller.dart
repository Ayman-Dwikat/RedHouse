import 'package:client/data/properties.dart';
import 'package:client/model/list_property.dart';
import 'package:client/model/location.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  bool listingType = false; // true --> Buy, false --> Rent
  bool tabType = false; // Like as listingType temp
  ListProperty listProperty = ListProperty(listDto: []);
  List<Location> listAutoCompleteLocation = [];
  List<FlSpot> flSpotListRent = [];
  List<FlSpot> flSpotListSell = [];

  // Property type
  bool house = true;
  bool houseTemp = true;
  bool apartment = true;
  bool apartmentTemp = true;
  bool townhouse = true;
  bool townhouseTemp = true;
  bool castle = true;
  bool castleTemp = true;
  bool department = true;
  bool departmentTemp = true;

  // Price
  final maxController = TextEditingController();
  final minController = TextEditingController();
  final maxControllerTemp = TextEditingController();
  final minControllerTemp = TextEditingController();

  // Bed Bath
  RxString bedButtonTemp = "Any".obs;
  RxString bedButton = "Any".obs;
  RxString bathButtonTemp = "Any".obs;
  RxString bathButton = "Any".obs;

  final List<String> bedroomLabels = [
    'Any',
    'Studio+',
    '1+',
    '2+',
    '3+',
    '4+',
    '5+',
  ];

  final List<String> bathroomLabels = [
    'Any',
    '1+',
    '2+',
    '3+',
    '4+',
    '5+',
  ];

  // Property view
  String view = "Any";
  String viewTemp = "Any";

  // Listing by
  String listingBy = "Any";
  String listingByTemp = "Any";

  // Property size
  final sizeMax = TextEditingController();
  final sizeMin = TextEditingController();
  final sizeMaxTemp = TextEditingController();
  final sizeMinTemp = TextEditingController();

  // Rent type
  String rentType = "All";
  String rentTypeTemp = "All";

  // Property status
  bool comingSoon = true;
  bool comingSoonTemp = true;
  bool acceptingOffers = true;
  bool acceptingOffersTemp = true;
  bool underContract = true;
  bool underContractTemp = true;

  // Parking spots
  final parkingSpots = TextEditingController();
  final parkingSpotsTemp = TextEditingController();

  // Basement
  bool basement = true;
  bool basementTemp = true;

  // Year built
  final yearBuiltMax = TextEditingController();
  final yearBuiltMin = TextEditingController();
  final yearBuiltMaxTemp = TextEditingController();
  final yearBuiltMinTemp = TextEditingController();

  // For style when filter on
  bool filtersON = false;
  bool priceON = false;
  bool bedBathON = false;
  bool propertyTypeON = false;

  String priceText = "Price";
  String bedBathText = "Bed / Bath";
  String propertyTypeText = "Property type";

  void checkFiltersON() {
    if (priceText != 'Price' ||
        bedBathText != "Bed / Bath" ||
        propertyTypeText != "Property type" ||
        listingBy != "Any" ||
        view != "Any" ||
        rentType != "All" ||
        sizeMax.text.isNotEmpty ||
        sizeMin.text.isNotEmpty ||
        yearBuiltMax.text.isNotEmpty ||
        yearBuiltMin.text.isNotEmpty ||
        parkingSpots.text.isNotEmpty ||
        basement == false ||
        comingSoon == false ||
        acceptingOffers == false ||
        underContract == false) {
      filtersON = true;
    } else {
      filtersON = false;
    }
    update();
  }

  void formatPriceRange() {
    final minPrice = minController.text;
    final maxPrice = maxController.text;

    String formatValue(String value) {
      if (value.isEmpty) {
        priceText = 'Any';
      }
      final intValue = int.tryParse(value);
      if (intValue == null) {
        return value; // Not a valid number, return as is
      }
      if (intValue < 1000) {
        return '\$$intValue'; // Display as is if less than 1000
      }
      return '\$${(intValue / 1000).toStringAsFixed(0)}K'; // Format in K
    }

    if (minPrice.isNotEmpty && maxPrice.isNotEmpty) {
      priceText = '${formatValue(minPrice)} - ${formatValue(maxPrice)}';
      priceON = true;
    } else if (minPrice.isNotEmpty) {
      priceText = 'Min ${formatValue(minPrice)}';
      priceON = true;
    } else if (maxPrice.isNotEmpty) {
      priceText = 'Max ${formatValue(maxPrice)}';
      priceON = true;
    } else {
      priceText = 'Price';
      priceON = false;
    }
    update();
  }

  void formatBedBath() {
    if (bedButton.value != "Any" && bathButton.value != "Any") {
      bedBathText = "${bedButton.value} Bd / ${bathButton.value} Ba";
      bedBathON = true;
    } else if (bedButton.value != "Any") {
      bedBathText = "${bedButton.value} Bd / Any Ba";
      bedBathON = true;
    } else if (bathButton.value != "Any") {
      bedBathText = "Any Bd / ${bathButton.value} Ba";
      bedBathON = true;
    } else {
      bedBathText = "Bed / Bath";
      bedBathON = false;
    }
    update();
  }

  void formatPropertyTypes() {
    if (house && apartment && townhouse && castle && department) {
      propertyTypeText = 'Property type';
      propertyTypeON = false;
    } else {
      propertyTypeON = true;
      List<String> selectedTypes = [];
      if (house) {
        selectedTypes.add('House');
      }
      if (apartment) {
        selectedTypes.add('Apartment Unit');
      }
      if (townhouse) {
        selectedTypes.add('Townhouse');
      }
      if (castle) {
        selectedTypes.add('Castle');
      }
      if (department) {
        selectedTypes.add('Entire Department');
      }
      propertyTypeText = selectedTypes.join(', ');
    }
    update();
  }

  void setBedButtonTemp(String label) {
    bedButtonTemp.value = label;
  }

  void setBathButtonTemp(String label) {
    bathButtonTemp.value = label;
  }

  bool isBedButtonTemp(String label) {
    return bedButtonTemp.value == label;
  }

  bool isBathButtonTemp(String label) {
    return bathButtonTemp.value == label;
  }

  void copyBedButton() {
    bedButton.value = bedButtonTemp.value;
  }

  void copyBathButton() {
    bathButton.value = bathButtonTemp.value;
  }

  void copyBedButtonTemp() {
    bedButtonTemp.value = bedButton.value;
  }

  void copyBathButtonTemp() {
    bathButtonTemp.value = bathButton.value;
  }

  // Apis
  // Apis
  // Apis
  // Apis
  getProperties() async {
    List<String>? propertyTypes = [];
    String? minPrice;
    String? maxPrice;
    String? numberOfBathrooms;
    String? numberOfBedrooms;
    String? _view;
    String? listingPropertyType;
    List<String>? propertyStatus = [];

    String? minPropertySize;
    String? maxPropertySize;

    String? minBuiltYear;
    String? maxBuiltYear;

    String? _parkingSpots;
    bool? hasBassmentUnit;

    if (house) {
      propertyTypes.add("House");
    }

    if (apartment) {
      propertyTypes.add("Apartment Unit");
    }

    if (townhouse) {
      propertyTypes.add("Townhouse");
    }

    if (castle) {
      propertyTypes.add("Castle");
    }

    if (department) {
      propertyTypes.add("Entire Department Community");
    }

    if (comingSoon) {
      propertyStatus.add("Coming soon");
    }

    if (acceptingOffers) {
      propertyStatus.add("Accepting offers");
    }

    if (underContract) {
      propertyStatus.add("Under contract");
    }

    minPrice = minController.text;
    maxPrice = maxController.text;
    minBuiltYear = yearBuiltMin.text;
    maxBuiltYear = yearBuiltMax.text;
    maxPropertySize = sizeMax.text;
    minPropertySize = sizeMin.text;
    _parkingSpots = parkingSpots.text;
    hasBassmentUnit = basement;
    _view = view;

    if (bedButton.toString().length <= 2) {
      numberOfBedrooms = bedButton.string.substring(0, 1);
    } else {
      numberOfBedrooms = "";
    }

    if (bathButton.toString().length <= 2) {
      numberOfBathrooms = bathButton.string.substring(0, 1);
    } else {
      numberOfBathrooms = "";
    }
    // Rest of your code
    if (listingType) {
      listingPropertyType = "For sell";
    } else {
      listingPropertyType = "For rent";
    }
    var response = await PropertyData.getProperties(
      propertyTypes,
      minPrice,
      maxPrice,
      numberOfBathrooms,
      numberOfBedrooms,
      _view,
      listingPropertyType.toString(),
      propertyStatus,
      minPropertySize,
      maxPropertySize,
      minBuiltYear,
      maxBuiltYear,
      _parkingSpots,
      rentType,
      hasBassmentUnit,
    );

    if (response is Map<String, dynamic> &&
        response.containsKey('statusCode')) {
      if (response['statusCode'] == 200) {
        listProperty = ListProperty.fromJson(response);
        print(listProperty.listDto);
      } else {
        Get.defaultDialog(
          title: "Error",
          middleText:
              "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
        );
      }
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText: "statusCode: 500, Internal server error}",
      );
    }
  }

  getListAutoCompleteLocation(String query) async {
    query = query.isEmpty ? "*" : query;
    var response = await PropertyData.getListAutoCompleteLocation(query);

    if (response['statusCode'] == 200) {
      listAutoCompleteLocation = (response['listDto'] as List<dynamic>)
          .map((e) => Location.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      Get.defaultDialog(
        title: "Error",
        middleText:
            "statusCode: ${response['statusCode']}, exceptions: ${response['exceptions']}",
      );
    }
  }

  getPropertyPriceLastTenYearRent(int propertyId) async {
    List<dynamic> response =
        await PropertyData.getPropertyPriceLastTenYearRent(propertyId);

    List<dynamic> priceLastTenYears = response;
    int curYear = DateTime.now().year;
    for (int i = 9; i >= 0; i--) {
      var flSpot =
          FlSpot((curYear - i).toDouble(), priceLastTenYears[9 - i].toDouble());

      flSpotListRent.add(flSpot);
    }
  }

  getPropertyPriceLastTenYearSell(int propertyId) async {
    var response =
        await PropertyData.getPropertyPriceLastTenYearSell(propertyId);

    List<dynamic> priceLastTenYears = response;
    int curYear = DateTime.now().year;

    for (int i = 9; i >= 0; i--) {
      var flSpot =
          FlSpot((curYear - i).toDouble(), priceLastTenYears[i].toDouble());
      flSpotListSell.add(flSpot);
    }
  }
}
