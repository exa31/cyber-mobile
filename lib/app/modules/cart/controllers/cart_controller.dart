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

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    var url = dotenv.env['BASE_URL'];
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      log('fetching cart');
      log(prefs.getString('token')!);
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
          log(products.length.toString());
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
}
