import 'dart:developer';

import 'package:cyber/app/data/models/product_model.dart';
import 'package:cyber/app/modules/cart/controllers/cart_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProductController extends GetxController {
  //TODO: Implement DetailProductController
  Dio dio = Dio();
  bool isLoading = true;
  bool isLoadingAddToCart = false;
  String activeImage = '';
  ProductModel? product;
  List<ProductModel> products = [];
  List<String>? imageDetails;
  String param = Get.parameters['id'].toString();
  int totalProducts = 0;
  bool isLoadingEnd = false;
  ScrollController scroll = ScrollController();
  final CartController cartController = Get.find<CartController>();

  @override
  void onInit() {
    super.onInit();
    isLoading = true;
    scroll.addListener(
      () async {
        if (scroll.position.maxScrollExtent == scroll.position.pixels &&
            products.length != totalProducts &&
            isLoadingEnd != true &&
            scroll.position.atEdge) {
          isLoadingEnd = true;
          await addFetchAnotherProducts();
        }
      },
    );
    fetchAllFirst();
  }

  Future<void> fetchAllFirst() async {
    try {
      await fetchSingleProduct();
      await fetchAnotherProducts();
      isLoading = false;
      update();
    } catch (e) {
      Get.snackbar('Error', 'Opps, something went wrong');
      Get.back();
      print(e);
    }
  }

  void changeActiveImage(String image) {
    activeImage = image;
    update();
  }

  Future<void> fetchSingleProduct() async {
    String url = dotenv.env['BASE_URL'].toString();
    var id = Get.parameters['id'];
    try {
      final response = await dio.get('$url/api/products/${id.toString()}');
      product = ProductModel.fromJson(response.data);
      activeImage = product!.imageThumbnail;
      imageDetails = List.from(product!.imageDetails);
      imageDetails!.add(product!.imageThumbnail);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> fetchAnotherProducts() async {
    String url = dotenv.env['BASE_URL'].toString();
    var id = Get.parameters['id'];
    try {
      final response = await dio.get(
          '$url/api/products?id=${id.toString()}&limit=4&category=${product!.category}');
      List<dynamic> data = response.data['products'];
      totalProducts = response.data['count'];
      products = List.from(
        data.map(
          (e) {
            return ProductModel.fromJson(e);
          },
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addFetchAnotherProducts() async {
    String url = dotenv.env['BASE_URL'].toString();
    var id = Get.parameters['id'];
    isLoadingEnd = true;
    update();
    try {
      final response = await dio.get(
          "$url/api/products?id=${id.toString()}&limit=4&category=${product!.category}&skip=${products.length}");
      List<dynamic> data = response.data['products'];
      var filterData = data.map((e) {
        return ProductModel.fromJson(e);
      });
      products.addAll(
        List.from(
          filterData,
        ),
      );
      isLoadingEnd = false;
      update();
    } catch (e) {
      Get.snackbar('Error', 'Opps, something went wrong');
      isLoadingEnd = false;
      log(e.toString());
    }
  }

  Future<void> addToCart({required String id}) async {
    String url = dotenv.env['BASE_URL'].toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    isLoadingAddToCart = true;
    update();
    try {
      var res = await dio.post(
        '$url/api/carts',
        data: {
          'productId': id,
          'quantity': 1,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      isLoadingAddToCart = false;
      if (res.statusCode == 200) {
        cartController.fetchCart();
        update();
        Get.snackbar('Success', 'Product added to cart');
      }
      update();
      Get.snackbar('Success', 'Product added to cart');
    } on DioException catch (e) {
      isLoadingAddToCart = false;
      update();
      Get.snackbar('Error', 'Opps, something went wrong when adding to cart');
      log(e.response!.data.toString());
    }
  }

  Future<void> onRefresh() async {
    isLoading = true;
    products = [];
    await fetchAllFirst();
    isLoading = false;
    update();
  }
}
