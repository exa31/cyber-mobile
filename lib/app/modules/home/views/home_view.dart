import 'package:cyber/app/modules/auth/views/started_view.dart';
import 'package:cyber/app/modules/home/views/pages/home_pages.dart';
import 'package:cyber/app/modules/home/views/pages/profile_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final homeController = Get.find<HomeController>();

  final page = [
    HomePages(),
    HomePages(),
    ProfilePages(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
          init: homeController,
          builder: (HomeController controller) => page[controller.indexPage]),
      bottomNavigationBar: GetBuilder(
        init: homeController,
        builder: (controller) => BottomNavigationBar(
          onTap: (value) => controller.changePage(value),
          currentIndex: controller.indexPage,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.amber[800],
        ),
      ),
    );
  }
}
