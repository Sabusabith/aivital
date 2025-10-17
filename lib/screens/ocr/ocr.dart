import 'package:ai_vital/screens/ocr/controller/ocr_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OcrScreen extends StatelessWidget {
  final OcrController controller = Get.find<OcrController>();

  @override
  Widget build(BuildContext context) {
    // Observe isLoading to show/hide loading dialog
    controller.isLoading.listen((loading) {
      if (loading) {
        // Show loading dialog
        Get.dialog(
          WillPopScope(
            // Prevent closing dialog by back button
            onWillPop: () async => false,
            child: Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.green,
                      strokeWidth: 4,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Please wait, fetching results...",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.publicSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          barrierDismissible: false, // user cannot dismiss
        );
      } else {
        // Hide dialog when loading finishes
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      }
    });

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
            fontWeight: FontWeight.w600,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            ElevatedButton.icon(
              onPressed: () async {
                await controller.scanText(context);
              },
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
          ],
        ),
      ),
    );
  }
}
