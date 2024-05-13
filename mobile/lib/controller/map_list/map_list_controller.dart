import 'package:client/model/property.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapListController extends GetxController {
  CameraPosition currentPosition =
      const CameraPosition(target: LatLng(31.776752, 35.224851), zoom: 0);
  RxString currentLocationName = "".obs;
  Set<Marker> visibleMarkers = <Marker>{};
  List<Property> visibleProperties = <Property>[];

  bool isLoading = true;
  bool firstload = true;
  bool isListIcon = true;
  int selectedValue = 1;

  rearrangeProperties() {
    // Sort properties based on selected sort option
    visibleProperties = List.from(visibleProperties);
    if (selectedValue == 2) {
      // Sort by price (low to high)
      visibleProperties.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedValue == 3) {
      // Sort by price (high to low)
      visibleProperties.sort((a, b) => b.price.compareTo(a.price));
    } else if (selectedValue == 4) {
      // Sort by square meters area (low to high)
      visibleProperties
          .sort((a, b) => a.squareMetersArea.compareTo(b.squareMetersArea));
    } else if (selectedValue == 5) {
      // Sort by square meters area (high to low)
      visibleProperties
          .sort((a, b) => b.squareMetersArea.compareTo(a.squareMetersArea));
    }

    update();
  }

  Future<void> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng centerCoordinates = LatLng(position.latitude, position.longitude);

    currentPosition = CameraPosition(
      target: centerCoordinates,
      zoom: 14,
    );
  }
}
