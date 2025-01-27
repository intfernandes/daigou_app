import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/common/util.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/pay_type_model.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/group/widget/countdown_widget.dart';
import 'package:shop_app_client/views/payment/shop_pay/shop_order_pay_conctroller.dart';

class ShopOrderPayView extends GetView<ShopOrderPayController> {
  const ShopOrderPayView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppStyles.bgGray,
        leading: const BackButton(color: Colors.black),
        title: AppText(
          str: '订单支付'.inte,
          fontSize: 17,
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 5.r, color: const Color(0x0D000000)),
          ],
        ),
        child: SafeArea(
            child: Row(
          children: [
            Obx(
              () => Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppStyles.textDark,
                        ),
                        children: [
                          TextSpan(text: '总计'.inte + '：'),
                          TextSpan(
                            text: controller.totalAmount
                                .priceConvert(needFormat: false),
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Color(0xff333333),
                            ),
                          ),
                        ],
                      ),
                    ),
                    2.verticalSpace,
                    Row(
                      children: [
                        AppText(
                          str: '不含国际运费'.inte,
                          color: AppStyles.textGrayC9,
                          fontSize: 10,
                        ),
                        2.horizontalSpace,
                        Icon(
                          Icons.info_outline,
                          color: Color(0xff999999),
                          size: 12.sp,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            BeeButton(
              text: '确认支付',
              borderRadis: 999,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              onPressed: () {
                controller.onPay(context);
              },
            ),
          ],
        )),
      ),
      backgroundColor: AppStyles.bgGray,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Obx(
                () => Container(
                  margin: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 10.h),
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ImgItem(
                        'Shop/order_pay',
                        width: 150.w,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: controller.currencyModel.value?.code ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                              color: AppStyles.textDark,
                            ),
                          ),
                          TextSpan(
                            text: controller.problemOrder.value != null
                                ? num.parse(
                                        controller.problemOrder.value!.amount ??
                                            '0')
                                    .priceConvert(
                                        showPriceSymbol: false,
                                        needFormat: false)
                                : controller.totalAmount.priceConvert(
                                    showPriceSymbol: false, needFormat: false),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36.sp,
                              color: AppStyles.textDark,
                            ),
                          ),
                        ]),
                      ),
                      5.verticalSpace,
                      controller.problemOrder.value == null
                          ? CountdownWidget(
                              total: controller.endUtil.value,
                              orderPay: true,
                            )
                          : AppGaps.empty,
                      10.verticalSpace,
                    ],
                  ),
                ),
              ),
              Obx(
                  ()=>controller.hasBalance.value? Container(
                    padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 20.h),
                    margin: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          child: Row(
                            children: [
                              ImgItem(
                                'Shop/balance_pay',
                                width: 28.w,
                              ),
                              11.horizontalSpace,
                              AppText(
                                str: '余额支付'.inte,
                                fontSize: 14,
                                color: Color(0xff333333),
                              ),
                              Expanded(child: SizedBox()),
                              GestureDetector(
                                onTap: (){
                                  controller.selectedPayType.value = controller.balancePay.value;
                                },
                                child: Obx(() => controller.selectedPayType.value == controller.balancePay.value
                                    ? const Icon(
                                  Icons.check_circle,
                                  color: AppStyles.primary,
                                )
                                    : const Icon(Icons.radio_button_unchecked,
                                    color: AppStyles.textGray)),
                              )
                            ],
                          ),
                        ),
                        10.verticalSpace,
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4.r)),
                            color: Color(0xffFFECEC),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              AppText(
                                color: Color(0xff666666),
                                fontSize: 14,
                                str: controller.myBalance.value
                                    .priceConvert(needFormat: false),
                              ),
                              GestureDetector(
                                onTap: () {
                                  GlobalPages.push(GlobalPages.recharge,
                                      arg: context);
                                },
                                child: Row(
                                  children: <Widget>[
                                    AppText(
                                      str: '充值'.inte,
                                      fontSize: 14,
                                      color: AppStyles.primary,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_right,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ):AppGaps.empty,
              ),
              12.verticalSpace,
              Obx(
                () => Container(
                    height: controller.hasBalance.value?((controller.payTypeList.length - 1)* 50).toDouble()
                        :(controller.payTypeList.length * 50).toDouble(),
                    clipBehavior: Clip.none,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.r)),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 14.w),
                    child: showPayTypeView()),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  // 支付方式列表
  Widget showPayTypeView() {
    var listView = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: payTypeCell,
      itemCount: controller.payTypeList.length,
    );
    return listView;
  }

  Widget payTypeCell(BuildContext context, int index) {
    PayTypeModel typeMap = controller.payTypeList[index];
    if(typeMap.name=='balance')return Container();
    return GestureDetector(
        onTap: () {
          if (controller.selectedPayType.value == typeMap) return;
          controller.selectedPayType.value = typeMap;
        },
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.only(right: 15, left: 15),
          height: 50,
          width: ScreenUtil().screenWidth,
          child: Row(
            children: [
              ImgItem(
                controller.getPayTypeIcon(typeMap.name),
                height: 30.w,
                width: 30.w,
              ),
              15.horizontalSpace,
              Expanded(
                child: AppText(
                  str: BaseUtils.getPayTypeName(typeMap.name).inte,
                ),
              ),
              Obx(() => controller.selectedPayType.value == typeMap
                  ? const Icon(
                      Icons.check_circle,
                      color: AppStyles.primary,
                    )
                  : const Icon(Icons.radio_button_unchecked,
                      color: AppStyles.textGray)),
            ],
          ),
        ));
  }
}
