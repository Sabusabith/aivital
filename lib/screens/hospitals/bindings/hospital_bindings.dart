import 'package:ai_vital/screens/hospitals/controller/hospital_controller.dart';
import 'package:get/get.dart';

class HospitalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HospitalController>(() => HospitalController());
  }
}
