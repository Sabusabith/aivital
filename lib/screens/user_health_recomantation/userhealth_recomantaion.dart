import 'package:ai_vital/core/data/controller/userhealth_profile_controller.dart';
import 'package:ai_vital/core/data/services/user_health_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HealthRecommendationScreen extends StatelessWidget {
  final HealthProfileController controller =
      Get.find<HealthProfileController>();
  final HealthRecommendationService service = HealthRecommendationService(
    apiKey: dotenv.env['API_KEY'] ?? '',
    apiUrl: 'https://openrouter.ai/api/v1/chat/completions',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Health Recommendations")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<String>(
          future: service.getRecommendations(controller.profile.value),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            return SingleChildScrollView(
              child: Text(
                snapshot.data ?? "No recommendations available",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            );
          },
        ),
      ),
    );
  }
}
