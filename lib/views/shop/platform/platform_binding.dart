import 'package:get/get.dart';
import 'package:jiyun_app_client/views/shop/platform/platform_controller.dart';

class PlatformBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PlatformController());
  }
}