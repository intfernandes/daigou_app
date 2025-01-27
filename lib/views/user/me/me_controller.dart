import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shop_app_client/views/components/base_dialog.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/change_page_index_event.dart';
import 'package:shop_app_client/events/profile_updated_event.dart';
import 'package:shop_app_client/models/user_agent_status_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/models/user_point_model.dart';
import 'package:shop_app_client/services/user_service.dart';
import 'package:shop_app_client/services/point_service.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/storage/user_storage.dart';
import 'package:shop_app_client/models/user_vip_model.dart';

class BeeCenterLogic extends GlobalController {
  final ScrollController scrollController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final isloading = false.obs;
  AppStore userInfoModel = Get.find<AppStore>();
  final agentStatus = Rxn<UserAgentStatusModel?>();
  final noticeUnRead = false.obs;
  final showMiniHeader = false.obs;
  final selectImg = <String>[].obs;
  //会员中心基础信息
  final userVipModel = Rxn<UserVipModel?>();
  //我的余额
  final myBalance = RxNum(0);
  // 优惠券数量
  final myCouponCount = RxNum(0);
  final userPointModel = Rxn<UserPointModel?>();
  // 当前网络状态
  final netWorkDisconnect =  false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async{
    super.onReady();
    // 判断网络状态
    var connectivity = Connectivity();
    // 初始化时也要判断一下网络
    var result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.none) {
      netWorkDisconnect.value = true;
    }else {
      hasNetWork();
    }
    // 监听网络数据变化-真机情况下没问题 第一次不会监测到
    connectivity.onConnectivityChanged.listen((result) {
      print(result);
      if (result == ConnectivityResult.none) {
        netWorkDisconnect.value = true;
      }else {
        netWorkDisconnect.value = false;
        hasNetWork();
      }
    });
  }

  hasNetWork() {
    ApplicationEvent.getInstance()
        .event
        .on<ProfileUpdateEvent>()
        .listen((event) {
      created();
    });
    // ApplicationEvent.getInstance()
    //     .event
    //     .on<NoticeRefreshEvent>()
    //     .listen((event) {
    //   onGetUnReadNotice();
    // });
    created();
    // onGetUnReadNotice();
    scrollController.addListener(() {
      showMiniHeader.value = scrollController.position.pixels > 100.h;
    });
  }

  // 是否有未读消息
  // onGetUnReadNotice() async {
  //   var token = Get.find<AppStore>().token.value;
  //   if (token.isEmpty) return;
  //   var res = await CommonService.hasUnReadInfo();
  //   noticeUnRead.value = res;
  // }


  void getBalance() async {
    var userOrderDataCount = await UserService.getOrderDataCount();
    myBalance.value = userOrderDataCount!.balance ?? 0;
    myCouponCount.value = userOrderDataCount!.couponCount ?? 0;
    userPointModel.value = await PointService.getSummary();
  }

  Future<void> created() async {
    var token = userInfoModel.token;
    if (token.isNotEmpty) {
      userVipModel.value = await UserService.getVipMemberData();
      agentStatus.value = await UserService.getAgentStatus();
      isloading.value = true;
    }
    getBalance();
  }

  Future<bool?> showInfoChange() async {
    return await BaseDialog.typeDialog(Get.context!, 2, (params) {
      updateInfo(params);
    }, {
      'avatar': userInfoModel.userInfo.value!.avatar,
      'name': userInfoModel.userInfo.value!.name
    });
  }

  // 更新个人信息
  updateInfo(Map<String, dynamic> params) {
    print('传出');
    print(params['name']);
    print(params['avatar']);
    UserService.updateByMap(params, (msg) {
      userInfoModel.userInfo.value!.avatar = params['avatar'];
      userInfoModel.userInfo.value!.name = params['name'];
      CommonStorage.setUserInfo(userInfoModel.userInfo.value!);
      // 刷新头像
      showMiniHeader.value = true;
      showMiniHeader.value = false;
    }, (err) {});
  }

  Future<void> handleRefresh() async {
    await created();
    Get.find<AppStore>().getBaseCountInfo();
  }

  /* 注销登录 */
  void onLogout() async {
    //清除TOKEN
    userInfoModel.clear();
    ApplicationEvent.getInstance()
        .event
        .fire(ChangePageIndexEvent(pageName: 'home'));
  }
}
