// ignore_for_file: unnecessary_const

/*
  会员中心
*/

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/common/hex_to_color.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/user_vip_level_model.dart';
import 'package:shop_app_client/models/user_vip_price_model.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/empty_app_bar.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/views/user/vip/center/vip_center_controller.dart';

/*
  会员中心
 */

class BeeSuperUserView extends GetView<BeeSuperUserLogic> {
  const BeeSuperUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // primary: false,
      appBar: AppBar(
        centerTitle: true,
        title: AppText(
          str: '成长等级'.inte,
          fontSize: 17,
          color: Colors.white,
        ),
        backgroundColor: Color(0xff120909),
        leading: const BackButton(color: Colors.white),
        actions: [
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    GlobalPages.push(GlobalPages.growthValue);
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    child: AppText(
                      str: '明细'.inte,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ))
            ],
          )
        ],
      ),
      backgroundColor: Color(0xff120909),
      // bottomNavigationBar: Obx(
      //   () => Offstage(
      //     offstage: !controller.isloading.value,
      //     child: Container(
      //       decoration: const BoxDecoration(
      //         color: AppStyles.white,
      //         border: Border(
      //           top: BorderSide(
      //             color: AppStyles.line,
      //           ),
      //         ),
      //       ),
      //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      //       child: SafeArea(
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: <Widget>[
      //             Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.end,
      //               mainAxisSize: MainAxisSize.min,
      //               children: <Widget>[
      //                 Row(
      //                   children: <Widget>[
      //                     AppText(
      //                       str: '合计'.inte + '：',
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                     AppText(
      //                       color: AppStyles.textRed,
      //                       str: controller.selectButton.value == 999
      //                           ? '0.00'
      //                           : (controller
      //                                       .userVipModel
      //                                       .value!
      //                                       .priceList[
      //                                           controller.selectButton.value]
      //                                       .price /
      //                                   100)
      //                               .toString(),
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ],
      //                 ),
      //                 AppText(
      //                   str: controller.selectButton.value == 999
      //                       ? '+ 0 ' + '成长值'.inte
      //                       : '+' +
      //                           controller
      //                               .userVipModel
      //                               .value!
      //                               .priceList[controller.selectButton.value]
      //                               .growthValue
      //                               .toString() +
      //                           '成长值'.inte,
      //                   fontSize: 14,
      //                   color: AppStyles.textGray,
      //                 ),
      //               ],
      //             ),
      //             BeeButton(
      //               text: '立即支付',
      //               fontWeight: FontWeight.bold,
      //               backgroundColor: HexToColor('#d1bb7f'),
      //               onPressed: controller.onPay,
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Obx(() => controller.isloading.value
            ? Column(
                children: <Widget>[
                  headerCardView(context),
                  15.verticalSpaceFromWidth,
                  buildGrowthValueView(),
                  // buyVipPriceView(context),
                  20.verticalSpaceFromWidth,
                ],
              )
            : AppGaps.empty),
      ),
    );
  }

  // 成长值
  Widget buildGrowthValueView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Color(0xffFFFAF3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: AppText(
              str: '成长值说明'.inte,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff333333),
            ),
          ),
          // AppGaps.line,
          Container(
            padding: const EdgeInsets.only(left: 15,right: 15,bottom: 20),
            child: AppText(
              lines: 99,
              str: controller.userVipModel.value!.levelRemark!,
              fontSize: 14,
              color: Color(0xff666666),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 30, left: 15, right: 15),
            child: Column(
              children: buildListView(),
            ),
          ),
        ],
      ),
    );
  }

  // 成长值列表
  buildListView() {
    List<Widget> listV = [];
    listV.add(buildGrowthValueRow(''.inte, ''.inte, isTitle: true));
    for (var i = 0; i < controller.userVipModel.value!.levelList.length; i++) {
      UserVipLevel memModel = controller.userVipModel.value!.levelList[i];
      listV.add(buildGrowthValueRow(
        memModel.name,
        memModel.growthValue.toString(),
      ));
    }
    return listV;
  }

  buildGrowthValueRow(String label, String content, {bool isTitle = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius:isTitle?BorderRadius.only(
                  topLeft: Radius.circular(10),
                ):null,
                color:
                isTitle ? const Color(0xFFECBB7C) : const Color(0xFFFCF6EB),
              ),
              height: 33,
              alignment: Alignment.center,
              child: AppText(
                str: label,
                color: Color(0xffC09052),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(
            width: 1,
          ),
          Expanded(
            child: Container(
              height: 33,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius:isTitle?BorderRadius.only(
                  topRight: Radius.circular(10),
                ):null,
                color:
                isTitle ? const Color(0xFFECBB7C) : const Color(0xFFFCF6EB),
              ),
              child: AppText(
                str: content,
                color: Color(0xffC09052),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
    购买会员价格区域
   */
  Widget buyVipPriceView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppStyles.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: AppText(
              str: '购买会员'.inte,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppGaps.line,
          Padding(
            padding: const EdgeInsets.all(30),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 15.0, //水平子Widget之间间距
                mainAxisSpacing: 10.0, //垂直子Widget之间间距
                crossAxisCount: 3, //一行的Widget数量
                childAspectRatio: 0.8,
              ), // 宽高比例
              itemCount: controller.userVipModel.value!.priceList.length,
              itemBuilder: _buildGrideBtnView(),
            ),
          ),
        ],
      ),
    );
  }

  IndexedWidgetBuilder _buildGrideBtnView() {
    return (context, index) {
      UserVipPriceModel model = controller.userVipModel.value!.priceList[index];
      return GestureDetector(
        onTap: () {
          controller.selectButton.value = index;
        },
        child: Obx(
          () => Container(
            decoration: BoxDecoration(
                color: controller.selectButton.value == index
                    ? const Color(0xFFf9f8f4)
                    : AppStyles.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: controller.selectButton.value == index
                      ? AppStyles.vipNormal
                      : const Color(0xFFd9c58d),
                ),
                boxShadow: controller.selectButton.value == index
                    ? [
                        const BoxShadow(
                          blurRadius: 6,
                          color: const Color(0x6B4A3808),
                        ),
                      ]
                    : null),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    flex: 6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: const Color(0xFFd9c48c),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: AppText(
                            str: model.name,
                            color: Colors.white,
                          ),
                        ),
                        // Container(
                        //   height: 17,
                        //   alignment: Alignment.topRight,
                        //   width: (ScreenUtil().screenWidth - 70) / 3,
                        //   decoration: const BoxDecoration(
                        //     color: Colors.transparent,
                        //     borderRadius: BorderRadius.vertical(
                        //         top: Radius.circular((15))),
                        //   ),
                        //   child: model.type == 2
                        //       ? Container(
                        //           height: 17,
                        //           alignment: Alignment.center,
                        //           width:
                        //               (ScreenUtil().screenWidth - 70) / 3 / 3,
                        //           decoration: const BoxDecoration(
                        //             color: AppStyles.textRed,
                        //             borderRadius: BorderRadius.only(
                        //                 topRight: Radius.circular((15)),
                        //                 bottomLeft:
                        //                     const Radius.circular((15))),
                        //           ),
                        //           child:  AppText(
                        //             str: Translation.t(context, '活动'),
                        //             fontSize: 9,
                        //             fontWeight: FontWeight.w400,
                        //             color: AppStyles.white,
                        //           ),
                        //         )
                        //       : Container(),
                        // ),
                        AppText(
                          // 会员价格
                          str: model.price.priceConvert(),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppStyles.textRed,
                        ),
                        Stack(
                          children: [
                            AppText(
                              str: model.type != 1
                                  ? model.basePrice.priceConvert()
                                  : '',
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: AppStyles.textGray,
                            ),
                            Positioned(
                                top: 7,
                                bottom: 8,
                                right: 0,
                                left: 0,
                                child: Container(
                                  height: 1,
                                  color: AppStyles.textGray,
                                ))
                          ],
                        ),
                      ],
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.center,
                    width: (ScreenUtil().screenWidth - 70) / 3,
                    child: AppText(
                      str: model.illustrate,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    };
  }

  /*
    头部分卡片区
   */
  Widget headerCardView(BuildContext context) {
    num nextLevelGrowthValue =
        controller.userVipModel.value!.profile.nextGrowthValue;
    num growthValue = controller.userVipModel.value!.profile.currentGrowthValue;
    num firstNum = nextLevelGrowthValue - growthValue;
    double widthFactor = growthValue / nextLevelGrowthValue;
    if (widthFactor > 1) {
      widthFactor = 1;
    }
    var headerView = Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().setHeight(168),
        decoration: BoxDecoration(
            // color: Colors.red,
            borderRadius: BorderRadius.circular(14.r),
            image: DecorationImage(
              image: AssetImage('assets/images/Center/vip-card.png'),
              fit: BoxFit.fitWidth,
            )),
        child: Column(
          children: [
            40.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    width: 42,
                    height: 42,
                    child: ClipOval(
                      child: ImgItem(
                        controller.userInfo!.avatar,
                        fit: BoxFit.fitWidth,
                        holderImg: "Center/logo",
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        str: controller.userInfo!.name,
                        fontSize: 14,
                        color: Color(0xffFCF4C7),
                        fontWeight: FontWeight.bold,
                      ),
                      AppGaps.vGap4,
                      AppText(
                        str: 'ID：${controller.userInfo!.id}',
                        color: Color(0xffACABA0),
                        fontSize: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            30.verticalSpace,
            // 进度条
            Container(
                padding: const EdgeInsets.only(
                    top: 7, bottom: 13, left: 15, right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  // color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 8,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 8,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: AppStyles.orderLine,
                                          ),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        alignment: Alignment.topLeft,
                                        heightFactor: 1,
                                        widthFactor: widthFactor,
                                        child: Container(
                                          height: 8,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            color: HexToColor('#DAB85C'),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          12.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppGaps.hGap10,
                              Row(
                                children: [
                                  AppText(
                                    str: growthValue.toString(),
                                    color: AppStyles.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  AppText(
                                    str: '/',
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                  AppText(
                                    str: nextLevelGrowthValue.toString(),
                                    color: AppStyles.white,
                                    fontSize: 13,
                                  ),
                                  10.horizontalSpace,
                                  Container(
                                    width: 150.w,
                                    child: GestureDetector(
                                      // onTap: () {
                                      //   GlobalPages.push(GlobalPages.growthValue);
                                      // },
                                      child: AppText(
                                        str: '再获得{count}成长值可升级'.inArgs({
                                          'count': firstNum < 0 ? 0 : firstNum
                                        }),
                                        color: AppStyles.white,
                                        lines: 2,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Expanded(child: SizedBox())
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Expanded(child: SizedBox()),
                    //   积分
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          GlobalPages.push(GlobalPages.point);
                        },
                        child: Column(
                          children: [
                            AppText(
                              str: (controller.userVipModel.value
                                  ?.profile.point ??
                                  0)
                                  .toString(),
                              color: Color(0xffFCF4C7),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            10.verticalSpace,
                            AppText(
                              str: '积分'.inte +'',
                              color: AppStyles.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
    return headerView;
  }
}
