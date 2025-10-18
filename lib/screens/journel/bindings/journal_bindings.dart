import 'package:ai_vital/screens/journel/controller/journal_controller.dart';
import 'package:get/get.dart';

class JournalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JournalController>(() => JournalController());
  }
}
