import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/user_info_model.dart';
import 'package:huanting_shop/views/components/ad_cell.dart';
import 'package:huanting_shop/views/components/base_search.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/contact_cell.dart';
import 'package:huanting_shop/views/components/empty_app_bar.dart';
import 'package:huanting_shop/views/components/goods/goods_list_cell.dart';
import 'package:huanting_shop/views/components/indicator.dart';
import 'package:huanting_shop/views/components/language_cell/language_cell.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:huanting_shop/views/home/widget/notice_widget.dart';
import 'package:huanting_shop/views/shop/platform_goods/platform_goods_binding.dart';
import 'package:huanting_shop/views/shop/platform_goods/platform_goods_list_view.dart';
import 'package:sticky_headers/sticky_headers.dart';

class IndexPage extends GetView<IndexLogic> {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      child: Scaffold(
        appBar: const EmptyAppBar(),
        key: controller.scaffoldKey,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: controller.handleRefresh,
                color: AppColors.primary,
                child: ListView(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    StickyHeader(
                      header: Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 8.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const LanguageCell(),
                            12.verticalSpaceFromWidth,
                            Row(
                              children: [
                                const Expanded(child: BaseSearch()),
                                8.horizontalSpace,
                                Obx(() {
                                  var cartCount =
                                      Get.find<AppStore>().cartCount.value;
                                  return GestureDetector(
                                    onTap: () {
                                      BeeNav.push(BeeNav.cart);
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        LoadAssetImage(
                                          'Home/ico_gwc',
                                          width: 28.w,
                                          height: 28.w,
                                        ),
                                        if (cartCount != 0)
                                          Positioned(
                                            right: -4.w,
                                            top: -4.w,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.w,
                                                  vertical: 1.w),
                                              child: AppText(
                                                str: cartCount.toString(),
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            )
                          ],
                        ),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AdsCell(type: 5, padding: 14.w),
                          buildLinks(),
                          const NoticeWidget(),
                          categoryBox(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w),
                            child: AppText(
                              str: '大家在看什么'.ts,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          15.verticalSpaceFromWidth,
                          Obx(
                            () => controller.goodsLoading.value
                                ? const Center(child: Indicator())
                                : Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 14.w),
                                    child: BeeShopGoodsList(
                                      isPlatformGoods: true,
                                      platformGoodsList: controller.goodsList,
                                    ),
                                  ),
                          ),
                          50.verticalSpaceFromWidth,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const ContactCell(),
            ],
          ),
        ),
      ),
      value: SystemUiOverlayStyle.dark,
    );
  }

  // 商品分类
  Widget categoryBox() {
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 18.h, 14.w, 25.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFE8F7FF),
            Color(0xFFF7FBFE),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => AppText(
                    str: '精选分类'.ts,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Obx(
                () => GestureDetector(
                  onTap: () {
                    BeeNav.push(BeeNav.goodsCategory);
                  },
                  child: AppText(
                    str: '查看全部'.ts,
                    fontSize: 14,
                    color: AppColors.textNormal,
                  ),
                ),
              ),
              5.horizontalSpace,
              Icon(
                Icons.arrow_forward_ios,
                size: 13.sp,
                color: AppColors.textNormal,
              ),
            ],
          ),
          15.verticalSpaceFromWidth,
          SizedBox(
            height: 100.w,
            child: Obx(
              () => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categoryList.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Get.to(
                        PlatformGoodsListView(
                            controllerTag: controller.categoryList[index].name),
                        arguments: {
                          'keyword': controller.categoryList[index].nameCn,
                          'origin': controller.categoryList[index].name,
                          'hideSearch': true,
                        },
                        binding: PlatformGoodsBinding(
                            tag: controller.categoryList[index].name));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 14.w),
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Container(
                          width: 68.w,
                          height: 68.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.all(8.w),
                          child: (controller.categoryList[index].image ?? '')
                                  .isNotEmpty
                              ? ImgItem(
                                  controller.categoryList[index].image ?? '',
                                  holderColor: Colors.white,
                                )
                              : null,
                        ),
                        10.verticalSpaceFromWidth,
                        AppText(
                          str: controller.categoryList[index].name,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLinks() {
    List<Map<String, dynamic>> list = [
      {
        'label': '新手指引',
        'icon': 'Home/ico_xszy',
        'route': BeeNav.guide,
      },
      {
        'label': '运费估算',
        'icon': 'Home/ico_yfgs',
        'route': BeeNav.lineQuery,
      },
      {
        'label': '推广联盟',
        'icon': 'Home/ico_tglm',
        'route': BeeNav.agentApplyInstruct,
      },
      {
        'label': '提交转运',
        'icon': 'Home/ico_zydd',
        'route': BeeNav.forecast,
      },
    ];
    return Container(
      margin: EdgeInsets.fromLTRB(14.w, 20.h, 14.w, 25.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list
            .map(
              (e) => Flexible(
                child: GestureDetector(
                  onTap: () {
                    if (e['route'] == BeeNav.agentApplyInstruct &&
                        controller.agentStatus.value == 1) {
                      BeeNav.push(BeeNav.agentCenter);
                    } else {
                      BeeNav.push(e['route']!, arg: e['params']);
                    }
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        ImgItem(
                          e['icon']!,
                          width: 42.w,
                          height: 42.w,
                        ),
                        5.verticalSpaceFromWidth,
                        Obx(
                          () => AppText(
                            str: (e['label']! as String).ts,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
