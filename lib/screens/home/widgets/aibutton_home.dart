import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAILottieChat extends StatefulWidget {
  const HomeAILottieChat({super.key});

  @override
  State<HomeAILottieChat> createState() => _HomeAILottieChatState();
}

class _HomeAILottieChatState extends State<HomeAILottieChat>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();

    // Floating up and down animation
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _hoverAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Positioned(
          bottom: 50 + _hoverAnimation.value,
          right: 16,
          child: GestureDetector(
            onTap: () {
              Get.toNamed("/chat");
            },
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                // Chat Bubble
                // Positioned(
                //   bottom: 10,
                //   left: -40, // above the robot
                //   child: Container(
                //     constraints: BoxConstraints(maxWidth: 200),
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 16,
                //       vertical: 12,
                //     ),
                //     decoration: BoxDecoration(
                //       color: Colors.white24,
                //       borderRadius: BorderRadius.circular(20),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black26,
                //           blurRadius: 8,
                //           offset: Offset(0, 4),
                //         ),
                //       ],
                //     ),
                //     child: Text(
                //       "Hi!",
                //       style: GoogleFonts.publicSans(
                //         color: Colors.black87,
                //         fontSize: 14,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                // ),

                // Bubble Tail

                // Lottie Robot inside circle
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Lottie.asset(
                      "assets/images/robo.json",
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
