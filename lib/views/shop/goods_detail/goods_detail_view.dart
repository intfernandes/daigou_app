import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/error_box.dart';
import 'package:jiyun_app_client/views/components/input/base_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/skeleton/skeleton.dart';
import 'package:jiyun_app_client/views/shop/goods_detail/goods_detail_controller.dart';

class GoodsDetailView extends GetView<GoodsDetailController> {
  const GoodsDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: AppColors.bgGray,
      bottomNavigationBar: Obx(() => controller.goodsModel.value != null
          ? Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16.w),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        CommonMethods.onCustomerContact();
                      },
                      child: ImgItem(
                        'Shop/custom',
                        width: 30.w,
                        height: 30.w,
                      ),
                    ),
                    Flexible(
                        flex: 0,
                        child: SizedBox(
                          height: 35.h,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.showSkuModal('cart');
                                },
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: 110.w),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                        color: AppColors.textDark,
                                        borderRadius: BorderRadius.horizontal(
                                            left: Radius.circular(999))),
                                    child: ImgItem(
                                      'Shop/cart',
                                      width: 26.w,
                                      height: 26.w,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.showSkuModal('buy');
                                },
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minWidth: 110.w),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(999))),
                                    alignment: Alignment.center,
                                    child: AppText(
                                      str: '购买'.ts,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            )
          : AppGaps.empty),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 5,
            ),
          );
        } else if (controller.goodsModel.value != null) {
          return buildContentList(context);
        }

        return Stack(
          children: [
            Center(
              child: ErrorBox(
                onRefresh: controller.getGoodsDetail,
              ),
            ),
            Positioned(
              left: 15.w,
              top: ScreenUtil().statusBarHeight + 5,
              child: const BackButton(color: Colors.black),
            ),
          ],
        );
      }),
    );
  }

  Widget buildContentList(BuildContext context) {
    return ListView(
      children: [
        baseInfoCell(),
        optionCell(context),
        shopCell(),
        Obx(() => commentsCell()),
        remarkCell(),
      ],
    );
  }

  Widget baseInfoCell() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Obx(
              () => SizedBox(
                height: 320.h,
                child: Swiper(
                  autoplay:
                      (controller.goodsModel.value?.images ?? []).length > 1,
                  itemBuilder: (context, index) {
                    return ImgItem(
                      controller.goodsModel.value!.images![index],
                      holderImg: 'Shop/goods_none',
                      fit: BoxFit.fitWidth,
                    );
                  },
                  loop: (controller.goodsModel.value?.images ?? []).length > 1,
                  itemCount: controller.goodsModel.value?.images!.length ?? 0,
                ),
              ),
            ),
            Positioned(
              left: 15.w,
              top: ScreenUtil().statusBarHeight + 5,
              child: const BackButton(color: Colors.black),
            ),
          ],
        ),
        Obx(
          () => Transform.translate(
            offset: Offset(0, -30.h),
            child: defaultBoxItem(
              margin: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                        children: [
                          TextSpan(
                            text: controller.currencyModel.value?.symbol ?? '',
                          ),
                          TextSpan(
                            text: ((controller.sku.value?.price ??
                                        controller.goodsModel.value?.price ??
                                        0) *
                                    (controller.qty.value ?? 1))
                                .rate(
                                    showPriceSymbol: false, needFormat: false),
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                  ),
                  6.verticalSpaceFromWidth,
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 16.sp,
                        height: 1.5,
                      ),
                      children: [
                        WidgetSpan(
                          child: controller.isPlatformGoods.value
                              ? Padding(
                                  padding: EdgeInsets.only(right: 5.w),
                                  child: ImgItem(
                                    CommonMethods.getPlatformIcon(
                                        controller.goodsModel.value?.platform),
                                    width: 20.w,
                                    height: 20.w,
                                  ),
                                )
                              : AppGaps.empty,
                          alignment: PlaceholderAlignment.middle,
                        ),
                        TextSpan(
                            text: controller.goodsModel.value!.title.wordBreak),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget optionCell(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -20.h),
      child: defaultBoxItem(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            optionItem(type: 'sku'),
            controller.isPlatformGoods.value
                ? Container(
                    margin: EdgeInsets.only(top: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          str: '国内运费'.ts,
                          fontSize: 12,
                          color: AppColors.textGrayC9,
                        ),
                        10.verticalSpaceFromWidth,
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0xFFD7D7D7)),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              width: 80.w,
                              height: 30.h,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppText(
                                    str: controller
                                            .currencyModel.value?.symbol ??
                                        '',
                                    fontSize: 14,
                                  ),
                                  3.horizontalSpace,
                                  Expanded(
                                    child: BaseInput(
                                      controller: controller.priceController,
                                      focusNode: controller.priceNode,
                                      autoRemoveController: false,
                                      showDone: true,
                                      autoShowRemove: false,
                                      style: TextStyle(fontSize: 16.sp),
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 8.h),
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            20.horizontalSpace,
                            AppText(
                              str: '将寄往'.ts,
                              fontSize: 14,
                              color: AppColors.textGrayC9,
                            ),
                            10.horizontalSpace,
                            GestureDetector(
                              onTap: () {
                                controller.showWarehousePicker(context);
                              },
                              child: AppText(
                                str: controller.selectedWarehouse.value
                                        ?.warehouseName ??
                                    '选择仓库'.ts,
                                fontSize: 14,
                              ),
                            ),
                            5.horizontalSpace,
                            Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.textNormal,
                              size: 14.sp,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : AppGaps.empty,
            // controller.isPlatformGoods.value
            //     ? optionItem(type: 'country')
            //     : AppGaps.empty,
          ],
        ),
      ),
    );
  }

  Widget optionItem({
    required String type,
    String? value,
  }) {
    return GestureDetector(
      onTap: () {
        if (type == 'sku') {
          controller.showSkuModal('select');
        }
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppText(
                    str: type == 'sku' ? '选择'.ts : '目的地'.ts,
                    fontSize: 12,
                    color: AppColors.textGrayC9,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textNormal,
                  size: 15.sp,
                ),
              ],
            ),
            10.verticalSpaceFromWidth,
            AppText(
              str: value ??
                  (type == 'sku'
                      ? (controller.sku.value == null
                          ? '产品规格'.ts
                          : '${controller.sku.value!.propertiesName} x${controller.qty.value}')
                      : '根据地区进行计算'.ts),
              fontSize: 14,
              lines: 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget shopCell() {
    return Transform.translate(
      offset: Offset(0, -10.h),
      child: defaultBoxItem(
        child: Row(
          children: [
            ImgItem(
              'Shop/shop',
              width: 30.w,
              height: 30.w,
            ),
            10.horizontalSpace,
            Expanded(
              child: AppText(
                str: controller.isPlatformGoods.value
                    ? controller.goodsModel.value!.nick ?? ''
                    : '自营商城'.ts,
                lines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget commentsCell() {
    return controller.commentLoading.value
        ? Skeleton(
            type: SkeletonType.singleSkeleton,
            lineCount: 5,
            height: 100.h,
            borderRadius: 8,
            margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
          )
        : (controller.comments.isNotEmpty
            ? GestureDetector(
                onTap: controller.onShowCommentSheet,
                child: defaultBoxItem(
                  margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              str: '商品评价'.ts +
                                  '(${controller.commentsTotal.value})',
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14.sp,
                            color: AppColors.textGrayC9,
                          ),
                        ],
                      ),
                      ...controller.comments.map(
                        (item) => Container(
                          margin: EdgeInsets.only(top: 15.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                str: item.displayUserNick ?? '',
                              ),
                              8.verticalSpaceFromWidth,
                              AppText(
                                str: item.rateContent ?? '',
                                color: const Color(0xff555555),
                                lines: 20,
                                fontSize: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : AppGaps.empty);
  }

  Widget remarkCell() {
    return defaultBoxItem(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
            child: AppText(
              str: '商品详情'.ts,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Obx(() => controller.goodsModel.value!.desc!.isNotEmpty
              ? Html(data: controller.goodsModel.value!.desc)
              : AppGaps.empty),
        ],
      ),
    );
  }

  Widget defaultBoxItem({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return Container(
      margin: margin ?? EdgeInsets.fromLTRB(14.w, 0, 14.w, 0),
      padding:
          padding ?? EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
      child: child,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}