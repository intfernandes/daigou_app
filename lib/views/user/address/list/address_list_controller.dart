import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/receiver_address_refresh_event.dart';
import 'package:jiyun_app_client/models/receiver_address_model.dart';
import 'package:jiyun_app_client/services/address_service.dart';

class AddressListController extends BaseController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final addressList = <ReceiverAddressModel>[].obs;
  final TextEditingController keywordController = TextEditingController();
  final FocusNode keywordNode = FocusNode();
  final keyword = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getList();
    ApplicationEvent.getInstance()
        .event
        .on<ReceiverAddressRefreshEvent>()
        .listen((event) {
      getList();
    });
  }

  // 地址列表
  getList() async {
    showLoading();
    var data = await AddressService.getReceiverList({'keyword': keyword});
    hideLoading();
    addressList.value = data;
  }

  // 选择地址
  onSelectAddress(ReceiverAddressModel model) {
    var arguments = Get.arguments;
    if (arguments?['select'] == 1) {
      Routers.pop(model);
    }
  }

  @override
  void onClose() {
    keywordController.dispose();
    keywordNode.dispose();
    super.onClose();
  }
}