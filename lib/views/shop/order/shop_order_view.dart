import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/events/application_event.dart';
import 'package:huanting_shop/events/list_refresh_event.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/base_search.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/shop/order/shop_order_controller.dart';
import 'package:huanting_shop/views/shop/widget/shop_order_list.dart';

class ShopOrderView extends GetView<ShopOrderController> {
  const ShopOrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BaseSearch(
          showScan: false,
          needCheck: false,
          hintText: '名称/主订单/商品单号'.ts,
          onSearch: (value) {
            controller.keyword = value;
            ApplicationEvent.getInstance()
                .event
                .fire(ListRefreshEvent(type: 'refresh'));
          },
        ),
        leadingWidth: 25.w,
        leading: Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: const BackButton(color: Colors.black)),
        bottom: myTabbar() as PreferredSizeWidget,
        actions: [
          GestureDetector(
            onTap: () {
              BeeNav.push(BeeNav.probleShopOrder);
            },
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.only(right: 14.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadAssetImage(
                    'Transport/ico_wtdd',
                    width: 20.w,
                  ),
                  2.verticalSpaceFromWidth,
                  AppText(
                    str: '问题订单'.ts,
                    fontSize: 10,
                    color: AppColors.textNormal,
                  )
                ],
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.bgGray,
      body: PageView.builder(
        itemCount: 7,
        onPageChanged: (value) {
          controller.tabController.animateTo(value);
          controller.tabIndex.value = value;
        },
        controller: controller.pageController,
        itemBuilder: (context, index) => ShopOrderList(
          status: index,
          keyword: controller.keyword,
        ),
      ),
    );
  }

  Widget myTabbar() {
    return TabBar(
      isScrollable: true,
      tabs: tabListCell(),
      controller: controller.tabController,
      indicator: const BoxDecoration(),
      onTap: (index) {
        controller.pageController.jumpToPage(index);
        controller.tabIndex.value = index;
      },
    );
  }

  List<Widget> tabListCell() {
    List<String> tabs = ['全部', '待付款', '采购中', '待入库', '已入库', '交易完成', '已取消'];
    return tabs
        .asMap()
        .keys
        .map(
          (index) => Obx(
            () => Column(
              children: [
                AppText(
                  str: tabs[index].ts,
                  fontWeight: controller.tabIndex.value == index
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: controller.tabIndex.value == index
                      ? AppColors.textDark
                      : AppColors.textNormal,
                  fontSize: controller.tabIndex.value == index ? 16 : 14,
                ),
                3.verticalSpaceFromWidth,
                Container(
                  width: 24.w,
                  height: 3.h,
                  decoration: BoxDecoration(
                    color: controller.tabIndex.value == index
                        ? AppColors.primary
                        : Colors.white,
                    borderRadius: BorderRadius.circular(2.h),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}
