import 'package:flutter/material.dart';

class OcrResultScreen extends StatelessWidget {
  final String scannedText;
  final String aiResponse;

  const OcrResultScreen({
    Key? key,
    required this.scannedText,
    required this.aiResponse,
  }) : super(key: key);

  // 🧠 Helper to group AI response by sections
  Map<String, List<String>> _groupBySection(String text) {
    final Map<String, List<String>> sections = {
      "Medicine Name": [],
      "Dosage": [],
      "Usage": [],
      "Precautions": [],
      "Side Effects": [],
      "Warnings": [],
      "Other Information": [],
    };

    String currentSection = "Other Information";

    // Split by lines, remove Markdown symbols and trim
    final lines = text
        .split('\n')
        .map((e) => e.replaceAll(RegExp(r'[\*\:]'), '').trim())
        .where((e) => e.isNotEmpty);

    for (final line in lines) {
      final lower = line.toLowerCase();

      // Detect section headers (Markdown-style)
      if (lower.startsWith("medicine name")) {
        currentSection = "Medicine Name";
        continue;
      } else if (lower.startsWith("dosage")) {
        currentSection = "Dosage";
        continue;
      } else if (lower.startsWith("uses") ||
          lower.startsWith("usage") ||
          lower.startsWith("use")) {
        currentSection = "Usage";
        continue;
      } else if (lower.startsWith("precaution")) {
        currentSection = "Precautions";
        continue;
      } else if (lower.startsWith("side effect")) {
        currentSection = "Side Effects";
        continue;
      } else if (lower.startsWith("warning")) {
        currentSection = "Warnings";
        continue;
      }

      // Skip bullets like "-" but keep their content
      final cleanedLine = line.replaceAll(RegExp(r'^[-•]\s*'), '');
      sections[currentSection]!.add(cleanedLine);
    }

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> scannedLines = scannedText.split('\n');
    final String shortScannedText = scannedLines.take(3).join(' ');
    final Map<String, List<String>> grouped = _groupBySection(aiResponse);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Medicine Analysis"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 🩺 Medicine name header
            Text(
              scannedLines.first,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 15),

            // Scanned text preview
            if (shortScannedText.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  shortScannedText + (scannedLines.length > 3 ? "..." : ""),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
            const SizedBox(height: 25),

            const Text(
              "AI Analysis & Recommendations",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 15),

            // 🧾 Grouped Section Display
            ...grouped.entries
                .where((entry) => entry.value.isNotEmpty)
                .map(
                  (entry) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: entry.value.map((point) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "• ",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      point,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
