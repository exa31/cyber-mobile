import 'package:get/get.dart';

import '../controllers/search_product_controller.dart';

class SearchProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchProductController>(
      () => SearchProductController(),
    );
  }
}
