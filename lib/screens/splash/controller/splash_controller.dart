import 'package:ai_vital/core/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(Routes.ONBOARDING);
    });
    super.onInit();
  }
}
