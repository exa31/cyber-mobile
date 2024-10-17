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
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_rounded),
              onPressed: () {
                // Tambahkan aksi yang ingin dilakukan saat ikon ditekan
                Get.snackbar('Info', 'Shopping cart icon pressed');
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: ListView.separated(
              itemCount: cartController.products.length,
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 20);
              },
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Image.network(
                      "$url/images${cartController.products[index].product.imageThumbnail}",
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartController.products[index].product.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          Helper.formatPrice(
                              cartController.products[index].product.price),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            // Tambahkan aksi yang ingin dilakukan saat ikon ditekan
                            Get.snackbar('Info', 'Remove icon pressed');
                          },
                        ),
                        Text(
                          cartController.products[index].quantity.toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline_sharp),
                          onPressed: () {
                            // Tambahkan aksi yang ingin dilakukan saat ikon ditekan
                            Get.snackbar('Info', 'Add icon pressed');
                          },
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete_rounded),
                      onPressed: () {
                        Get.snackbar('Info', 'Delete icon pressed');
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ));
  }
}
