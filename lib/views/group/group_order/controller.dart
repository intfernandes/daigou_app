import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/services/group_service.dart';

class GroupOrderController extends GlobalController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final PageController pageController = PageController();
  int isSigned = 0;
  int page = 0;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  loadList({type}) async {
    page = 0;

    return await loadMoreList();
  }

  loadMoreList() async {
    var data = await GroupService.getGroupOrders({
      'page': ++page,
      'is_signed': isSigned,
    });
    return data;
  }

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }
}
