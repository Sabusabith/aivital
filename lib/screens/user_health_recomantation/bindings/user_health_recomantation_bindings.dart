import 'package:ai_vital/core/data/controller/userhealth_profile_controller.dart';
import 'package:ai_vital/screens/home/controller/home_controller.dart';
import 'package:ai_vital/screens/pharmacy/controller/pharmacy_controller.dart';
import 'package:get/get.dart';

class UserHealthRecomantationBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthProfileController>(() => HealthProfileController());
  }
}
