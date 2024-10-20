import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/snap_webview_controller.dart';

class SnapWebviewView extends GetView<SnapWebviewController> {
  const SnapWebviewView({super.key});
  @override
  Widget build(BuildContext context) {
    final SnapWebviewController controller = Get.find<SnapWebviewController>();
    return SafeArea(
      child: Scaffold(
        body: WebViewWidget(controller: controller.webViewController!),
      ),
    );
  }
}
