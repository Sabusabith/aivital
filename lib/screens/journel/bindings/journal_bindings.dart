import 'package:ai_vital/core/data/controller/userhealth_profile_controller.dart';
import 'package:ai_vital/screens/home/controller/home_controller.dart';
import 'package:ai_vital/screens/journel/controller/journal_controller.dart';
import 'package:get/get.dart';

class JournalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JournalController>(() => JournalController());
    Get.lazyPut(() => HealthProfileController()); // Add this line
  }
}
