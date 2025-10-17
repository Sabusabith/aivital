import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouterService {
  final String apiKey;

  OpenRouterService(this.apiKey);

  Future<String> analyzeMood(String journalText) async {
    const url = "https://openrouter.ai/api/v1/chat/completions";

    final headers = {
      "Authorization":
          "Bearer $apiKey", // ✅ use the real API key passed from controller
      "Content-Type": "application/json",
      "HTTP-Referer": "https://your-app-name.com", // optional but recommended
      "X-Title": "Mood Journal AI",
    };

    final body = jsonEncode({
      "model": "gpt-4o-mini", // ✅ shorter alias for OpenRouter GPT-4o Mini
      "messages": [
        {
          "role": "system",
          "content":
              "You are an empathetic AI mood assistant. Analyze the user's journal entry and determine their emotional tone (e.g., happy, sad, anxious, calm, stressed). Respond with a brief, warm message in 2–3 sentences, ending with gentle advice or encouragement.",
        },
        {"role": "user", "content": journalText},
      ],
      "temperature": 0.7,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data["choices"]?[0]?["message"]?["content"];
      if (content == null || content.isEmpty) {
        throw Exception("No content returned from AI.");
      }
      return content.trim();
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }
}
