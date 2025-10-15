import 'package:ai_vital/core/constants/app_colors.dart';
import 'package:ai_vital/screens/chat/controller/chat_controller.dart';
import 'package:ai_vital/screens/chat/widgets/chatbubble.dart';
import 'package:ai_vital/screens/chat/widgets/send_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatelessWidget {
  final ChatController controller = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFEEF5FF),
      appBar: AppBar(
        toolbarHeight: 85,
        backgroundColor: kprimerycolor,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "AI Symptom Checker",
              style: GoogleFonts.publicSans(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Get instant health suggestions",
              style: GoogleFonts.publicSans(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7FAFF), Color(0xFFE8F0FF), Color(0xFFDCE8FF)],
          ),
        ),

        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => Scrollbar(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final msg = controller.messages[index];
                      return ChatBubble(text: msg.text, isUser: msg.isUser);
                    },
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent,
                    const Color.fromARGB(255, 92, 166, 202),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // boxShadow: [
                //   BoxShadow(
                //     color: kprimerycolor.withOpacity(0.4),
                //     offset: const Offset(0, 4),
                //     blurRadius: 6,
                //   ),
                // ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              // color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      cursorColor: Colors.blue,
                      style: GoogleFonts.publicSans(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      controller: controller.textController,
                      decoration: InputDecoration(
                        hintText: "Describe your symptom...",
                        hintStyle: GoogleFonts.publicSans(
                          color: Colors.grey.shade700,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.white24),
                        ),
                        filled: true,
                        fillColor: Colors.white30,
                        // fillColor: Colors.white24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SendButton(onPressed: controller.sendMessage),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
