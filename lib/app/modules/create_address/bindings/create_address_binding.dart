import 'package:get/get.dart';

import '../controllers/create_address_controller.dart';

class CreateAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateAddressController>(
      () => CreateAddressController(),
    );
  }
}
