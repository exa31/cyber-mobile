import 'dart:developer';

import 'package:cyber/app/data/models/respon_midtrans_model.dart';
import 'package:cyber/app/modules/cart/controllers/cart_controller.dart';
import 'package:cyber/app/modules/select_addresses/controllers/select_addresses_controller.dart';
import 'package:cyber/app/routes/app_pages.dart';
import 'package:dio/dio.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
// import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutController extends GetxController {
  //TODO: Implement CheckoutController

  int tax = 200000;
  int shipping = 20000;
  String url = dotenv.env['BASE_URL'].toString();
  Dio dio = Dio();
  int total = 0;
  int discount = 0;
  // MidtransSDK? midtrans;
  final CartController cartController = Get.find<CartController>();
  final SelectAddressesController selecteAddressController =
      Get.find<SelectAddressesController>();

  @override
  void onInit() {
    super.onInit();
    total = cartController.totalCart + tax + shipping;
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> checkout() async {
    try {
      var url = dotenv.env['BASE_URL'].toString();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token')!;
      var response = await dio.post(
        "$url/api/orders",
        data: {
          'total': total,
          'subTotal': cartController.totalCart,
          'tax': tax,
          'shipping': shipping,
          'discount': discount,
          'deliveryAddress': selecteAddressController.currentAddressOption,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      var midtrans = ResponMidtransModel.fromJson(response.data);
      cartController.clearCart();
      Get.offNamedUntil(Routes.SNAP_WEBVIEW, (route) => route.isFirst,
          arguments: {
            'token': midtrans.token,
            'redirectUrl': midtrans.redirectUrl,
          });
    } on DioException catch (e) {
      Get.snackbar('Error', 'Error Checkout');
      log(e.toString());
      log(e.response!.data.toString());
    }
  }

  // void initSDK() async {
  //   var config = MidtransConfig(
  //     clientKey: dotenv.env['MIDTRANS_CLIENT_KEY'].toString(),
  //     merchantBaseUrl: dotenv.env['MIDTRANS_MERCHANT_BASE_URL'].toString(),
  //   );
  //   midtrans = await MidtransSDK.init(
  //     config: config,
  //   );
  //   midtrans?.setUIKitCustomSetting(skipCustomerDetailsPages: true);
  //   midtrans?.setTransactionFinishedCallback(
  //     (result) {
  //       Get.snackbar('Success', 'Transaction Success');
  //       log(result.toString());
  //     },
  //   );
  // }
}
