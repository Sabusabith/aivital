import 'package:ai_vital/core/constants/app_colors.dart';
import 'package:ai_vital/screens/home/controller/home_controller.dart';
import 'package:ai_vital/screens/home/widgets/aibutton_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/app_pages.dart';

class Home extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();
  final RxBool showGreeting = true.obs; // Controls AI greeting visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: _buildAppBar(),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                _buildProCard(
                  title: "Symptom Analyzer",
                  icon: Icons.chat_bubble_outline,
                  route: Routes.CHAT,
                  colors: [kprimerycolor, ksecondarycolor],
                ),
                _buildProCard(
                  title: "Scan Medicine",
                  icon: Icons.medical_services_outlined,
                  route: Routes.OCR,
                  colors: [Colors.green, Colors.lightGreenAccent],
                ),
                _buildProCard(
                  title: "Mood Journal",
                  icon: Icons.edit_note_outlined,
                  route: Routes.JOURNAL,
                  colors: [Colors.orange, Colors.deepOrangeAccent],
                ),

                _buildProCard(
                  title: "Nearest Pharmacy",
                  icon: Icons.local_pharmacy,
                  route: Routes.PHARMA,
                  colors: [Colors.purple, Colors.deepPurpleAccent],
                ),
                _buildProCard(
                  title: "Nearest Hospital",
                  icon: Icons.local_hospital,
                  route: Routes.HOSPITAL,
                  colors: [Colors.red, Colors.pinkAccent],
                ),
                _buildProCard(
                  title: "Settings",
                  icon: Icons.settings_outlined,
                  route: Routes.SETTINGS,
                  colors: [Colors.grey, Colors.blueGrey],
                ),
              ],
            ),
          ),

          // AI Assistant FAB + Greeting
          Positioned(bottom: 16, right: 16, child: HomeAILottieChat()),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        height: 140,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kprimerycolor, Color.fromARGB(255, 81, 169, 241)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: 0,
      centerTitle: false,
      leading: const SizedBox(),
      toolbarHeight: 80,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          Text(
            "Hi, Mohammed 👋",
            style: GoogleFonts.publicSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Welcome back! Check your health today",
            style: GoogleFonts.publicSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 12, top: 12),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white30,
            child: IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProCard({
    required String title,
    required IconData icon,
    required String route,
    required List<Color> colors,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.last.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.publicSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
