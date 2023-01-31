import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/webview/webview_controller.dart';

class WebviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WebviewController());
  }
}