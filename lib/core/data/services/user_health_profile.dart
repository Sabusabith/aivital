import 'dart:convert';
import 'package:ai_vital/core/data/models/UserHealthProfile_model.dart';
import 'package:http/http.dart' as http;

class HealthRecommendationService {
  final String apiKey;
  final String apiUrl;

  HealthRecommendationService({required this.apiKey, required this.apiUrl});

  String buildPrompt(UserHealthProfile profile) {
    final buffer = StringBuffer();
    buffer.writeln("You are a professional health assistant.");
    buffer.writeln("User Profile:");

    if (profile.mood.isNotEmpty) buffer.writeln("- Mood: ${profile.mood}");
    if (profile.symptoms.isNotEmpty)
      buffer.writeln("- Symptoms: ${profile.symptoms.join(', ')}");
    if (profile.medicines.isNotEmpty)
      buffer.writeln("- Medicines: ${profile.medicines.join(', ')}");
    if (profile.otherData.isNotEmpty)
      buffer.writeln("- Other Info: ${profile.otherData}");

    buffer.writeln(
      "\nBased on the above, provide personalized **diet, lifestyle, and medicine interaction recommendations**.",
    );
    buffer.writeln(
      "If some info is missing, infer gently based on what is available.",
    );
    return buffer.toString();
  }

  Future<String> getRecommendations(UserHealthProfile profile) async {
    final prompt = buildPrompt(profile);
    // ✅ Debug print before sending
    print("=== Sending Health Profile to AI ===");
    print("Mood: ${profile.mood}");
    print("Symptoms: ${profile.symptoms}");
    print("Medicines: ${profile.medicines}");
    print("Other Data: ${profile.otherData}");
    print("Prompt:\n$prompt");
    print("===================================");
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "system",
            "content": "You are a professional health assistant.",
          },
          {"role": "user", "content": prompt},
        ],
        "max_tokens": 600,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices']?[0]?['message']?['content'] ?? '';
    } else {
      throw Exception("AI recommendation failed: ${response.statusCode}");
    }
  }
}
