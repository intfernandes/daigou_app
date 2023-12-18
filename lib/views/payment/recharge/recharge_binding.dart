import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/payment/recharge/recharge_controller.dart';

class RechargeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RechargeController());
  }
}