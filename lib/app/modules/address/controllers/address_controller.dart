import 'dart:developer';

import 'package:cyber/app/data/models/address_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressController extends GetxController {
  //TODO: Implement AddressController
  Dio dio = Dio();
  List<AddressModel>? addresses;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    getAddress();
  }

  Future<void> getAddress() async {
    String url = dotenv.env['BASE_URL']!;
    isLoading = true;
    update();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    try {
      var response = await dio.get(
        '$url/api/delivery-addresses',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        addresses = List.from(
          data.map(
            (e) => AddressModel.fromJson(e),
          ),
        );
        log(data.toString());
      }
      isLoading = false;
      update();
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) {
        addresses = [];
        isLoading = false;
        update();
      }
    }
  }
}
