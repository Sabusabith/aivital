import 'package:ai_vital/core/constants/app_colors.dart';
import 'package:ai_vital/screens/home/controller/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/routes/app_pages.dart';

class Home extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          flexibleSpace: Container(
            height: 140,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF42A5F5), Color(0xFF478DE0)],
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
          // toolbarHeight: 70,
          leading: SizedBox(),
          toolbarHeight: 80,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              SizedBox(height: 15),
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
                backgroundColor: Colors.white24,
                child: IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    // TODO: handle notifications
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _buildProCard(
              title: "Symptom Checker",
              icon: Icons.chat_bubble_outline,
              route: Routes.CHAT,
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
            ),
            _buildProCard(
              title: "Scan Medicine",
              icon: Icons.medical_services_outlined,
              route: Routes.OCR,
              colors: [Colors.green, Colors.teal.withOpacity(.7)],
            ),
            _buildProCard(
              title: "Mood Journal",
              icon: Icons.edit_note_outlined,
              route: Routes.JOURNAL,
              colors: [Colors.orange, Colors.deepOrangeAccent],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.CHAT),
        icon: const Icon(Icons.smart_toy_outlined, color: Colors.white),
        label: Text(
          "AI Assistant",
          style: GoogleFonts.publicSans(color: Colors.white, fontSize: 14),
        ),
        backgroundColor: Colors.blueAccent,
        splashColor: Colors.white24,
        elevation: 6,
      ),
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
