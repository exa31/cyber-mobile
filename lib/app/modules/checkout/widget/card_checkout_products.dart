import 'package:cyber/app/modules/cart/controllers/cart_controller.dart';
import 'package:cyber/helper/main.dart';
import 'package:flutter/material.dart';

class CardCheckoutProducts extends StatelessWidget {
  const CardCheckoutProducts({
    super.key,
    required this.url,
    required this.index,
    required this.controller,
  });

  final CartController controller;
  final int index;
  final String url;

  @override
  Widget build(BuildContext context) {
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
          "$url/images${controller.products[index].product.imageThumbnail}",
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/no_image.jpg',
            fit: BoxFit.cover,
          ),
          fit: BoxFit.cover,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.products[index].product.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            Text(
              Helper.formatPrice(controller.products[index].product.price),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
