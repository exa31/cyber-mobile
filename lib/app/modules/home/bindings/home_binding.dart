import 'package:cyber/app/modules/cart/controllers/cart_controller.dart';
import 'package:get/get.dart';

// import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Get.find<HomeController>();
    Get.put(
      CartController(),
      permanent: true,
    );
  }
}
