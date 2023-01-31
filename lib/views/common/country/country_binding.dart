import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/common/country/country_controller.dart';

class CountryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CountryController());
  }
}