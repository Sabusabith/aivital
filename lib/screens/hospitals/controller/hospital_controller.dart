import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class HospitalController extends GetxController {
  var hospitals = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNearbyHospitals();
  }

  Future<void> fetchNearbyHospitals() async {
    isLoading.value = true;

    try {
      Position position = await _determinePosition();
      double userLat = position.latitude;
      double userLon = position.longitude;

      final url = Uri.parse(
        'https://overpass-api.de/api/interpreter?data=[out:json];node["amenity"="hospital"](around:5000,$userLat,$userLon);out;',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List elements = data['elements'];

        if (elements.isEmpty) {
          _showInfoSnackbar(
            title: "No Hospitals Found",
            message: "There are no hospitals within 5 km of your location.",
          );
        }

        hospitals.value = await Future.wait(
          elements.map((e) async {
            final lat = e['lat'] as double;
            final lon = e['lon'] as double;
            final tags = e['tags'] ?? {};

            final distanceMeters = Geolocator.distanceBetween(
              userLat,
              userLon,
              lat,
              lon,
            );
            final distanceKm = distanceMeters / 1000;

            // Address fallback
            String address = '';
            if (tags['addr:full'] != null) {
              address = tags['addr:full'];
            } else if (tags['addr:housenumber'] != null &&
                tags['addr:street'] != null) {
              address =
                  '${tags['addr:housenumber']} ${tags['addr:street']}, ${tags['addr:city'] ?? ''}';
            } else {
              address =
                  tags['addr:street'] ??
                  tags['addr:place'] ??
                  tags['addr:city'] ??
                  '';
            }

            if (address.isEmpty) {
              address = await _getAddressFromLatLon(lat, lon);
            }

            // Raw opening_hours for debugging
            final rawOH = tags['opening_hours'];
            print('Raw opening_hours for ${tags['name'] ?? 'Unnamed'}: $rawOH');

            // Improved Open/Closed logic
            bool isOpen = false;
            if (rawOH != null) {
              isOpen = _checkIfOpen(rawOH);
            } else {
              // Fallback: assume open 08:00–20:00
              final nowHour = DateTime.now().hour;
              isOpen = nowHour >= 8 && nowHour < 20;
            }

            // Print status for debugging
            print(
              'Hospital: ${tags['name'] ?? 'Unnamed'}, Address: $address, Distance: ${distanceKm.toStringAsFixed(2)} km, Status: ${isOpen ? 'Open' : 'Closed'}',
            );

            return {
              'name': tags['name'] ?? 'Unnamed Hospital',
              'lat': lat,
              'lon': lon,
              'address': address,
              'distance': distanceKm,
              'isOpen': isOpen,
            };
          }).toList(),
        );

        hospitals.value.sort(
          (a, b) => (a['distance'] as double).compareTo(b['distance']),
        );

        hospitals.value = hospitals.value.map((e) {
          e['distance'] = (e['distance'] as double).toStringAsFixed(2);
          return e;
        }).toList();
      } else {
        _showErrorSnackbar(
          title: "Server Error",
          message:
              "Couldn’t fetch data from the server. Please try again later.",
        );
        print("❌ Server Error: ${response.statusCode} → ${response.body}");
      }
    } catch (e) {
      _showErrorSnackbar(title: "Unexpected Error", message: e.toString());
      print("❌ Exception during hospital fetch: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Heuristic to check if hospital is open
  bool _checkIfOpen(String openingHours) {
    final oh = openingHours.toLowerCase().replaceAll(' ', '');
    final now = DateTime.now();

    if (oh.contains('24/7')) return true;

    try {
      final weekdays = {
        'mo': 1,
        'tu': 2,
        'we': 3,
        'th': 4,
        'fr': 5,
        'sa': 6,
        'su': 7,
      };

      final parts = oh.split(';');

      for (var part in parts) {
        final dayMatch = RegExp(
          r'(mo|tu|we|th|fr|sa|su)(?:-(mo|tu|we|th|fr|sa|su))?',
        ).firstMatch(part);
        final timeMatch = RegExp(
          r'(\d{2}):(\d{2})-(\d{2}):(\d{2})',
        ).firstMatch(part);

        if (dayMatch != null && timeMatch != null) {
          final startDay = weekdays[dayMatch.group(1)!]!;
          final endDay = dayMatch.group(2) != null
              ? weekdays[dayMatch.group(2)!]!
              : startDay;

          if (now.weekday >= startDay && now.weekday <= endDay) {
            final start = TimeOfDay(
              hour: int.parse(timeMatch.group(1)!),
              minute: int.parse(timeMatch.group(2)!),
            );
            final end = TimeOfDay(
              hour: int.parse(timeMatch.group(3)!),
              minute: int.parse(timeMatch.group(4)!),
            );
            final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);

            if (_isTimeBetween(nowTime, start, end)) return true;
          }
        }
      }

      // Default fallback if parsing fails
      final nowHour = now.hour;
      return nowHour >= 8 && nowHour < 20;
    } catch (_) {
      final nowHour = now.hour;
      return nowHour >= 8 && nowHour < 20;
    }
  }

  bool _isTimeBetween(TimeOfDay now, TimeOfDay start, TimeOfDay end) {
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
  }

  Future<String> _getAddressFromLatLon(double lat, double lon) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon',
      );
      final response = await http.get(
        url,
        headers: {'User-Agent': 'ai_vital_app/1.0'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['display_name'] ?? 'Address not available';
      }
    } catch (e) {
      print("❌ Reverse geocoding failed: $e");
    }
    return 'Address not available';
  }

  Future<void> openInMaps(double lat, double lon) async {
    // Use Google Maps navigation intent
    final Uri googleNavUrl = Uri.parse('google.navigation:q=$lat,$lon&mode=d');

    try {
      if (await canLaunchUrl(googleNavUrl)) {
        await launchUrl(googleNavUrl, mode: LaunchMode.externalApplication);
      } else {
        // fallback: open in browser if Google Maps app not installed
        final Uri fallbackUrl = Uri.parse(
          'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon&travelmode=driving',
        );
        if (await canLaunchUrl(fallbackUrl)) {
          await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar(
            "Maps Not Available",
            "Could not open Google Maps on your device.",
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      print("❌ Exception while launching Maps: $e");
      Get.snackbar(
        "Navigation Error",
        "Unable to open directions in Google Maps.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showErrorSnackbar(
        title: "Location Disabled",
        message:
            "Please enable GPS/location services to find nearby hospitals.",
        actionLabel: "Open Settings",
        onActionTap: () => Geolocator.openLocationSettings(),
      );
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showErrorSnackbar(
          title: "Permission Denied",
          message: "Location access is required to find hospitals near you.",
        );
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showErrorSnackbar(
        title: "Permission Denied Permanently",
        message:
            "Please go to settings and enable location permission for this app.",
      );
      throw Exception(
        'Location permissions are permanently denied, cannot request.',
      );
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void _showErrorSnackbar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      backgroundColor: Colors.redAccent.shade400,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  void _showInfoSnackbar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.info_outline, color: Colors.white),
      backgroundColor: Colors.blueAccent.shade400,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  void showErrorSnackbar({
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onActionTap,
  }) {
    Get.snackbar(
      title,
      message,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      backgroundColor: Colors.redAccent.shade400,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 5),
      mainButton: actionLabel != null
          ? TextButton(
              onPressed: () {
                Get.closeCurrentSnackbar();
                if (onActionTap != null) onActionTap();
              },
              child: Text(
                actionLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
