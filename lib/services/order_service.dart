// ignore_for_file: constant_identifier_names

import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/services/base_service.dart';

/*
  订单相关的服务
 */
class OrderService {
  // 获取订单
  static const String ORDER = 'order';
  // 获取订单详情
  static const String ORDERDETAIL = 'order/:id';
  // 获取订单打包视频
  static const String orderVideoApi = 'order/:id/videos';
  // 确认收货接口
  static const String CHECKORDER = 'order/check/:id';
  // 订单支付方式列表
  static const String ORDERPAYLIST = 'order/pay-method';
  // 余额支付订单
  static const String OrderPayBalance = 'order/pay/balance';
  // 获取微信支付数据
  static const String OrderPayWeChat = 'order/pay/:id';
  // 余额支付充值
  static const String UserMemberPayBalance = 'user-member/pay/balance';
  // 余额充值微信支付
  static const String balancePayByWechat = 'balance/wechat-recharge';
  // 会员充值微信支付
  static const String userMemberPayByWechat = 'user-member/pay/wechat';
  // 预览订单信息
  static const String previewPay = 'order/h5-pay';

  /*
    获取订单列表
    返回 {
      dataList: List<OrderModel>,
      total: 100,
      page: 1
    }
   */
  static Future<Map> getList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    List<OrderModel> dataList = List<OrderModel>.empty(growable: true);
    await HttpClient().get(ORDER, queryParameters: params).then((response) {
      var list = response.data;
      list['data']?.forEach((good) {
        dataList.add(OrderModel.fromJson(good));
      });
      result = {
        "dataList": dataList,
        'total': response.data['last_page'],
        'pageIndex': response.data['current_page']
      };
    });

    return result;
  }

  /*
    确认签收包裹
   */
  static Future<Map> signed(int id) async {
    Map result = {'ok': false, 'msg': ''};

    await HttpClient()
        .post(CHECKORDER.replaceAll(':id', id.toString()))
        .then((response) => {
              result = {
                'ok': response.ok,
                'msg': response.msg ?? response.error?.message
              }
            });

    return result;
  }

  // 获取订单详情
  static Future<OrderModel?> getDetail(int id) async {
    OrderModel? result;
    await HttpClient()
        .get(
          ORDERDETAIL.replaceAll(':id', id.toString()),
        )
        .then((response) => {result = OrderModel.fromJson(response.data)})
        .onError((error, stackTrace) => {});
    return result;
  }

  /*
    更新订单
    准备支付
   */
  static Future updateReadyPay(
      Map params, OnSuccess onSuccess, OnFail onFail) async {
    return await HttpClient().post(previewPay, data: params).then((response) {
      if (response.ok) {
        onSuccess(response);
      } else {
        onFail(response.msg.toString());
      }
    }).onError((error, stackTrace) => onFail(error.toString()));
  }

  /*
    新增订单
   */
  static Future<Map> store(Map<String, dynamic> params) async {
    Map result = {'ok': false, 'msg': ''};

    await HttpClient().post(ORDER, data: params).then((response) {
      result = {
        'ok': response.ok,
        'msg': response.msg ?? response.error!.message
      };
    });

    return result;
  }

  /*
    订单打包视频列表
   */
  static Future<List<String>> getOrderPackVideo(int id) async {
    List<String> result = [];
    await HttpClient()
        .get(orderVideoApi.replaceAll(':id', id.toString()))
        .then((res) {
      if (res.ok) {
        res.data.forEach((item) => result.add(item['url']));
      }
    });
    return result;
  }
}
