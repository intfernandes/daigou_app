import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/common/util.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/list_refresh_event.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/order_model.dart';
import 'package:shop_app_client/services/order_service.dart';
import 'package:shop_app_client/views/components/base_dialog.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/button/plain_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/load_image.dart';

class BeeOrderItem extends StatelessWidget {
  const BeeOrderItem({Key? key, required this.orderModel}) : super(key: key);
  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GlobalPages.push(GlobalPages.orderDetail, arg: {'id': orderModel.id});
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        margin: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
        padding: EdgeInsets.symmetric(
          vertical: 12.h,
          horizontal: 10.w,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  str: orderModel.orderSn,
                ),
                Row(
                  children: [
                    orderModel.exceptional == 1 && orderModel.status != 5
                        ? GestureDetector(
                            onTap: () {
                              onExceptional(context);
                            },
                            child: Container(
                              color: Colors.red[700],
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 5),
                              child: AppText(
                                str: '订单异常'.inte,
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : AppGaps.empty,
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.sp,
                      color: AppStyles.textNormal,
                    ),
                  ],
                ),
              ],
            ),
            20.verticalSpaceFromWidth,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               AppText(
                  str: orderModel.warehouse.warehouseName!,
                ),
                ImgItem(
                  'Home/ship',
                  width: 80.w,
                  fit: BoxFit.fitWidth,
                ),
                AppText(
                  str: orderModel.address.countryName,
                ),
              ],
            ),
            25.verticalSpaceFromWidth,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: AppText(
                    str:
                        '${orderModel.address.receiverName} ${orderModel.address.timezone} ${orderModel.address.phone}',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                5.verticalSpacingRadius,
                AppText(
                  str: (orderModel.address.address != null &&
                          orderModel.address.address!.isNotEmpty)
                      ? orderModel.address.address!
                      : '${orderModel.address.area != null ? '${orderModel.address.area!.name} ' : ''}${orderModel.address.subArea != null ? '${orderModel.address.subArea!.name} ' : ''}${orderModel.address.street} ${orderModel.address.doorNo} ${orderModel.address.city}',
                  lines: 4,
                ),
                5.verticalSpaceFromWidth,
                AppText(
                  str: orderModel.station != null
                      ? '${'自提收货'.inte}-${orderModel.station!.name}'
                      : '送货上门'.inte,
                  fontSize: 14,
                ),
                5.verticalSpaceFromWidth,
                [3, 4, 5].contains(orderModel.status)
                    ? Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              str: '${'物流单号'.inte}：${orderModel.logisticsSn}',
                            ),
                            AppGaps.hGap10,
                            orderModel.logisticsSn.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                              text: orderModel.logisticsSn))
                                          .then((value) =>
                                              EasyLoading.showSuccess(
                                                  '复制成功'.inte));
                                    },
                                    child: Icon(
                                      Icons.copy,
                                      size: 18.sp,
                                    ),
                                  )
                                : AppGaps.empty
                          ],
                        ),
                      )
                    : AppGaps.empty,
                5.verticalSpaceFromWidth,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      str: '${'提交时间'.inte}：${orderModel.createdAt}',
                      fontSize: 13,
                      color: AppStyles.textGrayC,
                    ),
                    AppText(
                      str: orderModel.paymentTypeName,
                      fontSize: 13,
                      color: orderModel.onDeliveryStatus != 0
                          ? AppStyles.textRed
                          : AppStyles.textBlack,
                    )
                  ],
                )
              ],
            ),
            AppGaps.vGap10,
            _buildOrderBtns(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderBtns(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (orderModel.status == OrderStatus.checking.id)
          AppText(
            str: '等待客服确认支付'.inte,
            fontSize: 14,
            color: AppStyles.textRed,
          ),
        if ([OrderStatus.waitPay.id, OrderStatus.checkFailure.id]
                .contains(orderModel.status) &&
            orderModel.onDeliveryStatus != 11 &&
            orderModel.groupMode == 0)
          Container(
            margin: const EdgeInsets.only(left: 10),
            height: 30.h,
            child: BeeButton(
              text: (orderModel.status == OrderStatus.waitPay.id ||
                      orderModel.onDeliveryStatus == 1 ||
                      orderModel.paymentStatus == 1)
                  ? '去付款'
                  : '重新支付',
              onPressed: () async {
                var s = await GlobalPages.push(GlobalPages.transportPay, arg: {
                  'id': orderModel.id,
                  'payModel': 1,
                  'deliveryStatus': orderModel.onDeliveryStatus,
                });
                if (s != null) {
                  ApplicationEvent.getInstance()
                      .event
                      .fire(ListRefreshEvent(type: 'refresh'));
                }
              },
            ),
          ),
        if ([OrderStatus.waitPay.id, OrderStatus.checkFailure.id]
                .contains(orderModel.status) &&
            orderModel.groupMode != 0 &&
            orderModel.isLeaderOrder)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppText(
                    str: '该团购单为团长代款,请您及时付款'.inte,
                    fontSize: 14,
                    color: AppStyles.textRed,
                    lines: 3,
                  ),
                ),
                10.horizontalSpace,
                SizedBox(
                  height: 30.h,
                  child: BeeButton(
                    text: '前往支付',
                    onPressed: () {
                      GlobalPages.push(GlobalPages.groupOrderPorcess,
                          arg: {'id': orderModel.parentId});
                    },
                  ),
                ),
              ],
            ),
          ),
        if ([OrderStatus.waitPay.id, OrderStatus.checkFailure.id]
                .contains(orderModel.status) &&
            orderModel.groupMode != 0 &&
            !orderModel.isLeaderOrder)
          AppText(
            str: '该团购单为团长代款,您无需支付'.inte,
            fontSize: 14,
            color: AppStyles.textRed,
            lines: 2,
          ),
        if ([4, 5].contains(orderModel.status))
          SizedBox(
            height: 30.h,
            child: HollowButton(
              text: '查看物流',
              textColor: AppStyles.textDark,
              borderColor: AppStyles.textGrayC,
              onPressed: () {
                if (orderModel.boxes.isNotEmpty) {
                  BaseDialog.showBoxsTracking(context, orderModel);
                } else {
                  GlobalPages.push(GlobalPages.orderTracking,
                      arg: {"order_sn": orderModel.orderSn});
                }
              },
            ),
          ),
        if (orderModel.status == 4)
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 10.w),
              height: 30.h,
              child: BeeButton(
                text: '确认收货',
                onPressed: () {
                  onSign(context);
                },
              ),
            ),
          ),
        if (orderModel.status == 5 && orderModel.evaluated == 0)
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 10.w),
              height: 30.h,
              child: BeeButton(
                text: '我要评价',
                onPressed: () {
                  GlobalPages.push(GlobalPages.orderComment,
                      arg: {'order': orderModel});
                },
              ),
            ),
          ),
      ],
    );
  }

  // 异常件说明
  void onExceptional(context) async {
    var result = await OrderService.getOrderExceptional(orderModel.id);
    if (result != null) {
      BaseDialog.normalDialog(
        context,
        title: '异常说明'.inte,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.remark,
              ),
              result.images.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.only(top: 15),
                      child: ImgItem(
                        result.images[0],
                        fit: BoxFit.fitWidth,
                        width: 100,
                      ),
                    )
                  : AppGaps.empty,
            ],
          ),
        ),
      );
    }
  }

  // 签收
  void onSign(BuildContext context) async {
    var data = await BaseDialog.confirmDialog(context, '${'您确定要签收吗'.inte}？');
    if (data != null) {
      int id = orderModel.id;
      EasyLoading.show();
      var result = await OrderService.signed(id);
      EasyLoading.dismiss();
      if (result['ok']) {
        BaseUtils.showToast('签收成功'.inte);
        ApplicationEvent.getInstance()
            .event
            .fire(ListRefreshEvent(type: 'refresh'));
      } else {
        BaseUtils.showToast(result['msg']);
      }
    }
  }
}
