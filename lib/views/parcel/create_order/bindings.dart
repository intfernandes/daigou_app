import 'package:get/get.dart';

import 'controller.dart';

class BeePackingBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BeePackingLogic>(() => BeePackingLogic());
  }
}
