import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/warehouse/warehouse_controller.dart';

class WarehouseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(WarehouseController());
  }
}