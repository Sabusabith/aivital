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
    };

    String currentSection = ""; // start empty — no section yet
    String? currentSubHeading;

    if (text.isEmpty) return sections;

    final lines = text
        .split('\n')
        .map(
          (e) => e
              .replaceAll(RegExp(r'[*#>\_]'), '')
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim(),
        )
        .where((e) => e.isNotEmpty)
        .toList();

    for (final line in lines) {
      final lower = line.toLowerCase();

      // Detect known section headings
      final match = RegExp(
        r'^(?:-?\s*)?(medicine name|dosage|uses?|usage|precautions?|side effects?|warnings?)[:\-]?\s*(.*)',
        caseSensitive: false,
      ).firstMatch(line);

      if (match != null) {
        final heading = match.group(1)!.toLowerCase();
        final value = match.group(2)?.trim();

        if (heading.contains("medicine name")) {
          currentSection = "Medicine Name";
        } else if (heading.contains("dosage")) {
          currentSection = "Dosage";
        } else if (heading.contains("use")) {
          currentSection = "Usage";
        } else if (heading.contains("precaution")) {
          currentSection = "Precautions";
        } else if (heading.contains("side effect")) {
          currentSection = "Side Effects";
        } else if (heading.contains("warning")) {
          currentSection = "Warnings";
        }

        if (value != null && value.isNotEmpty) {
          sections[currentSection]!.add(value);
        }

        currentSubHeading = null;
        continue;
      }

      // Ignore generic AI intro lines before any section heading
      if (currentSection.isEmpty &&
          (lower.startsWith("based on") ||
              lower.contains("scanned medicine label") ||
              lower.contains("details identified"))) {
        continue;
      }

      // Subheading detection
      if (line.endsWith(":")) {
        currentSubHeading = line;
        if (currentSection.isNotEmpty) {
          sections[currentSection]!.add(line);
        }
        continue;
      }

      // Bullets
      if (line.startsWith('-') || line.startsWith('•')) {
        final cleaned = line.replaceFirst(RegExp(r'^[-•]\s*'), '').trim();
        if (currentSection.isNotEmpty) {
          if (currentSubHeading != null) {
            sections[currentSection]!.add("   - $cleaned");
          } else {
            sections[currentSection]!.add(cleaned);
          }
        }
        continue;
      }

      // Regular lines only added if inside a valid section
      if (currentSection.isNotEmpty) {
        sections[currentSection]!.add(line);
      }
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
            // 🩺 Medicine name or scanned title
            Text(
              scannedLines.first,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 15),

            // 📸 Scanned text preview
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

            // 💬 Intro text (your requested line)
            const Text(
              "Based on the scanned medicine label, here are the key details identified:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),

            // 🧾 Grouped AI analysis (excluding “Other Information”)
            ...grouped.entries
                .where((entry) => entry.value.isNotEmpty)
                .map(
                  (entry) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Section Content
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
                            final bool isSubPoint = point.trimLeft().startsWith(
                              '-',
                            );
                            final bool isSubHeading = point.endsWith(':');

                            return Padding(
                              padding: EdgeInsets.only(
                                left: isSubPoint ? 20 : 0,
                                top: 4,
                                bottom: 4,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isSubHeading && !isSubPoint)
                                    const Text(
                                      "• ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(
                                      point
                                          .replaceFirst(RegExp(r'^-'), '')
                                          .trim(),
                                      style: TextStyle(
                                        fontSize: isSubHeading
                                            ? 15
                                            : isSubPoint
                                            ? 13
                                            : 14,
                                        fontWeight: isSubHeading
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        color: isSubPoint
                                            ? Colors.grey[800]
                                            : Colors.black87,
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
