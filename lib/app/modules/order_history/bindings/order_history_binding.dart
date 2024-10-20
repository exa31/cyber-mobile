import 'package:get/get.dart';

import '../controllers/order_history_controller.dart';

class OrderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderHistoryController>(
      () => OrderHistoryController(),
    );
  }
}
