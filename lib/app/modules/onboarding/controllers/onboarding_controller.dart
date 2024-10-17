import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  //TODO: Implement OnboardingController

  final pagesIndex = 0.obs;
  PageController pageController = PageController();

  void increment() => pagesIndex.value++;
  void decrement() => pagesIndex.value--;

  void onTap(int index) {
    pagesIndex.value = index;
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  void nextPage() {
    if (pagesIndex.value < 2) {
      pagesIndex.value++;
      pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }
}
