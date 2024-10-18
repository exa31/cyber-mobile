import 'package:cyber/app/modules/cart/widget/card_cart_products.dart';
import 'package:cyber/app/modules/cart/widget/cart_isEmpty_widget.dart';
import 'package:cyber/helper/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:get/get.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  CartView({super.key});

  final CartController cartController = Get.find<CartController>();
  final url = dotenv.env['BASE_URL'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Shopping Cart'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: GetBuilder(
              init: cartController,
              builder: (controller) {
                return controller.products.isEmpty
                    ? CartIsEmptyWidget()
                    : ListView.separated(
                        itemCount: controller.products.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 20);
                        },
                        itemBuilder: (context, index) {
                          return CardCartproduct(
                              url: url.toString(),
                              index: index,
                              controller: controller);
                        },
                      );
              },
            ),
          ),
        ));
  }
}
