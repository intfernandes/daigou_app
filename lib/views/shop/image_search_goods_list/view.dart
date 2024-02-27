import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/goods/goods_list_cell.dart';
import 'package:huanting_shop/views/components/loading_cell.dart';
import 'package:huanting_shop/views/shop/image_search_goods_list/logics.dart';

class GoodsImageSearchResultPage extends GetView<GoodsImageSearchResultLogic> {
  const GoodsImageSearchResultPage({
    Key? key,
    required this.controllerTag,
  }) : super(key: key);
  final String controllerTag;

  @override
  String? get tag => controllerTag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: AppText(
          str: '代购商品'.ts,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.bgGray,
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        color: AppColors.primary,
        child: ListView(
          controller: controller.loadingUtil.value.scrollController,
          children: [
            15.verticalSpace,
            Obx(
              () => Visibility(
                visible: controller.loadingUtil.value.list.isNotEmpty,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: BeeShopGoodsList(
                    isPlatformGoods: true,
                    platformGoodsList: controller.loadingUtil.value.list,
                  ),
                ),
              ),
            ),
            Obx(
              () => LoadingCell(
                util: controller.loadingUtil.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
