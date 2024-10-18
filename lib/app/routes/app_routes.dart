part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const LOGIN = _Paths.LOGIN;
  static const STARTED = _Paths.STARTED;
  static const REGISTER = _Paths.REGISTER;
  static const DETAIL_PRODUCT = _Paths.DETAIL_PRODUCT;
  static const CART = _Paths.CART;
  static const ADDRESS = _Paths.ADDRESS;
  static const CREATE_ADDRESS = _Paths.CREATE_ADDRESS;
  static const EDIT_ADDRESS = _Paths.EDIT_ADDRESS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/';
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const STARTED = '/started';
  static const REGISTER = '/register';
  static const DETAIL_PRODUCT = '${HOME}detail-product/:id';
  static const CART = '/cart';
  static const ADDRESS = '/address';
  static const CREATE_ADDRESS = '$ADDRESS/create-address';
  static const EDIT_ADDRESS = '$ADDRESS/edit-address/:id';
}
