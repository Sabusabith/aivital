import 'package:ai_vital/screens/chat/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  var messages = <ChatMessage>[].obs;
  TextEditingController textController = TextEditingController();

  void sendMessage() {
    if (textController.text.isEmpty) return;

    messages.add(ChatMessage(text: textController.text, isUser: true));
    // TODO: Call AI API and add bot response

    messages.add(
      ChatMessage(
        text:
            "AI response here We will assist you and also give response and solutions for you",
        isUser: false,
      ),
    );
    textController.clear();
  }
}
