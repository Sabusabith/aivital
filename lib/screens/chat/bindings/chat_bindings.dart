import 'package:ai_vital/core/data/controller/userhealth_profile_controller.dart';
import 'package:ai_vital/screens/chat/controller/chat_controller.dart';
import 'package:ai_vital/screens/home/controller/home_controller.dart';
import 'package:get/get.dart';

class ChatBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut(() => HealthProfileController()); // Add this line
  }
}
