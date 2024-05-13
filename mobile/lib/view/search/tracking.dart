// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';
import 'package:client/controller/map_list/map_list_controller.dart';
import 'package:client/view/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingLocation extends StatefulWidget {
  const TrackingLocation({super.key});

  @override
  State<TrackingLocation> createState() => _TrackingMapState();
}

class _TrackingMapState extends State<TrackingLocation> {
  MapListController mapListController = Get.put(MapListController());
  GoogleMapController? gmc;
  CameraPosition? currentPosition;
  List<Marker> markers = [];
  StreamSubscription<Position>? positionStream;

  @override
  void initState() {
    // markers.add(
    //     const Marker(markerId: MarkerId("1"), position: LatLng(31, 35)));
    // markers.add(const Marker(
    //     markerId: MarkerId("2"), position: LatLng(31.1, 35.1)));
    markers.addAll(mapListController.visibleMarkers.toList());
    loadClosestProperties();
    super.initState();
  }

  @override
  void dispose() {
    positionStream!.cancel();
    super.dispose();
  }

  initalStream() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.whileInUse) {
      positionStream =
          Geolocator.getPositionStream().listen((Position? position) {
        markers.add(Marker(
            markerId: const MarkerId("tracking"),
            position: LatLng(position!.latitude, position.longitude)));

        gmc!.animateCamera(CameraUpdate.newLatLng(
            LatLng(position.latitude, position.longitude)));
        setState(() {});
      });
    }
  }

  Future<void> loadClosestProperties() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng centerCoordinates = LatLng(position.latitude, position.longitude);

    if (mounted) {
      setState(() {
        currentPosition = CameraPosition(
          target: centerCoordinates,
          zoom: 14,
        );
      });
    }

    initalStream();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              Get.off(() => const BottomBar());
            });
          },
        ),
        title: const Text(
          "Tracking Location",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            if (currentPosition != null)
              Expanded(
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: currentPosition!,
                  onMapCreated: (controller) {
                    gmc = controller;
                  },
                  myLocationButtonEnabled: true,
                  markers: markers.toSet(),
                ),
              )
            else
              const LinearProgressIndicator(
                backgroundColor: Colors.black,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 3,
              ),
          ],
        ),
      ),
    );
  }
}
