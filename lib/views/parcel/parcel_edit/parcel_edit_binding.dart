import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/parcel/parcel_edit/parcel_edit_controller.dart';

class ParcelEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ParcelEditController());
  }
}