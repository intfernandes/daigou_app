import 'package:get/instance_manager.dart';
import 'package:shop_app_client/views/user/login/login_controller.dart';

class BeeSignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BeeSignInLogic());
  }
}
