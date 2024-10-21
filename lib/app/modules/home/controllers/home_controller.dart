import 'dart:developer';

import 'package:cyber/app/data/models/category_model.dart';
import 'package:cyber/app/data/models/product_like_model.dart';
import 'package:cyber/app/data/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  int indexPage = 0;
  List<ProductModel> products = [];
  List<CategoryModel> categories = [];
  Dio dio = Dio();
  List<ProductLikeModel> listLikes = [];
  int totalProducts = 0;
  TextEditingController searchController = TextEditingController();
  bool isLoadingCategory = false;
  bool isLoading = false;
  bool isLoadingEnd = false;
  String search = '';
  String? name;
  String? email;
  String activeCategory = '';
  var scrollHome = ScrollController();
  var scrollSearch = ScrollController();
  CancelToken cancelToken = CancelToken();

  @override
  void onInit() {
    super.onInit();
    searchController.clear();
    indexPage = 0;
    scrollHome.addListener(
      () {
        if (products.length < totalProducts &&
            isLoadingEnd != true &&
            scrollHome.position.pixels != 0 &&
            scrollHome.position.atEdge) {
          if (activeCategory.isNotEmpty) {
            addFetchProductsByCategory();
          } else {
            addFetchProducts();
          }
        }
      },
    );
    scrollSearch.addListener(
      () {
        if (products.length < totalProducts &&
            isLoadingEnd != true &&
            scrollSearch.position.pixels != 0 &&
            scrollSearch.position.atEdge) {
          log('add');
          addFetchProductsBySearch();
        }
      },
    );
    getProfile();
    getLikesProduct();
    fetchAllFirst();
  }

  void getProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name')!;
    email = prefs.getString('email')!;
  }

  void selectCategory({required String name}) async {
    if (activeCategory == name) {
      activeCategory = '';
      fetchProductsByCategory(name: '');
      update();
      searchController.clear();
      return;
    }
    if (isLoading) {
      return;
    }
    searchController.clear();
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
          '$url/api/products?limit=8&skip=${products.length}&category=$activeCategory');
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
      var res = await dio.get('$url/api/products?category=$name&limit=8');
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
      var res = await dio.get('$url/api/categories');
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
      fetchCategories();
      print(e);
    }
  }

  Future<void> fetchProductsBySearch({required String name}) async {
    String url = dotenv.env['BASE_URL'].toString();
    isLoading = true;
    update();
    try {
      var res = await dio.get(
          '$url/api/products?q=$name&limit=8&category=$activeCategory',
          cancelToken: cancelToken);
      if (res.statusCode == 200) {
        List<dynamic> data = res.data['products'];
        totalProducts = res.data['count'];
        log(res.data['count'].toString());
        log(totalProducts.toString());
        products =
            List.from(data.map((product) => ProductModel.fromJson(product)));
        isLoading = false;
        update();
      } else {
        Get.snackbar('Error', 'Opps, something went wrong');
      }
    } on DioException catch (e) {
      log((e.type.toString() == DioExceptionType.cancel.toString()).toString());
      if (cancelToken.isCancelled || e.type == DioExceptionType.cancel) {
        log('cancelled');
        isLoading = false;
        return;
      } else {
        log(e.toString());
        Get.snackbar('Error', 'Opps, something went wrong please refresh');
      }
    }
  }

  Future<void> addFetchProductsBySearch() async {
    String url = dotenv.env['BASE_URL'].toString();
    isLoadingEnd = true;
    update();
    try {
      var res = await dio.get(
          '$url/api/products?q=$search&limit=8&skip=${products.length}&category=$activeCategory');
      if (res.statusCode == 200) {
        List<dynamic> data = res.data['products'];
        var filterData = data.map((product) => ProductModel.fromJson(product));
        products.addAll(List.from(filterData));
        isLoadingEnd = false;
        update();
      } else {
        Get.snackbar('Error', 'Opps, something went wrong');
        addFetchProductsBySearch();
      }
    } on DioException catch (e) {
      if (cancelToken.isCancelled || e.type == DioExceptionType.cancel) {
        isLoadingEnd = false;
        update();
        return;
      }
      Get.snackbar('Error', 'Opps, something went wrong');
      addFetchProductsBySearch();
    }
  }

  void changePage(int index) {
    indexPage = index;
    update();
  }

  Future<void> getLikesProduct() async {
    String url = dotenv.env['BASE_URL'].toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    try {
      var res = await dio.get(
        '$url/api/likes',
        options: Options(headers: {
          'Authorization': "Bearer $token",
        }),
      );
      if (res.statusCode == 200) {
        List<dynamic> data = res.data;
        listLikes = List.from(
            data.map((product) => ProductLikeModel.fromJson(product)));
        update();
      } else {
        Get.snackbar('Error', 'Opps, something went wrong please refresh');
      }
    } catch (e) {
      Get.snackbar('Error', 'Opps, something went wrong please refresh');
      print(e);
    }
  }

  Future<void> likes({required String id}) async {
    String url = dotenv.env['BASE_URL'].toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    try {
      var res = await dio.post(
        '$url/api/likes',
        data: {'productId': id},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (res.statusCode == 201) {
        if (listLikes.any((element) => element.id == id)) {
          listLikes = listLikes.where((element) => element.id != id).toList();
        } else {
          listLikes.addAll(products
              .where((element) => element.id == id)
              .map((element) => ProductLikeModel(
                    name: element.name,
                    price: element.price,
                    category: element.category,
                    description: element.description,
                    imageThumbnail: element.imageThumbnail,
                    imageDetails: element.imageDetails,
                    id: element.id,
                  )));
        }
        update();
      } else {
        Get.snackbar('Error', 'Opps, something went wrong please refresh');
      }
    } catch (e) {
      Get.snackbar('Error', 'Opps, something went wrong please refresh');
      print(e);
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = dotenv.env['BASE_URL'].toString();
    String token = prefs.getString('token')!;
    try {
      var response = await dio.post(
        '$url/api/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (response.statusCode == 200) {
        prefs.remove('token');
        prefs.remove('name');
        prefs.remove('email');
        await Get.deleteAll(force: true);
        Get.offAllNamed('/login', predicate: (route) => false);
      } else {
        Get.snackbar('Error', 'Opps, something went wrong please refresh');
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
