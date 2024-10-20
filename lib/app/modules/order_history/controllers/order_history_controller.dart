import 'dart:developer';

import 'package:cyber/app/data/models/order_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistoryController extends GetxController {
  //TODO: Implement OrderHistoryController
  List<OrderModel> orders = [];
  bool loading = true;
  Dio dio = Dio();

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  Future<void> getOrders() async {
    try {
      String url = dotenv.env['BASE_URL']!;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token')!;
      var response = await dio.get(
        '$url/api/orders',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      log(response.data.toString());
      if (response.statusCode == 200) {
        orders = List<OrderModel>.from(
            response.data.map((x) => OrderModel.fromJson(x)));
        loading = false;
        update();
      }
    } on DioException catch (e) {
      log(e.response!.data.toString());
    }
  }
}
