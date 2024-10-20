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
    loading = true;
    getOrders();
  }

  Future<void> getOrders() async {
    try {
      String url = dotenv.env['BASE_URL']!;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token')!;
      loading = true;
      var response = await dio.get(
        '$url/api/orders',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        orders = List<OrderModel>.from(
            response.data.map((order) => OrderModel.fromJson(order)));
        loading = false;
        update();
      }
    } on DioException catch (e) {
      log(e.response!.data.toString());
      loading = false;
      Get.snackbar('Error', 'Opps, something went wrong please refresh');
      update();
    }
  }
}
