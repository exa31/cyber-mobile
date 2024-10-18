import 'dart:developer';

import 'package:cyber/app/data/models/cart_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  //TODO: Implement CartController
  Dio dio = Dio();
  List<CartModel> products = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    var url = dotenv.env['BASE_URL'];
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var response = await dio.get('$url/api/carts',
          options: Options(headers: {
            'Authorization': 'Bearer ${prefs.getString('token')}',
          }));
      if (response.statusCode == 200) {
        List<dynamic> data = response.data["products"];
        if (data.isEmpty) {
          products = [];
          update();
        } else {
          products = List.from(
            data.map(
              (product) => CartModel.fromJson(product),
            ),
          );
          update();
        }
      }
    } on DioException catch (e) {
      log(e.response!.data.toString());
      if (e.response!.statusCode == 401) {
        Get.offAllNamed('/login');
      } else if (e.response!.statusCode == 404) {
        products = [];
      }
    }
  }

  Future<void> addToCart({required String id}) async {
    var url = dotenv.env['BASE_URL'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      isLoading = true;
      update();
      var response = await dio.post(
        '$url/api/carts',
        data: {
          'productId': id,
          'quantity': 1,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        products = products.where(
          (product) {
            if (product.product.id == id) {
              product.quantity += 1;
            }
            return true;
          },
        ).toList();
        isLoading = false;
        update();
      }
      Get.snackbar('Success', 'Product added to cart');
    } on DioException catch (e) {
      log(e.response!.data.toString());
      isLoading = false;
      update();
      Get.snackbar('Error', 'Opps, something went wrong when adding to cart');
    }
  }

  Future<void> reduceCart({required String id}) async {
    var url = dotenv.env['BASE_URL'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      isLoading = true;
      update();
      var response = await dio.post(
        '$url/api/carts/reduce',
        data: {
          'productId': id,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        products = products.where((element) {
          if (element.product.id == id) {
            element.quantity -= 1;
          } else if (element.quantity == 1) {
            return false;
          }
          return element.quantity > 0;
        }).toList();
        isLoading = false;
        update();
      }
      Get.snackbar('Success', 'Product reduce from cart');
    } on DioException catch (e) {
      log(e.response!.data.toString());
      isLoading = false;
      update();
      Get.snackbar(
          'Error', 'Opps, something went wrong when deleting from cart');
    }
  }

  Future<void> deleteCart({required String id}) async {
    var url = dotenv.env['BASE_URL'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    try {
      isLoading = true;
      update();
      var response = await dio.post(
        '$url/api/carts/remove',
        data: {
          'productId': id,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        products.removeWhere((element) => element.product.id == id);
        isLoading = false;
        update();
      }
      Get.snackbar('Success', 'Product deleted from cart');
    } on DioException catch (e) {
      log(e.response!.data.toString());
      isLoading = false;
      update();
      Get.snackbar(
          'Error', 'Opps, something went wrong when deleting from cart');
    }
  }
}
