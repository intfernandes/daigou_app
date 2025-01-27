import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';

class ProblemOrderController extends GlobalController
    with GetSingleTickerProviderStateMixin {
  final PageController pageController = PageController(initialPage: 0);
  late final TabController tabController;
  final tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
  }
}
