import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/models/user_info_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/warehouse_service.dart';

class BeeCangKuLogic extends GlobalLogic {
  final warehouseList = <WareHouseModel>[].obs;
  final isLoading = false.obs;
  UserModel? userModel = Get.find<UserInfoModel>().userInfo.value;

  @override
  onInit() {
    super.onInit();
    getList();
  }

  // 仓库地址
  getList() async {
    showLoading();
    var dic = await WarehouseService.getList();
    hideLoading();
    warehouseList.value = dic;
    isLoading.value = true;
  }

  // 复制
  onCopy(String data) {
    Clipboard.setData(ClipboardData(text: data))
        .then((value) => showSuccess('复制成功'));
  }
}
