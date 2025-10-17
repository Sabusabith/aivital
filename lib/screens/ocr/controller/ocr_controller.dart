import 'dart:convert';
import 'dart:io';
import 'package:ai_vital/screens/ocr/widgets/ocr_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class OcrController extends GetxController {
  var scannedText = "".obs;
  var isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  // OpenRouter or Gemini endpoint
  final String apiUrl = "https://openrouter.ai/api/v1/chat/completions";
  final String apiKey = dotenv.env['API_KEY'] ?? ''; // keep secure!

  /// 📸 Pick image & recognize text using ML Kit
  Future<void> scanText(BuildContext context) async {
    // 1️⃣ Request camera permission first
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        Get.snackbar(
          "Permission Denied",
          "Camera permission is required to scan medicine.",
        );
        return;
      }
    }

    try {
      // 2️⃣ Open camera
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile == null) {
        Get.snackbar("Cancelled", "No image captured");
        return;
      }

      // 3️⃣ Run ML Kit OCR
      final inputImage = InputImage.fromFilePath(pickedFile.path);
      final textRecognizer = TextRecognizer();

      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );
      await textRecognizer.close();

      if (recognizedText.text.trim().isEmpty) {
        Get.snackbar(
          "No Text Found",
          "Try scanning again with better lighting.",
        );
        return;
      }

      scannedText.value = recognizedText.text.trim();
      print("🧾 OCR Output:\n${scannedText.value}");

      // 4️⃣ Analyze scanned text with AI
      await analyzeMedicine(scannedText.value, context);
    } catch (e) {
      print("❌ OCR Error: $e");
      Get.snackbar("Error", "Failed to scan text: $e");
    }
  }

  /// 🤖 Send text to AI and display in Bottom Sheet
  Future<void> analyzeMedicine(String text, BuildContext context) async {
    isLoading.value = true;

    try {
      String cleanText = text.length > 1000 ? text.substring(0, 1000) : text;

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
              "content":
                  "You are a medical assistant. The user scanned a medicine label. Identify medicine name, dosage, uses, precautions, side effects, and warnings in clear bullet points.",
            },
            {"role": "user", "content": cleanText},
          ],
          "max_tokens": 500,
        }),
      );

      isLoading.value = false;

      print("📡 Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiReply =
            data['choices']?[0]?['message']?['content'] ??
            "No analysis available.";

        if (context.mounted) {
          Get.to(() => OcrResultScreen(scannedText: text, aiResponse: aiReply));
        }
      } else {
        Get.snackbar(
          "AI Error",
          "Status ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Network Error", "Failed to reach AI API: $e");
    }
  }

  /// 🧾 Bottom sheet with AI output
  // void _showResultBottomSheet(
  //   BuildContext context,
  //   String scannedText,
  //   String aiResponse,
  // ) {
  //   // Shorten scanned text to first 3 lines for neatness
  //   final List<String> scannedLines = scannedText.split('\n');
  //   final String shortScannedText = scannedLines.take(3).join(' ');

  //   // Convert AI response into neat bullet points
  //   final List<String> bullets = aiResponse
  //       .split(RegExp(r'[\n•\-]'))
  //       .map((e) => e.trim())
  //       .where((e) => e.isNotEmpty)
  //       .toList();

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) {
  //       return DraggableScrollableSheet(
  //         expand: false,
  //         initialChildSize: 0.65,
  //         maxChildSize: 0.95,
  //         minChildSize: 0.4,
  //         builder: (_, scrollController) => Container(
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: const BorderRadius.vertical(
  //               top: Radius.circular(25),
  //             ),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black26.withOpacity(0.1),
  //                 blurRadius: 15,
  //                 spreadRadius: 5,
  //               ),
  //             ],
  //           ),
  //           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  //           child: Stack(
  //             children: [
  //               ListView(
  //                 controller: scrollController,
  //                 padding: const EdgeInsets.only(top: 40),
  //                 children: [
  //                   // Drag handle
  //                   Center(
  //                     child: Container(
  //                       width: 60,
  //                       height: 6,
  //                       margin: const EdgeInsets.only(bottom: 20),
  //                       decoration: BoxDecoration(
  //                         color: Colors.grey[300],
  //                         borderRadius: BorderRadius.circular(3),
  //                       ),
  //                     ),
  //                   ),

  //                   // Header: Medicine Name / Key Info
  //                   Text(
  //                     scannedLines.first, // main title
  //                     style: const TextStyle(
  //                       fontSize: 20,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.green,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 15),

  //                   // Scanned Text Section (Concise & Neat)
  //                   if (shortScannedText.isNotEmpty)
  //                     Container(
  //                       width: double.infinity,
  //                       padding: const EdgeInsets.all(12),
  //                       decoration: BoxDecoration(
  //                         color: Colors.green[50],
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       child: Text(
  //                         shortScannedText +
  //                             (scannedLines.length > 3 ? "..." : ""),
  //                         style: const TextStyle(
  //                           fontSize: 14,
  //                           color: Colors.black87,
  //                           height: 1.5,
  //                         ),
  //                       ),
  //                     ),
  //                   const SizedBox(height: 20),

  //                   // AI Response Section
  //                   Text(
  //                     "Analysis & Recommendations",
  //                     style: const TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.blueGrey,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 12),

  //                   // Bulleted AI Response
  //                   Container(
  //                     width: double.infinity,
  //                     padding: const EdgeInsets.all(15),
  //                     decoration: BoxDecoration(
  //                       color: Colors.grey[100],
  //                       borderRadius: BorderRadius.circular(15),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black12.withOpacity(0.05),
  //                           blurRadius: 8,
  //                           offset: const Offset(0, 4),
  //                         ),
  //                       ],
  //                     ),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: bullets.map((point) {
  //                         return Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 4),
  //                           child: Row(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               const Text(
  //                                 "• ",
  //                                 style: TextStyle(
  //                                   fontSize: 16,
  //                                   color: Colors.black87,
  //                                 ),
  //                               ),
  //                               Expanded(
  //                                 child: Text(
  //                                   point,
  //                                   style: const TextStyle(
  //                                     fontSize: 14,
  //                                     color: Colors.black87,
  //                                     height: 1.6,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         );
  //                       }).toList(),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 25),
  //                 ],
  //               ),

  //               // Close icon (top-right)
  //               Positioned(
  //                 right: 0,
  //                 top: 0,
  //                 child: IconButton(
  //                   icon: const Icon(Icons.close, size: 28, color: Colors.grey),
  //                   onPressed: () => Navigator.of(context).pop(),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
