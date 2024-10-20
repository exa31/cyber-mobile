import 'package:cyber/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Error appeared.",
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Reload the current route
                Get.reload();
              },
              child: Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  };
  await dotenv.load(fileName: ".env");
  final String initialRoute = await determineInitialRoute();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(Duration(seconds: 3), () {
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
  // bool valid = await AuthController.validToken();
  if (token != null && token.isNotEmpty) {
    Get.put(HomeController(), permanent: true);
    return Routes.HOME;
  } else {
    return Routes.ONBOARDING;
  }
}
