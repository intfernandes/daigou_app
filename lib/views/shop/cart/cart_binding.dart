import 'package:get/get.dart';
import 'package:huanting_shop/views/shop/cart/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CartController());
  }
}
