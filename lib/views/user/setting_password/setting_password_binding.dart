import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/user/setting_password/setting_password_controller.dart';

class BeeNewPwdBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeNewPwdLogic());
  }
}
