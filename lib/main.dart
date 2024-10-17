import 'package:cyber/app/modules/auth/controllers/auth_controller.dart';
import 'package:cyber/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final String initialRoute = await determineInitialRoute();
  Get.put(HomeController(), permanent: true);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(Duration(seconds: 5), () {
    FlutterNativeSplash.remove();
  });

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    ),
  );
}

Future<String> determineInitialRoute() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  bool valid = await AuthController.validToken();
  if (token != null && token.isNotEmpty && valid) {
    return Routes.HOME;
  } else {
    return Routes.LOGIN;
  }
}