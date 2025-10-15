import 'package:ai_vital/screens/journel/controller/journal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class JournalScreen extends StatelessWidget {
  final JournalController controller = Get.find<JournalController>();

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
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // // 🌈 Animated Header (adds life and friendliness)
            // Lottie.asset(
            //   'assets/animations/mood.json',
            //   height: 180,
            //   repeat: true,
            //   fit: BoxFit.contain,
            // ),
            // const SizedBox(height: 30),

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
              "Write down your thoughts or feelings. AI will help you understand your mood better.",
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),

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
                  hintStyle: GoogleFonts.publicSans(color: Colors.grey[500]),
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
                onPressed: controller.analyzeMood,
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

            const SizedBox(height: 30),

            // 💡 Mood Result Display
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  border: controller.result.value.isEmpty
                      ? Border()
                      : Border.all(color: Colors.orange),
                  color: controller.result.value.isEmpty
                      ? Colors.transparent
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: controller.result.value.isEmpty
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: Text(
                  controller.result.value.isEmpty
                      ? ""
                      : controller.result.value,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.publicSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
