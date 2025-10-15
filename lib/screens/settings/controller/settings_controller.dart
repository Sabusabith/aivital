import 'package:get/get.dart';

class SettingsController extends GetxController {
  var name = "Mohammed Sabith";
  var age = 23;
  var reminder = true.obs;

  void toggleReminder(bool value) {
    reminder.value = value;
  }
}
