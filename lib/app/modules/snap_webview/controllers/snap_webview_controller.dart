import 'dart:developer';

import 'package:cyber/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SnapWebviewController extends GetxController {
  //TODO: Implement SnapWebviewController
  WebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    var redirectUrl = Get.arguments['redirectUrl'];
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            if (!url.contains("midtrans")) {
              Get.offNamed(Routes.HOME);
            }
          },
          onPageFinished: (String url) {
            log('Page finished loading: $url');
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('$redirectUrl'));
  }
}
