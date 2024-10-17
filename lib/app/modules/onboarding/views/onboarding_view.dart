import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

import '../../../routes/app_pages.dart';

class OnboardingView extends StatelessWidget {
  OnboardingView({super.key});

  final List<Map<String, dynamic>> contents = [
    {
      'title': 'Shop apple products',
      'image': 'assets/images/onboarding1.png',
      'description':
          'Discover a world of convenience and endless choices. Get ready to experience the best of Apple products right at your fingertips, from cutting-edge devices to seamless digital experiences.'
    },
    {
      'title': 'Get IT Delivered',
      'image': 'assets/images/onboarding2.png',
      'description':
          'Discover a world of convenience and endless choices  Get ready to experience the best of online shopping right at your fingertips.'
    },
    {
      'title': 'Flexible payment',
      'image': 'assets/images/onboarding3.png',
      'description':
          'Discover a world of convenience and endless choices  Get ready to experience the best of online shopping right at your fingertips.'
    }
  ];

  final controller = Get.find<OnboardingController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: 3,
                controller: controller.pageController,
                onPageChanged: (index) {
                  controller.pagesIndex.value = index;
                },
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 49, 49, 49),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        )),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 100),
                    child: Column(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Image.asset(
                              contents[index]['image'],
                              width: 300,
                              height: 300,
                            ),
                            Text(
                              contents[index]['title'],
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              contents[index]['description'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 60, left: 20),
                  child: Row(
                    children: List.generate(
                      3,
                      (index) {
                        return Obx(
                          () => InkWell(
                            onTap: () {
                              controller.onTap(index);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              margin: const EdgeInsets.all(5),
                              width: controller.pagesIndex.value == index
                                  ? 30
                                  : 10,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: controller.pagesIndex.value == index
                                    ? Colors.black
                                    : Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Obx(
                      () => controller.pagesIndex.value + 1 == 3
                          ? Container(
                              margin: const EdgeInsets.all(35),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                    left: 30,
                                    right: 30,
                                  ),
                                  side:
                                      BorderSide(color: Colors.black, width: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () {
                                  Get.offNamed(Routes.STARTED);
                                },
                                child: Text('Get Started',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    )),
                              ),
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(
                                    35,
                                  ),
                                  shape: CircleBorder(),
                                  backgroundColor: Colors.white),
                              onPressed: () {
                                log('${controller.pagesIndex.value}');
                                controller.nextPage();
                              },
                              child: Icon(
                                Icons.arrow_forward,
                                size: 60,
                                color: Colors.black,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
