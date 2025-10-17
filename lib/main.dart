import 'package:ai_vital/core/constants/app_theme.dart';
import 'package:ai_vital/core/routes/app_pages.dart';
import 'package:ai_vital/screens/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get_navigation/src/root/get_material_app.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized(); // ensure bindings before async
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
