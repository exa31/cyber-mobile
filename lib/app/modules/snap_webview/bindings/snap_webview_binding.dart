import 'package:get/get.dart';

import '../controllers/snap_webview_controller.dart';

class SnapWebviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SnapWebviewController>(
      () => SnapWebviewController(),
    );
  }
}
