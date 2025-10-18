import 'dart:async';
import 'dart:math';
import 'package:ai_vital/core/constants/app_colors.dart';
import 'package:ai_vital/core/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  Rx<Color> iconColor = kprimerycolor.obs;
  Rx<int> animationIndex = 0.obs;

  final List<Color> _colors = [kprimerycolor, Color(0xFF4CAF50), Colors.orange];

  final List<String> _animations = [
    'assets/animations/health1.json',
    'assets/animations/health2.json',
    'assets/animations/health3.json',
  ];

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    // Change color & animation every 500ms
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (_) {
      iconColor.value = _colors[Random().nextInt(_colors.length)];
      animationIndex.value = Random().nextInt(_animations.length);
    });

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      _timer?.cancel();
      Get.offAllNamed(Routes.ONBOARDING);
    });
  }

  String get currentAnimation => _animations[animationIndex.value];
}
