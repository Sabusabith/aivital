import 'package:ai_vital/screens/pharmacy/controller/pharmacy_controller.dart';
import 'package:get/get.dart';

class PharmacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyController>(() => PharmacyController());
  }
}
