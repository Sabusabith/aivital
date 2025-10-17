import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class HospitalController extends GetxController {
  var hospitals = <Map<String, String>>[
    {"name": "City Hospital", "address": "123 Main Street"},
    {"name": "Green Valley Hospital", "address": "456 Oak Avenue"},
    {"name": "Sunrise Medical Center", "address": "789 Pine Road"},
    {"name": "WellCare Hospital", "address": "321 Maple Lane"},
    {"name": "QuickHealth Hospital", "address": "654 Elm Street"},
    {"name": "Sunrise Medical Center", "address": "789 Pine Road"},
    {"name": "Green Valley Hospital", "address": "456 Oak Avenue"},
  ].obs;
}
