import 'package:ai_vital/screens/journel/controller/journal_controller.dart';
import 'package:ai_vital/screens/journel/widgets/build_result.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class JournalScreen extends StatelessWidget {
  final JournalController controller = Get.find<JournalController>();
  final ScrollController _scrollController = ScrollController();

  JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.orange,
        elevation: 3,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(
          "Mood Journal",
          style: GoogleFonts.publicSans(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🌈 Header Animation
            Lottie.asset(
              'assets/images/mood.json',
              height: 180,
              repeat: true,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 25),

            Text(
              "How was your day today?",
              style: GoogleFonts.publicSans(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Write down your thoughts or feelings. AI will help analyze your mood and provide emotional insight.",
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),

            // 📝 Journal Input
            Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: controller.errorMessage.value.isEmpty
                            ? Colors.transparent
                            : Colors.red,
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      cursorColor: Colors.orange,
                      controller: controller.textController,
                      maxLines: 6,
                      style: GoogleFonts.publicSans(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: "Start writing here...",
                        hintStyle: GoogleFonts.publicSans(
                          color: Colors.grey[500],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (controller.errorMessage.value.isNotEmpty)
                    Text(
                      controller.errorMessage.value,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              );
            }),
            const SizedBox(height: 25),

            // 🌟 Analyze Button
            Obx(() {
              return controller.isLoading.value
                  ? _buildLoadingButton()
                  : _buildAnalyzeButton(context);
            }),
          ],
        ),
      ),
    );
  }

  // 🌟 Loading Button
  Widget _buildLoadingButton() {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.orange,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 14),
            AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 600),
              child: Text(
                "Analyzing",
                style: GoogleFonts.publicSans(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 5),
              child: LoadingAnimationWidget.progressiveDots(
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🧭 Analyze Button
  Widget _buildAnalyzeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();

          // Call AI analysis
          await controller.analyzeMood();

          // Navigate to result screen if result is ready
          if (controller.result.value.isNotEmpty) {
            controller.textController.clear();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    MoodResultScreen(aiText: controller.result.value),
              ),
            ).then((_) {
              // Clear result when returning to JournalScreen
              controller.result.value = '';
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 8,
          shadowColor: Colors.orangeAccent.withOpacity(0.4),
        ),
        child: Text(
          "Analyze Mood",
          style: GoogleFonts.publicSans(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
