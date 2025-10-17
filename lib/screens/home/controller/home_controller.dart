import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class HomeController extends GetxController {
  Future<void> _requestLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        "Location Disabled",
        "Please enable GPS/location services.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          "Permission Denied",
          "Location access is required to use this feature.",
          icon: const Icon(Icons.location_off, color: Colors.white),
          backgroundColor: const Color(0xFFF44336), // professional red
          colorText: Colors.white, // white for readability
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 4),
        );

        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        "Permission Denied Permanently",
        "Please enable location permission from settings.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      await Geolocator.openAppSettings();
      return;
    }

    // Permission granted, navigate to Home
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _requestLocationPermission();
  }

  var userName = "Mohammed Sabith".obs;
}
