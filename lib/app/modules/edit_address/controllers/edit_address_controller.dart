import 'dart:developer';

import 'package:cyber/app/data/models/address_model.dart';
import 'package:cyber/app/data/models/wilayah_model.dart';
import 'package:cyber/app/modules/address/controllers/address_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAddressController extends GetxController {
  //TODO: Implement EditAddressController
  bool isLoading = true;
  bool isLoadingUpdate = false;
  Dio dio = Dio();
  AddressModel? address;
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

  final AddressController addressController = Get.find<AddressController>();

  @override
  void onInit() {
    super.onInit();
    getData();
    getProvinces();
  }

  Future<void> updateAddress() async {
    String url = dotenv.env['BASE_URL']!;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    String id = Get.parameters['id']!;
    isLoadingUpdate = true;
    update();
    try {
      var response = await dio.put(
        '$url/api/delivery-addresses/$id',
        data: {
          "name": nameController.text,
          "provinsi": provinceController.text.isEmpty
              ? address!.provinsi
              : provinceController.text,
          "kabupaten": kotaController.text.isEmpty
              ? address!.kabupaten
              : kotaController.text,
          "kecamatan": kecController.text.isEmpty
              ? address!.kecamatan
              : kecController.text,
          "kelurahan": kelController.text.isEmpty
              ? address!.kelurahan
              : kelController.text,
          "detail": detailController.text,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        await addressController.getAddress();
        Get.back();
      }
    } catch (e) {
      log(e.toString());
      Get.snackbar('Error', 'Something went wrong when updating address');
    } finally {
      isLoadingUpdate = false;
      update();
    }
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
        address = AddressModel.fromJson(data);
        nameController.text = address!.name;
        detailController.text = address!.detail;
      }
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading = false;
      update();
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
