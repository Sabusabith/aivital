import 'package:ai_vital/core/data/controller/userhealth_profile_controller.dart';
import 'package:ai_vital/screens/journel/service/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class JournalController extends GetxController {
  final textController = TextEditingController();
  final HealthProfileController _healthProfileController =
      Get.find<HealthProfileController>();

  var result = "".obs;
  var isResultVisible = false.obs;
  var isLoading = false.obs;

  var errorMessage = "".obs; // ✨ New observable for input validation

  late final OpenRouterService _service;

  @override
  void onInit() {
    super.onInit();
    _service = OpenRouterService(dotenv.env['API_KEY'] ?? '');
  }

  Future<void> analyzeMood() async {
    final text = textController.text.trim();

    // Validate input
    if (text.isEmpty) {
      errorMessage.value = "Please write something first."; // show inline
      return;
    } else {
      errorMessage.value = ""; // clear error
    }

    isLoading.value = true;
    result.value = "";

    try {
      final mood = await _service.analyzeMood(text);
      result.value = mood;
      _healthProfileController.updateMood(result.value);
      // 🔹 Update HealthProfileController
    } catch (e) {
      result.value = "⚠️ Failed to analyze mood: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
