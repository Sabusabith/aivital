import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouterService {
  final String apiKey;

  OpenRouterService(this.apiKey);

  Future<String> analyzeMood(String journalText) async {
    const url = "https://openrouter.ai/api/v1/chat/completions";

    final headers = {
      "Authorization": "Bearer $apiKey",
      "Content-Type": "application/json",
      "HTTP-Referer": "https://your-app-name.com",
      "X-Title": "Mood Journal AI",
    };

    final body = jsonEncode({
      "model": "gpt-4o-mini",
      "messages": [
        {
          "role": "system",
          "content":
              "You are an empathetic AI mood assistant. Analyze the user's journal entry and determine their emotional tone (e.g., happy, sad, anxious, calm, stressed). "
              "Respond in the following structure:\n\n"
              " A warm 6–7 sentence reflection that empathizes with the user's emotional state.\n"
              " A line break.\n"
              "💡 Tips to Improve or Manage:** Followed by 4–6 short, practical bullet points (each beginning with '-' or '•'), offering gentle self-care and mood management advice (like rest, mindfulness, journaling, yoga, etc.).",
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
