import 'package:flutter/material.dart';

class CartIsEmptyWidget extends StatelessWidget {
  const CartIsEmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
          ),
          Image.asset(
            'assets/images/empty_cart.png',
            width: 200,
          ),
          const SizedBox(height: 20),
          const Text(
            'Your cart is empty 😔😔😔',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
