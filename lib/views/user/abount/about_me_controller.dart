import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/models/article_model.dart';
import 'package:shop_app_client/services/article_service.dart';

class BeeLogic extends GlobalController {
  final aboutList = <ArticleModel>[].obs;

  @override
  onInit() {
    super.onInit();
    getList();
  }

  getList() async {
    var data = await ArticleService.getList({'type': 5});
    aboutList.value = data;
  }
}
