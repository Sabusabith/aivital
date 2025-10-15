import 'package:ai_vital/screens/ocr/controller/ocr_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OcrScreen extends StatelessWidget {
  final OcrController controller = Get.find<OcrController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFF),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.green,
        elevation: 3,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(
          "Scan Medicine",
          style: GoogleFonts.publicSans(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 👁️ Animated Scan Graphic (optional Lottie)
            Lottie.asset(
              'assets/images/scan.json',
              height: 200,
              repeat: true,

              fit: BoxFit.contain,
            ),

            const SizedBox(height: 30),

            Text(
              "Point your camera at the medicine label to automatically detect text.",
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                color: Colors.black87,
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 40),

            // 📸 Scan Button
            ElevatedButton.icon(
              onPressed: controller.scanText,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                shadowColor: Colors.blueAccent.withOpacity(0.3),
              ),
              icon: const Icon(Icons.camera_alt, size: 22),
              label: Text(
                "Scan Now",
                style: GoogleFonts.publicSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 🧾 Scanned Text Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Obx(
                () => Text(
                  controller.scannedText.value.isEmpty
                      ? "Scanned text will appear here..."
                      : controller.scannedText.value,
                  textAlign: TextAlign.center,
                  maxLines: 10,
                  style: GoogleFonts.publicSans(
                    fontSize: 15,
                    color: controller.scannedText.value.isEmpty
                        ? Colors.grey
                        : Colors.black87,
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
