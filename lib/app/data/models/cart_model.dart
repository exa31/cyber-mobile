import 'dart:developer';

import 'package:cyber/app/data/models/product_cart_model.dart';

class CartModel {
  CartModel({
    required this.product,
    required this.quantity,
  });

  ProductCartModel product;
  int quantity;

  factory CartModel.fromJson(Map<dynamic, dynamic> json) {
    log(json.toString());
    return CartModel(
      product: ProductCartModel.fromJson(json["product"]),
      quantity: json["quantity"],
    );
  }
}
