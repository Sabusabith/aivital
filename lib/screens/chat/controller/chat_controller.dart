import 'dart:convert';
import 'package:ai_vital/screens/chat/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChatController extends GetxController {
  var messages = <ChatMessage>[].obs;
  TextEditingController textController = TextEditingController();

  // 🔑 Replace with your actual OpenRouter API key
  final String openRouterApiKey =
      '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';
  final String modelName =
      'anthropic/claude-3.5-sonnet'; // or another supported model
  final String openRouterUrl = 'https://openrouter.ai/api/v1/chat/completions';

  Future<void> sendMessage() async {
    final userMessage = textController.text.trim();
    if (userMessage.isEmpty) return;

    // Add user message
    messages.add(ChatMessage(text: userMessage, isUser: true));
    textController.clear();

    // Add placeholder AI message for streaming
    final aiMessage = ChatMessage(text: "", isUser: false);
    messages.add(aiMessage);

    try {
      final request = http.Request("POST", Uri.parse(openRouterUrl));
      request.headers.addAll({
        'Authorization': 'Bearer $openRouterApiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://yourapp.com', // optional, recommended
        'X-Title': 'AI Vital Chat', // optional metadata
      });

      request.body = jsonEncode({
        "model": modelName,
        "messages": [
          {"role": "system", "content": "You are a helpful AI assistant."},
          {"role": "user", "content": userMessage},
        ],
        "stream": true,
      });

      final response = await request.send();

      if (response.statusCode == 200) {
        // Stream line-by-line
        final stream = response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter());

        await for (final line in stream) {
          if (line.trim().isEmpty || !line.startsWith('data:')) continue;
          final jsonData = line.substring(5).trim();

          if (jsonData == '[DONE]') break;

          try {
            final parsed = jsonDecode(jsonData);
            final chunk = parsed['choices']?[0]?['delta']?['content'] ?? '';

            if (chunk.isNotEmpty) {
              final current = aiMessage.text + chunk;
              aiMessage.text = current;
              messages[messages.length - 1] = ChatMessage(
                text: current,
                isUser: false,
              );
            }
          } catch (e) {
            print('⚠️ Stream parse error: $e');
          }
        }
      } else {
        messages.removeLast();
        messages.add(
          ChatMessage(
            text: '⚠️ OpenRouter error (${response.statusCode})',
            isUser: false,
          ),
        );
      }
    } catch (e) {
      messages.removeLast();
      messages.add(
        ChatMessage(
          text: '⚠️ Connection error: $e\nCheck API key or network.',
          isUser: false,
        ),
      );
      print('❌ OpenRouter API Error: $e');
    }
  }
}
