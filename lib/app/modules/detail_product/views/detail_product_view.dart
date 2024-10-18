import 'package:cyber/app/modules/cart/controllers/cart_controller.dart';
import 'package:cyber/app/modules/detail_product/controllers/detail_product_controller.dart';
import 'package:cyber/app/modules/detail_product/widget/detail_product_widget.dart';
import 'package:cyber/app/modules/home/widget/card_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../widget/list_image_preview_widget.dart';

class DetailProductView extends StatelessWidget {
  DetailProductView({
    super.key,
  });

  final url = dotenv.env['BASE_URL'].toString();

  final DetailProductController detailProductController =
      Get.find<DetailProductController>();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await detailProductController.onRefresh();
        },
        child: GetBuilder<DetailProductController>(
          init: detailProductController,
          builder: (controller) => controller.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  controller: controller.scroll,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            "$url/images/${controller.activeImage}",
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/no_image.jpg',
                                width: double.infinity,
                                height: 350,
                                fit: BoxFit.cover,
                              );
                            },
                            width: double.infinity,
                            height: 350,
                          ),
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 30, left: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DetailProduct(
                              detailProductController: controller,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                controller.imageDetails!.length,
                                (index) {
                                  return ListImagePreview(
                                    index: index,
                                    detailProductController: controller,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            ReadMoreText(
                              controller.product!.description,
                              trimLines: 3,
                              trimMode: TrimMode.Line,
                              moreStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                              lessStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Another Products",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            // Bungkus GridView.builder dengan Container dan atur tinggi
                            GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: List.generate(
                                controller.products.length,
                                (index) => CardProductWidget(
                                  imageThumbnail:
                                      controller.products[index].imageThumbnail,
                                  id: controller.products[index].id,
                                  name: controller.products[index].name,
                                  price: controller.products[index].price,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: controller.isLoadingEnd
                            ? CircularProgressIndicator()
                            : SizedBox(),
                      ),
                    ],
                  ),
                ),
        ),
      ),
      bottomNavigationBar: GetBuilder(
        init: detailProductController,
        builder: (controller) => controller.isLoading
            ? SizedBox()
            : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (controller.isLoadingAddToCart) return;
                    await controller.addToCart(id: controller.product!.id);
                    cartController.fetchCart();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)),
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text("Add to Cart",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
      ),
    );
  }
}
