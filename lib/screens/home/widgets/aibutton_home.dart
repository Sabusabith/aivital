import 'package:ai_vital/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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

    _hoverAnimation = Tween<double>(begin: -5, end: 10).animate(
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
        return Transform.translate(
          offset: Offset(0, _hoverAnimation.value),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              splashColor: kprimerycolor,
              highlightColor: ksecondarycolor,
              onTap: () {
                Get.toNamed("/chat");
              },
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Lottie.asset(
                    animate: true,

                    "assets/images/robo.json",
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
