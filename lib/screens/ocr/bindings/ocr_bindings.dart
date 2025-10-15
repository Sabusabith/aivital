import 'package:ai_vital/screens/home/controller/home_controller.dart';
import 'package:ai_vital/screens/ocr/controller/ocr_controller.dart';
import 'package:get/get.dart';

class OcrBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OcrController>(() => OcrController());
  }
}
