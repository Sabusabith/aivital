import 'package:ai_vital/core/constants/app_colors.dart';
import 'package:ai_vital/core/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // You can replace this Icon with Lottie.asset('assets/animations/health.json')
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kprimerycolor.withOpacity(0.1),
              ),
              child: const Icon(Icons.person, size: 120, color: kprimerycolor),
            ),
            const SizedBox(height: 30),
            Text(
              "Your Smart Health Companion",
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Track your symptoms, scan medicines, and chat with your AI assistant.",
              textAlign: TextAlign.center,
              style: GoogleFonts.publicSans(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 50),
            GestureDetector(
              onTap: () => Get.offAllNamed(Routes.HOME),
              child: Container(
                width: size.width,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [kprimerycolor, ksecondarycolor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kprimerycolor.withOpacity(0.4),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "Get Started",
                    style: GoogleFonts.publicSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
