import 'dart:developer';

import 'package:cyber/app/data/models/category_model.dart';
import 'package:cyber/app/data/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  int indexPage = 0;
  List<ProductModel> products = [];
  List<CategoryModel> categories = [];
  Dio dio = Dio();

  int totalProducts = 0;
  bool isLoadingCategory = false;
  bool isLoading = false;
  bool isLoadingEnd = false;
  String? name;
  String? email;
  String? activeCategory;
  var scroll = ScrollController();
  CancelToken cancelToken = CancelToken();

  @override
  void onInit() {
    super.onInit();
    scroll.addListener(() {
      if (products.length < totalProducts &&
          isLoadingEnd != true &&
          scroll.position.pixels != 0 &&
          scroll.position.atEdge) {
        if (activeCategory != null && activeCategory!.isNotEmpty) {
          addFetchProductsByCategory();
        } else {
          addFetchProducts();
        }
      }
    });
    getProfile();
    fetchAllFirst();
  }

  void getProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name')!;
    email = prefs.getString('email')!;
  }

  void selectCategory({required String name}) async {
    if (activeCategory == name) {
      activeCategory = null;
      fetchProductsByCategory(name: '');
      update();
      return;
    }
    if (isLoading) {
      return;
    }
    activeCategory = name;
    fetchProductsByCategory(name: name);
    update();
  }

  Future<void> fetchAllFirst() async {
    try {
      await Future.wait([
        fetchCategories(),
        fetchProducts(),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Opps, something went wrong');
      print(e);
    }
  }

  Future<void> fetchProducts() async {
    String url = dotenv.env['BASE_URL'].toString();
    isLoading = true;
    update();
    try {
      var res = await dio.get('$url/api/products?limit=8');
      if (res.statusCode == 200) {
        List<dynamic> data = res.data['products'];
        totalProducts = res.data['count'];
        products =
            List.from(data.map((product) => ProductModel.fromJson(product)));
        log('jalan');
        isLoading = false;
        update();
      } else {
        Get.snackbar('Error', 'Opps, something went wrong');
      }
    } catch (e) {
      log('error');
      print(e);
    }
  }

  Future<void> addFetchProducts() async {
    String url = dotenv.env['BASE_URL'].toString();
    isLoadingEnd = true;
    update();
    try {
      var res =
          await dio.get('$url/api/products?limit=8&skip=${products.length}');
      if (res.statusCode == 200) {
        List<dynamic> data = res.data['products'];
        var filterData = data.map((product) => ProductModel.fromJson(product));
        products.addAll(List.from(filterData));
        isLoadingEnd = false;
        update();
      } else {
        Get.snackbar('Error', 'Opps, something went wrong');
        addFetchProducts();
      }
    } catch (e) {
      Get.snackbar('Error', 'Opps, something went wrong');
      addFetchProducts();
      print(e);
    }
  }

  Future<void> addFetchProductsByCategory() async {
    String url = dotenv.env['BASE_URL'].toString();
    isLoadingEnd = true;
    update();
    try {
      log(products.length.toString());
      var res = await dio.get(
          '$url/api/products?limit=8&skip=${products.isNotEmpty ? products.length : 0}&category=$activeCategory');
      if (res.statusCode == 200) {
        List<dynamic> data = res.data['products'];
        var filterData = data.map((product) => ProductModel.fromJson(product));
        products.addAll(List.from(filterData));
        isLoadingEnd = false;
        update();
      } else {
        Get.snackbar('Error', 'Opps, something went wrong');
        addFetchProducts();
      }
    } catch (e) {
      Get.snackbar('Error', 'Opps, something went wrong');
      addFetchProducts();
      print(e);
    }
  }

  Future<void> fetchProductsByCategory({required String name}) async {
    String url = dotenv.env['BASE_URL'].toString();
    isLoading = true;
    update();
    try {
      var res = await dio.get('$url/api/products?category=$name&limit=8&');
      if (res.statusCode == 200) {
        List<dynamic> data = res.data['products'];
        totalProducts = res.data['count'];
        log('fetch by category');
        products =
            List.from(data.map((product) => ProductModel.fromJson(product)));
        isLoading = false;
        update();
      } else {
        Get.snackbar('Error', 'Opps, something went wrong');
      }
    } catch (e) {
      Get.snackbar('Error', 'Opps, something went wrong');
      print(e);
    }
  }

  Future<void> fetchCategories() async {
    String url = dotenv.env['BASE_URL'].toString();
    isLoadingCategory = true;
    update();
    try {
      log('test');
      var res = await dio.get('$url/api/categories');
      log('message');
      if (res.statusCode == 200) {
        List<dynamic> data = res.data;
        categories =
            List.from(data.map((category) => CategoryModel.fromJson(category)));
        isLoadingCategory = false;
        update();
      } else {
        Get.snackbar('Error', 'Opps, something went wrong');
      }
    } catch (e) {
      print(e);
    }
  }

  void changePage(int index) {
    indexPage = index;
    update();
  }
}
