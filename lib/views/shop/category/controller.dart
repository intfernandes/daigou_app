import 'package:get/get.dart';
import 'package:huanting_shop/config/base_conctroller.dart';
import 'package:huanting_shop/models/goods_category_model.dart';
import 'package:huanting_shop/services/shop_service.dart';

class GoodsCategoryController extends GlobalLogic {
  final categories = <GoodsCategoryModel>[].obs;
  final topCategory = Rxn<GoodsCategoryModel?>();
  final isLoading = true.obs;

  @override
  onInit() {
    super.onInit();
    getClassification();
  }

  // 物品分类
  getClassification() async {
    var data = await ShopService.getCategoryList();

    categories.value = data;
    if (data.isNotEmpty) {
      topCategory.value = data.first;
    }
    isLoading.value = false;
  }

  onTopSelect(GoodsCategoryModel value) {
    if (value.id != topCategory.value?.id) {
      topCategory.value = value;
    }
  }

  // 选择分类
  onSelect(GoodsCategoryModel model) {
    // LYRouter.pop(model);
  }
}
