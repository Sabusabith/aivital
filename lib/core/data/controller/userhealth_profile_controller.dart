import 'package:ai_vital/core/data/models/UserHealthProfile_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart'
    show GetxController;

class HealthProfileController extends GetxController {
  var profile = UserHealthProfile().obs;

  void updateMood(String mood) {
    profile.update((val) => val?.mood = mood);
  }

  void updateSymptoms(List<String> symptoms) {
    profile.update((val) => val?.symptoms = symptoms);
  }

  void updateMedicines(List<String> medicines) {
    profile.update((val) => val?.medicines = medicines);
  }

  void updateOtherData(Map<String, dynamic> data) {
    profile.update((val) {
      if (val != null) val.otherData.addAll(data);
    });
  }

  void printProfile() {
    final p = profile.value;
    print("=== Health Profile ===");
    print("Mood: ${p.mood}");
    print("Symptoms: ${p.symptoms}");
    print("Medicines: ${p.medicines}");
    print("Other Data: ${p.otherData}");
    print("=====================");
  }
}
