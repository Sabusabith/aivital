import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MoodResultScreen extends StatelessWidget {
  final String aiText;

  const MoodResultScreen({super.key, required this.aiText});

  @override
  Widget build(BuildContext context) {
    final lines = aiText.split('\n').where((l) => l.trim().isNotEmpty).toList();

    // Detect where tips start
    int tipsIndex = lines.indexWhere(
      (l) =>
          l.toLowerCase().contains('tip') ||
          l.toLowerCase().contains('advice') ||
          l.toLowerCase().contains('how to'),
    );

    final explanation = tipsIndex == -1 ? lines : lines.sublist(0, tipsIndex);
    final tips = tipsIndex == -1 ? [] : lines.sublist(tipsIndex + 1);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 2,
        centerTitle: true,
        title: Text(
          "AI Mood Insight",
          style: GoogleFonts.publicSans(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🌟 Mood Analysis Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [Colors.orange.shade200, Colors.orange.shade100],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Mood Analysis",
                    style: GoogleFonts.publicSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    explanation.join(' '),
                    style: GoogleFonts.publicSans(
                      fontSize: 16.5,
                      color: Colors.black87,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🌿 Tips Section
            if (tips.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [Colors.green.shade200, Colors.green.shade100],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Tips & Advice",
                      style: GoogleFonts.publicSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade800,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ...tips.map((tip) {
                      final cleanTip = tip
                          .replaceAll(RegExp(r'^[-•–\d\.]+\s*'), '')
                          .trim();
                      if (cleanTip.isEmpty) return const SizedBox.shrink();
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          cleanTip,
                          style: GoogleFonts.publicSans(
                            fontSize: 15.5,
                            color: Colors.black87,
                            height: 1.6,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),

            const SizedBox(height: 40),

            // 🔄 Back Button
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                shadowColor: Colors.deepOrangeAccent.withOpacity(0.4),
              ),
              child: Text(
                "Back",
                style: GoogleFonts.publicSans(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
