import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/user/abount/about_me_controller.dart';

class AbountMeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AboutMeController());
  }
}