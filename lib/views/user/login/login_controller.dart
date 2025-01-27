import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/common/util.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/logined_event.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/country_model.dart';
import 'package:shop_app_client/models/token_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/services/user_service.dart';
import 'package:shop_app_client/storage/user_storage.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class BeeSignInLogic extends GlobalController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // 新号码
  final TextEditingController mobileNumberController = TextEditingController();
  // 新号码
  final TextEditingController emailController = TextEditingController();
  // 验证码
  final TextEditingController validationController = TextEditingController();
  final FocusNode validation = FocusNode();
  RxString pageTitle = '登录'.inte.obs;
  RxInt loginType = 2.obs; // 1、手机号密码 2: 邮箱密码
  RxString sent = '获取验证码'.inte.obs;
  RxString code = ''.obs;
  RxBool isButtonEnable = true.obs;
  final timer = Rxn<Timer?>();
  RxInt count = 60.obs;
  Rx<Color> codeColor = AppStyles.textBlack.obs;
  // 电话区号
  RxString areaNumber = '0086'.obs;
  // 电话号码
  RxString mobileNumber = ''.obs;
  // 验证码
  RxString verifyCode = ''.obs;
  // 记住密码
  final saveAccount = false.obs;

  @override
  onInit() {
    super.onInit();
    var accountInfo = Get.find<AppStore>().accountInfo.value;
    if (accountInfo != null) {
      if (accountInfo['loginType'] != null) {
        saveAccount.value = true;
        validationController.text = accountInfo['password'];
        loginType.value = accountInfo['loginType'];
        if (loginType.value == 1) {
          mobileNumberController.text = accountInfo['account'];
        } else {
          emailController.text = accountInfo['account'];
        }
        if (loginType.value == 1 && accountInfo['timezone'] != null) {
          areaNumber.value = accountInfo['timezone'];
        }
      } else {
        onSaveAccount(false);
      }
    }
  }

  // 登录方式
  onLoginType(int value) {
    if (loginType.value == value) return;
    loginType.value = value;
    validationController.text = '';
    emailController.text = '';
    mobileNumberController.text = '';
    if (saveAccount.value) {
      onSaveAccount(false);
    }
  }

  // 记住密码
  onSaveAccount(bool? value) {
    if (value!) {
      var account = loginType.value == 1
          ? mobileNumberController.text
          : emailController.text;
      if (account.isEmpty || validationController.text.isNotEmpty) {
        saveAccount.value = value;
        Get.find<AppStore>().saveAccount({
          'account': loginType.value == 1
              ? mobileNumberController.text
              : emailController.text,
          'password': validationController.text,
          'loginType': loginType.value,
          'timezone': areaNumber.value
        });
      } else {
        BaseUtils.showToast('请输入账号密码'.inte);
      }
    } else {
      saveAccount.value = value;
      Get.find<AppStore>().clearAccount();
    }
  }

  // 忘记密码
  toForgetPassword() async {
    GlobalPages.push(GlobalPages.forgetPassword,
        arg: {'type': loginType.value});
  }

  // 登录
  onLogin() async{
    // 监测网络状态
    var connectivity = Connectivity();
    var result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
        EasyLoading.showError('未检查到网络环境，请检查网络连接'.inte);
        return;
    }
      Map<String, dynamic> map;
    map = {
      'account': loginType.value == 1
          ? mobileNumberController.text
          : emailController.text,
      'password': validationController.text,
    };
    loginWith('password', map);
    //  1 手机号验证码 2 邮箱验证码 3 帐号密码
    // if (loginType.value == 3) {
    //   //邮箱密码 1 手机密码
    // } else if (loginType.value == 2) {
    //   // 邮箱验证码
    //   map = {
    //     'email': emailController.text,
    //     'verify_code': validationController.text,
    //   };
    //   loginWith('emailCode', map);
    // } else if (loginType.value == 1) {
    //   // 手机验证码
    //   map = {
    //     'phone': areaNumber.value + mobileNumberController.text,
    //     'verify_code': validationController.text,
    //   };
    //   loginWith('mobileCode', map);
    // }
  }

  // 登录方式
  loginWith(String type, Map<String, dynamic> map) async {
    try {
      TokenModel? tokenModel;
      switch (type) {
        case 'social':
          tokenModel = await UserService.loginWithFirebase(map);
          break;
        case 'emailCode':
        case 'mobileCode':
          tokenModel = await UserService.loginBy(map);
          break;
        default:
          tokenModel = await UserService.login(map);
      }
      //发送登录事件
      ApplicationEvent.getInstance().event.fire(LoginedEvent());

      //更新状态管理器
      AppStore userInfoModel = Get.find<AppStore>();
      userInfoModel.saveInfo(
          tokenModel!.tokenType + ' ' + tokenModel.accessToken,
          tokenModel.user!);

      // 保存 device token
      // String? dt = CommonStorage.getDeviceToken();
      // if (dt != null) {
      //   await CommonService.saveDeviceToken({
      //     'type': 1,
      //     'token': dt,
      //   });
      // }
      if (CommonStorage.getNewUser() == 1) {
        GlobalPages.redirect(GlobalPages.loggedGuide);
      } else {
        GlobalPages.pop();
      }
    } catch (e) {
      showToast(e.toString());
    }
  }

  // 发送验证码
  void onGetCode() async {
    if (isButtonEnable.value) {
      //当按钮可点击时   action  动作 1 绑定邮箱 2 更改邮箱 3 更改手机号 4 邮箱登录 5 手机登录
      // int LoginType = 1; //  2 手机号验证码 4邮箱验证码
      Map<String, dynamic> map = {
        'receiver': loginType.value == 1
            ? areaNumber + mobileNumberController.text
            : emailController.text,
        'action': loginType.value == 1
            ? 5 // 手机登录验证码
            : 4 // 邮箱登录验证码
      };
      showLoading();
      UserService.getVerifyCode(map, (data) {
        hideLoading();
        showSuccess(data.msg);

        sent.value = '重新发送'.inte + '  ($count)'; //更新文本内容
        buttonClickListen();
      }, (msg) {
        hideLoading();
        showError(msg.toString());
      });
    }
  }

  // 选择手机区号
  void onTimezone() async {
    var s = await GlobalPages.push(GlobalPages.country);
    if (s != null) {
      CountryModel a = s as CountryModel;
      areaNumber.value = a.timezone!;
    }
  }

  // 监听按钮是否可点击
  void buttonClickListen() {
    if (isButtonEnable.value) {
      //当按钮可点击时
      isButtonEnable.value = false; //按钮状态标记
      codeColor.value = AppStyles.textGray;
      initTimer();
    }
  }

  void initTimer() {
    timer.value = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      count.value--;
      if (count.value == 0) {
        timer.cancel(); //倒计时结束取消定时器
        isButtonEnable.value = true; //按钮可点击
        count.value = 60; //重置时间
        codeColor.value = AppStyles.textBlack;
        sent.value = '发送验证码'.inte; //重置按钮文本
      } else {
        sent.value = '重新发送'.inte + ' ($count)'; //更新文本内容
      }
    });
  }

  String formatTimezone(String timezone) {
    var reg = RegExp(r'^0{1,}');
    return timezone.replaceAll(reg, '');
  }

  // 注册
  void onRegister() async {
    var s = await GlobalPages.push(GlobalPages.register);
    if (s != null) {
      emailController.text = s;
    }
  }

  @override
  void onClose() {
    mobileNumberController.dispose();
    emailController.dispose();
    validationController.dispose();

    validation.dispose();
    if (timer.value != null) {
      timer.value!.cancel(); //销毁计时器
      timer.value = null;
    }
    super.onClose();
  }
}
