import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/components/language_cell/language_cell_controller.dart';
import 'package:jiyun_app_client/views/home/home_controller.dart';
import 'package:jiyun_app_client/views/shop/cart/cart_controller.dart';
import 'package:jiyun_app_client/views/shop/platform_center/platform_shop_center_controller.dart';
import 'package:jiyun_app_client/views/tabbar/tabbar_controller.dart';
import 'package:jiyun_app_client/views/transport/transport_center/transport_center_controller.dart';
import 'package:jiyun_app_client/views/user/me/me_controller.dart';

class BeeBottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BeeBottomNavLogic());
    Get.lazyPut(() => IndexLogic());
    Get.lazyPut(() => TransportCenterController());
    Get.lazyPut(() => PlatformShopCenterController());
    Get.lazyPut(() => CartController());
    Get.lazyPut(() => BeeCenterLogic());
    Get.lazyPut(() => LanguageCellController());
  }
}
