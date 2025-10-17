import 'package:ai_vital/screens/journel/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JournalController extends GetxController {
  final textController = TextEditingController();
  var result = "".obs;
  var isResultVisible = false.obs; // ✨ new

  var isLoading = false.obs;

  late final OpenRouterService _service;

  @override
  void onInit() {
    super.onInit();
    _service = OpenRouterService(
      "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", // ⚠️ Secure later
    );
  }

  Future<void> analyzeMood() async {
    final text = textController.text.trim();
    if (text.isEmpty) {
      Get.snackbar(
        "Empty Input",
        "Please write something first.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    result.value = "";

    try {
      final mood = await _service.analyzeMood(text);

      result.value = mood;
    } catch (e) {
      result.value = "⚠️ Failed to analyze mood: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
