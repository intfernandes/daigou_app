import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/services/user_service.dart';

class BeeNewPwdLogic extends GlobalController {
  final TextEditingController newPasswordController = TextEditingController();
  final FocusNode newPaddwordNode = FocusNode();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode confirmPaddwordNode = FocusNode();
  AppStore userInfoModel = Get.find<AppStore>();

  void onSubmit() async {
    showLoading();
    var res = await UserService.onChangePassword({
      'password': newPasswordController.text,
      'password_confirmation': confirmPasswordController.text,
    });
    hideLoading();
    if (res['ok']) {
      showSuccess(res['msg']).then((value) async {
        userInfoModel.clear();
        GlobalPages.redirect(GlobalPages.login);
      });
    } else {
      showError(res['msg']);
    }
  }

  @override
  void onClose() {
    super.onClose();
    newPaddwordNode.dispose();
    confirmPaddwordNode.dispose();
  }
}
