import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JournalController extends GetxController {
  TextEditingController textController = TextEditingController();
  var result = "".obs;

  void analyzeMood() {
    String text = textController.text;
    if (text.isEmpty) return;

    // TODO: Add sentiment analysis logic
    result.value = "Mood analyzed: Happy";
  }
}
