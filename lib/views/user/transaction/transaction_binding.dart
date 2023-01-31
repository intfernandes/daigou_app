import 'package:get/instance_manager.dart';
import 'package:jiyun_app_client/views/user/transaction/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TransactionController());
  }
}