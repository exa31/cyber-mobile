import 'package:cyber/app/modules/home/controllers/home_controller.dart';
import 'package:cyber/app/modules/home/widget/card_product_widget.dart';
import 'package:cyber/app/modules/home/widget/skeleton_products_like_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class WishlistPages extends StatelessWidget {
  const WishlistPages({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wishlist',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          homeController.onInit();
        },
        child: GetBuilder(
          init: homeController,
          builder: (controller) => controller.isLoading
              ? SkeletonProductsLikeWidget()
              : controller.listLikes.isEmpty
                  ? Center(
                      child: Text('No wishlist'),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: List.generate(
                          homeController.listLikes.length,
                          (index) => CardProductWidget(
                            homeController: controller,
                            like: homeController.listLikes.any((product) =>
                                product.id ==
                                homeController.listLikes[index].id),
                            imageThumbnail:
                                homeController.listLikes[index].imageThumbnail,
                            id: homeController.listLikes[index].id,
                            name: homeController.listLikes[index].name,
                            price: homeController.listLikes[index].price,
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
