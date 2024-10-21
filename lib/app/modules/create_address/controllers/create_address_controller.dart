import 'dart:developer';

import 'package:cyber/app/data/models/wilayah_model.dart';
import 'package:cyber/app/modules/address/controllers/address_controller.dart';
import 'package:cyber/app/modules/select_addresses/controllers/select_addresses_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateAddressController extends GetxController {
  //TODO: Implement CreateAddressController
  Dio dio = Dio();

  TextEditingController nameController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController kotaController = TextEditingController();
  TextEditingController kecController = TextEditingController();
  TextEditingController kelController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  List<WilayahModel> provinces = [];
  List<WilayahModel> kota = [];
  List<WilayahModel> kec = [];
  List<WilayahModel> kel = [];
  bool isLoadingProvince = true;
  bool isLoadingKota = true;
  bool isLoadingKec = true;
  bool isLoadingKel = true;
  bool isSubmit = false;

  @override
  void onInit() {
    super.onInit();
    getProvinces();
  }

  @override
  void onClose() {
    nameController.dispose();
    provinceController.dispose();
    kotaController.dispose();
    kecController.dispose();
    kelController.dispose();
    detailController.dispose();
  }

  Future<void> createAddress() async {
    String url = dotenv.env['BASE_URL']!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isSubmit = true;
    try {
      var response = await dio.post(
        "$url/api/delivery-addresses",
        options: Options(
          headers: {
            "Authorization": "Bearer ${prefs.getString('token')}",
          },
        ),
        data: {
          "provinsi": provinceController.text,
          "kabupaten": kotaController.text,
          "kecamatan": kecController.text,
          "kelurahan": kelController.text,
          "detail": detailController.text,
          "name": nameController.text
        },
      );
      if (response.statusCode == 201) {
        if (Get.arguments != null) {
          final SelectAddressesController selectAddressesController =
              Get.find<SelectAddressesController>();
          isSubmit = false;
          await selectAddressesController.getAddress();
        } else {
          final AddressController addressController =
              Get.find<AddressController>();
          await addressController.getAddress();
        }
        Get.back();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getProvinces() async {
    try {
      isLoadingProvince = true;
      update();
      final response = await dio.get(
          'https://exa31.github.io/api-wilayah-indonesia/api/provinces.json');

      final List<dynamic> data = response.data;
      provinces = List.from(data.map((e) => WilayahModel.fromJson(e)));
      update();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoadingProvince = false;
      update();
    }
  }

  Future<void> getKota({required id}) async {
    try {
      isLoadingKota = true;
      update();
      final response = await dio.get(
          'https://exa31.github.io/api-wilayah-indonesia/api/regencies/$id.json');

      final List<dynamic> data = response.data;
      kota = List.from(data.map((e) => WilayahModel.fromJson(e)));
      update();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoadingKota = false;
      update();
    }
  }

  Future<void> getKec({required id}) async {
    try {
      isLoadingKec = true;
      update();
      final response = await dio.get(
          'https://exa31.github.io/api-wilayah-indonesia/api/districts/$id.json');
      final List<dynamic> data = response.data;
      kec = List.from(data.map((e) => WilayahModel.fromJson(e)));
      update();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoadingKec = false;
      update();
    }
  }

  Future<void> getKel({required id}) async {
    try {
      isLoadingKel = true;
      update();
      final response = await dio.get(
          'https://exa31.github.io/api-wilayah-indonesia/api/villages/$id.json');
      final List<dynamic> data = response.data;
      kel = List.from(data.map((e) => WilayahModel.fromJson(e)));
      update();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoadingKel = false;
      update();
    }
  }
}
