import 'package:ai_vital/screens/chat/bindings/chat_bindings.dart';
import 'package:ai_vital/screens/chat/chat.dart';
import 'package:ai_vital/screens/home/bindings/home_binding.dart';
import 'package:ai_vital/screens/home/home.dart';
import 'package:ai_vital/screens/hospitals/bindings/hospital_bindings.dart';
import 'package:ai_vital/screens/hospitals/hospitals.dart';
import 'package:ai_vital/screens/journel/bindings/journal_bindings.dart';
import 'package:ai_vital/screens/journel/journel.dart';
import 'package:ai_vital/screens/ocr/bindings/ocr_bindings.dart';
import 'package:ai_vital/screens/ocr/ocr.dart';
import 'package:ai_vital/screens/onboarding/onboarding.dart';
import 'package:ai_vital/screens/pharmacy/bindings/pharmacy_bindings.dart';
import 'package:ai_vital/screens/pharmacy/pharmacy.dart';
import 'package:ai_vital/screens/settings/bindings/settings_bindings.dart';
import 'package:ai_vital/screens/settings/settings.dart';
import 'package:ai_vital/screens/splash/bindings/splash_bindings.dart';
import 'package:ai_vital/screens/splash/splash.dart';
import 'package:get/get.dart';

part 'app_routs.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => Splash(),
      binding: SplashBindings(),
    ),
    GetPage(name: Routes.ONBOARDING, page: () => OnboardingScreen()),
    GetPage(
      name: Routes.HOME,
      page: () => Home(),
      binding: HomeBinding(),
      transition: Transition.cupertino, // smooth professional transition
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => ChatScreen(),
      binding: ChatBindings(),
      transition: Transition.cupertino, // smooth professional transition
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.OCR,
      page: () => OcrScreen(),
      binding: OcrBindings(),
      transition: Transition.cupertino, // smooth professional transition
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.JOURNAL,
      page: () => JournalScreen(),
      binding: JournalBindings(),
      transition: Transition.cupertino, // smooth professional transition
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => SettingsScreen(),
      binding: SettingsBindings(),
      transition: Transition.cupertino, // smooth professional transition
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.PHARMA,
      page: () => Pharmacy(),
      binding: PharmacyBinding(),
      transition: Transition.cupertino, // smooth professional transition
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.HOSPITAL,
      page: () => Hospitals(),
      binding: HospitalBindings(),
      transition: Transition.cupertino, // smooth professional transition
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
