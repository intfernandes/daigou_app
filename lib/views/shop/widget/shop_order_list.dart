import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/list_refresh_event.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/parcel_model.dart';
import 'package:shop_app_client/models/shop/shop_order_model.dart';
import 'package:shop_app_client/services/shop_service.dart';
import 'package:shop_app_client/views/components/base_dialog.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/goods/shop_order_item.dart';
import 'package:shop_app_client/views/components/list_refresh.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:shop_app_client/views/shop/order/shop_order_controller.dart';

class ShopOrderList extends StatefulWidget {
  const ShopOrderList({
    Key? key,
    required this.status,
    required this.keyword,
  }) : super(key: key);
  final int status;
  final String keyword;

  @override
  State<ShopOrderList> createState() => _ShopOrderListState();
}

class _ShopOrderListState extends State<ShopOrderList> {
  int page = 0;
  final controller = Get.find<ShopOrderController>();

  loadData({type}) async {
    page = 0;
    return await loadMoreData();
  }

  loadMoreData() async {
    var params = {
      'page': ++page,
      'size': 10,
      'keyword': controller.keyword,
      'sort': 'desc'
    };
    if (widget.status != 0) {
      for (var i = 0; i < statusList.length; i++) {
        params['status[$i]'] = statusList[i];
      }
    }
    var data = await ShopService.getOrderList(params);
    return data;
  }

  List<int> get statusList {
    List<int> list = [];
    switch (widget.status) {
      case 1:
        list = [0];
        break;
      case 2:
        list = [1, 2];
        break;
      case 3:
        list = [3, 4];
        break;
      case 4:
        list = [5];
        break;
      case 5:
        list = [6];
        break;
      case 6:
        list = [10];
        break;
    }
    return list;
  }

  // 订单支付
  void orderPay({
    required String orderSn,
  }) async {
    var s = await GlobalPages.push(GlobalPages.shopOrderPay, arg: {
      'order': [orderSn],
      'fromOrderList': true,
    });
    if (s != null) {
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'refresh'));
    }
  }

  // 跳转到物流订单
  void toTransportDetail(ParcelModel package) {
    if (package.orderId != null) {
      // 跳转到订单详情
      GlobalPages.push(GlobalPages.orderDetail, arg: {'id': package.orderId});
    } else {
      // 跳转到包裹详情
      GlobalPages.push(GlobalPages.parcelDetail,
          arg: {'id': package.id, 'edit': false});
    }
  }

  // 取消订单
  void orderCancel({
    required BuildContext context,
    required int orderId,
    Function? onSuccess,
  }) async {
    var confirmed = await BaseDialog.cupertinoConfirmDialog(
      context,
      '您确定要取消订单吗'.inte,
    );
    if (confirmed != true) return;
    var res = await ShopService.orderCancel(orderId);
    if (res['ok']) {
      ApplicationEvent.getInstance()
          .event
          .fire(ListRefreshEvent(type: 'refresh'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      child: RefreshView(
        renderItem: (int index, ShopOrderModel model) {
          return BeeShopOrder(
            model: model,
            onPay: () {
              orderPay(orderSn: model.orderSn);
            },
            onTransportDetail: toTransportDetail,
            onCancel: () {
              orderCancel(context: context, orderId: model.id);
            },
          );
        },
        refresh: loadData,
        more: loadMoreData,
        emptyWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoadAssetImage(
              'Transport/order_empty',
              fit: BoxFit.fitWidth,
              width: 200.w,
            ),
            10.verticalSpaceFromWidth,
            Container(
              constraints: BoxConstraints(maxWidth: 270.w),
              child: AppText(
                str: '您还没有任何订单，去下单吧~'.inte,
                fontSize: 12,
                color: AppStyles.textGrayC9,
                alignment: TextAlign.center,
                lineHeight: 1.8,
                lines: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
