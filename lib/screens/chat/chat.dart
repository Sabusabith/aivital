import 'package:ai_vital/core/constants/app_colors.dart';
import 'package:ai_vital/screens/chat/controller/chat_controller.dart';
import 'package:ai_vital/screens/chat/widgets/chatbubble.dart';
import 'package:ai_vital/screens/chat/widgets/send_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.find<ChatController>();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Listen for message updates and auto-scroll
    ever(controller.messages, (_) {
      // Wait a bit so new widget is built, then scroll
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const SizedBox(height: 10),
            Text(
              "AI Symptom Analyzer",
              style: GoogleFonts.publicSans(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                letterSpacing: 0.5,
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
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
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
                gradient: const LinearGradient(
                  colors: [kprimerycolor, Color.fromARGB(255, 76, 168, 244)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      focusNode: _focusNode,
                      cursorColor: Colors.blue,
                      style: GoogleFonts.publicSans(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      controller: controller.textController,
                      onTap: _scrollToBottom, // Scroll when user opens keyboard
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
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.white24),
                        ),
                        filled: true,
                        fillColor: Colors.white30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SendButton(
                    onPressed: () {
                      controller.sendMessage();
                      FocusScope.of(context).unfocus(); // hide keyboard
                      Future.delayed(
                        const Duration(milliseconds: 300),
                        _scrollToBottom,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
