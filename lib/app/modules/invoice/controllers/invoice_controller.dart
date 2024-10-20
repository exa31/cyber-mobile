import 'dart:developer';

import 'package:cyber/app/data/models/invoice_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceController extends GetxController {
  //TODO: Implement InvoiceController
  InvoiceModel? invoice;
  Dio dio = Dio();
  int subtotal = 0;
  bool loading = true;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? formattedDate;

  @override
  void onInit() {
    super.onInit();
    getInvoice();
  }

  Future<void> getInvoice() async {
    try {
      String url = dotenv.env['BASE_URL']!;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token')!;
      String param = Get.parameters['id']!;
      var response = await dio.get(
        '$url/api/invoices/$param',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        invoice = InvoiceModel.fromJson(response.data);
        subtotal = invoice!.total - invoice!.tax - invoice!.shipping;
        createdAt = DateTime.parse(invoice!.order.createdAt);
        updatedAt = DateTime.parse(invoice!.order.updatedAt);
        if (createdAt != null && updatedAt != null) {
          formattedDate = DateFormat('dd MMMM yyyy').format(
            createdAt == updatedAt ? createdAt! : updatedAt!,
          );
        }
        loading = false;
        update();
      }
    } on DioException catch (e) {
      log(e.response!.data.toString());
      Get.back();
    }
  }
}
