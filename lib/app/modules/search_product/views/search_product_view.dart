import 'package:cyber/app/modules/home/controllers/home_controller.dart';
import 'package:cyber/app/modules/home/widget/bar_categories.widget.dart';
import 'package:cyber/app/modules/home/widget/card_product_widget.dart';
import 'package:cyber/app/modules/home/widget/skeleton_categories_widget.dart';
import 'package:cyber/app/modules/search_product/widgets/skelaton_products_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchProductView extends StatelessWidget {
  const SearchProductView({super.key});
  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () async {
            homeController.cancelToken.cancel();
            if (homeController.activeCategory.isNotEmpty) {
              await homeController.fetchProductsByCategory(
                  name: homeController.activeCategory);
            } else {
              await homeController.fetchProducts();
            }

            Get.back();
          },
        ),
        title: const Text('Search Product'),
        centerTitle: true,
      ),
      body: GetBuilder(
          init: homeController,
          builder: (controller) {
            return RefreshIndicator(
              onRefresh: () async {
                homeController.onInit();
              },
              child: SingleChildScrollView(
                controller: controller.scrollSearch,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Hero(
                              tag: 'searchField',
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  child: TextField(
                                    autofocus: true,
                                    onSubmitted: (value) async {
                                      controller.fetchProductsBySearch(
                                          name: value);
                                    },
                                    controller: controller.searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Search Products...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          controller.searchController.text.isEmpty
                              ? SizedBox()
                              : IconButton(
                                  onPressed: () {
                                    controller.searchController.clear();
                                    controller.fetchProducts();
                                  },
                                  icon: Icon(Icons.close)),
                          IconButton(
                            onPressed: () async {
                              controller.fetchProductsBySearch(
                                  name: controller.searchController.text);
                            },
                            icon: Icon(Icons.search),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20),
                      controller.isLoadingCategory
                          ? SkeletonCategoriesWidget()
                          : BarCategoriesWidget(
                              homeController: controller,
                            ),
                      SizedBox(height: 20),
                      controller.isLoading
                          ? SkelatonProductsSearchWidget()
                          : controller.products.isEmpty
                              ? Center(child: Text('No products found'))
                              : GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  mainAxisSpacing: 10,
                                  children: List.generate(
                                    controller.products.length,
                                    (index) => CardProductWidget(
                                      homeController: controller,
                                      like: controller.listLikes.any(
                                          (product) =>
                                              product.id ==
                                              controller.products[index].id),
                                      imageThumbnail: controller
                                          .products[index].imageThumbnail,
                                      id: controller.products[index].id,
                                      name: controller.products[index].name,
                                      price: controller.products[index].price,
                                    ),
                                  ),
                                ),
                      Center(
                          child: controller.isLoadingEnd
                              ? CircularProgressIndicator()
                              : SizedBox()),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
