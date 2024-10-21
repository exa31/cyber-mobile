import 'package:cyber/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

class BarCategoriesWidget extends StatelessWidget {
  const BarCategoriesWidget({super.key, required this.homeController});
  final HomeController homeController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          homeController.categories.length,
          (index) => InkWell(
            onTap: () {
              homeController.selectCategory(
                  name: homeController.categories[index].name);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: homeController.categories[index].name ==
                        homeController.activeCategory
                    ? Colors.black
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                homeController.categories[index].name,
                style: TextStyle(
                  fontSize: 15,
                  color: homeController.categories[index].name ==
                          homeController.activeCategory
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
