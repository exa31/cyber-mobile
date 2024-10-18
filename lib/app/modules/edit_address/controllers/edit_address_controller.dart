import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAddressController extends GetxController {
  //TODO: Implement EditAddressController
  bool isLoading = false;
  Dio dio = Dio();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getData() async {
    String url = dotenv.env['BASE_URL']!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    String id = Get.parameters['id']!;
    isLoading = true;
    update();
    try {
      var response = await dio.get(
        '$url/api/delivery-addresses/$id',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        var data = response.data;
        print(data);
      }
    } catch (e) {}
  }
}
