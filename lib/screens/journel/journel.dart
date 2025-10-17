import 'package:ai_vital/screens/journel/controller/journal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class JournalScreen extends StatelessWidget {
  final JournalController controller = Get.find<JournalController>();

  final ScrollController _scrollController = ScrollController();

  JournalScreen({super.key}) {
    // Auto-scroll when result updates
    controller.result.listen((value) {
      if (value.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    });
  }

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
        child: Obx(() {
          // Check if result is shown
          final showResult = controller.result.value.isNotEmpty;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🌈 Animated Header
              if (!showResult)
                Lottie.asset(
                  'assets/images/mood.json',
                  height: 180,
                  repeat: true,
                  fit: BoxFit.contain,
                ),
              const SizedBox(height: 25),

              if (!showResult) ...[
                // 💭 Prompt Text
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

                // 📝 Journal Input Field
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
                  ),
                  child: TextField(
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
                const SizedBox(height: 25),

                // 🌟 Analyze Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      controller.analyzeMood();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 6,
                    ),
                    child: Text(
                      "Analyze Mood",
                      style: GoogleFonts.publicSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],

              // 💡 Mood Result Section
              if (showResult || controller.isLoading.value)
                Column(
                  children: [
                    const SizedBox(height: 30),
                    if (controller.isLoading.value)
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Analyzing your emotions...",
                            style: GoogleFonts.publicSans(
                              color: Colors.grey[700],
                              fontSize: 15,
                            ),
                          ),
                        ],
                      )
                    else
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Text(
                              "🧠 AI Mood Insight",
                              style: GoogleFonts.publicSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange,
                              ),
                            ),

                            // Text(
                            //   _addMoodEmoji(controller.result.value),
                            //   style: const TextStyle(fontSize: 40), // big emoji
                            // ),
                            SizedBox(height: 10),
                            Text(
                              controller.result.value,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.publicSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // 🔄 Re-analyze Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  controller.result.value = "";
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.black87,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 3,
                                ),
                                child: Text(
                                  "Re-analyze",
                                  style: GoogleFonts.publicSans(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
            ],
          );
        }),
      ),
    );
  }

  String _addMoodEmoji(String moodText) {
    final lower = moodText.toLowerCase();
    if (lower.contains("happy") || lower.contains("joy")) return "😊";
    if (lower.contains("sad") || lower.contains("depressed")) return "😢";
    if (lower.contains("angry") || lower.contains("frustrated")) return "😠";
    if (lower.contains("anxious") || lower.contains("nervous")) return "😰";
    if (lower.contains("calm") || lower.contains("relaxed")) return "😌";
    if (lower.contains("excited")) return "🤩";
    return ""; // default
  }
}
