import 'package:cyber/app/data/models/auth_model.dart';
import 'package:cyber/app/modules/home/controllers/home_controller.dart';
import 'package:cyber/app/routes/app_pages.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  bool isObscuredPassword = true;
  bool isObscuredPasswordConfirm = true;
  Dio dio = Dio();
  AuthModel? user;
  final _googleSignIn = GoogleSignIn();

  static validToken() async {
    Dio dio = Dio();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    if (token != null) {
      var response = await dio.get(
        '${dotenv.env['BASE_URL']}/auth/me',
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  void changeObesecured() {
    isObscuredPassword = !isObscuredPassword;
    update();
  }

  void changeObesecuredConfirm() {
    isObscuredPasswordConfirm = !isObscuredPasswordConfirm;
    update();
  }

  Future<GoogleSignInAccount?> loginWithGoogle() async {
    return await _googleSignIn.signIn();
  }

  Future<void> signInGoole({required String email}) async {
    final String url = dotenv.env['BASE_URL']!;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var valid = await dio.post('$url/auth/signin', data: {'email': email});
      if (valid.statusCode == 200) {
        var data = AuthModel.fromJson(valid.data);
        user = AuthModel(name: data.name, token: data.token);
        prefs.setString('token', data.token);
        prefs.setString('name', data.name);
        prefs.setString('email', email);
        prefs.setBool('login', true);
        Get.put(HomeController(), permanent: true);
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.to(() => Routes.REGISTER);
      }
    } catch (e) {
      Get.snackbar('Error', 'Google Sign In Failed');
    }
  }

  Future<void> signInWithCredential(
      {required String email, required String password}) async {
    final String url = dotenv.env['BASE_URL']!;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Email or Password is empty');
      return;
    }
    try {
      var valid = await dio.post('$url/auth/login',
          data: {'email': email, 'password': password});
      if (valid.statusCode == 200) {
        var data = AuthModel.fromJson(valid.data);
        user = AuthModel(name: data.name, token: data.token);
        prefs.setString('token', data.token);
        prefs.setString('name', data.name);
        prefs.setString('email', email);
        prefs.setBool('login', true);
        Get.put(HomeController(), permanent: true);
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar('Error', 'Email or Password is wrong',
            colorText: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', 'Email or Password is wrong',
          colorText: Colors.red);
    }
  }

  Future<void> createAccount(
      {required String email,
      required String name,
      required String password}) async {
    final String url = dotenv.env['BASE_URL']!;
    try {
      var valid = await dio.post('$url/auth/register',
          data: {'email': email, 'password': password, 'name': name});
      if (valid.statusCode == 201) {
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.snackbar('Error', 'Register Failed');
      }
    } on DioException catch (e) {
      if (e.response!.statusCode == 400) {
        Get.snackbar('Error', 'Email already exist', colorText: Colors.red);
      } else {
        Get.snackbar('Error', 'Register Failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'Register Failed');
    }
  }

  Future signOut() async {
    return await _googleSignIn.signOut();
  }
}
