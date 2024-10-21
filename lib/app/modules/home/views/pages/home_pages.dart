import 'package:cyber/app/modules/cart/controllers/cart_controller.dart';
import 'package:cyber/app/modules/home/controllers/home_controller.dart';
import 'package:cyber/app/modules/home/widget/bar_categories.widget.dart';
import 'package:cyber/app/modules/home/widget/card_product_widget.dart';
import 'package:cyber/app/modules/home/widget/skeleton_categories_widget.dart';
import 'package:cyber/app/modules/home/widget/skeleton_products_widget.dart';
import 'package:cyber/app/modules/home/widget/top_bar_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePages extends StatelessWidget {
  HomePages({super.key});

  final HomeController homeController = Get.find<HomeController>();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            homeController.onInit();
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello ${homeController.name!.split(' ')[0]}',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600)),
                        Text(
                          'Welcome to cyber',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Get.toNamed('/cart');
                      },
                      icon: Stack(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.grey,
                            size: 30,
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle),
                              child: GetBuilder(
                                init: cartController,
                                builder: (controller) => Text(
                                  controller.products.length.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                TopBarSearchWidget(),
                SizedBox(height: 20),
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20),
                GetBuilder(
                  init: homeController,
                  builder: (controller) => controller.isLoadingCategory
                      ? SkeletonCategoriesWidget()
                      : BarCategoriesWidget(
                          homeController: controller,
                        ),
                ),
                SizedBox(height: 20),
                GetBuilder(
                  init: homeController,
                  builder: (controller) => controller.isLoading
                      ? SkeletonProductsWidget()
                      : Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            controller: homeController.scrollHome,
                            mainAxisSpacing: 10,
                            children: List.generate(
                              homeController.products.length,
                              (index) => CardProductWidget(
                                homeController: controller,
                                like: homeController.listLikes.any((product) =>
                                    product.id ==
                                    homeController.products[index].id),
                                imageThumbnail: homeController
                                    .products[index].imageThumbnail,
                                id: homeController.products[index].id,
                                name: homeController.products[index].name,
                                price: homeController.products[index].price,
                              ),
                            ),
                          ),
                        ),
                ),
                Center(
                  child: GetBuilder<HomeController>(
                    builder: (controller) {
                      return controller.isLoadingEnd
                          ? CircularProgressIndicator()
                          : SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
