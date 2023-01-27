import 'package:fluttertoast/fluttertoast.dart';
import 'package:jiyun_app_client/models/self_pickup_station_order_model.dart';
import 'package:flutter/material.dart';

class Util {
  static void showSnackBar(BuildContext context, String msg,
      [GlobalKey<ScaffoldState>? _scaffoldKey]) {
    if (_scaffoldKey != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
        SnackBar(content: Text(msg)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  static void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIos: 2,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // 支付方式名称
  static String getPayTypeName(String type) {
    String name;
    switch (type) {
      case 'wechat':
        name = '微信支付';
        break;
      case 'balance':
        name = '余额支付';
        break;
      case 'alipay':
        name = '支付宝支付';
        break;
      case 'on_delivery':
        name = '货到付款';
        break;
      default:
        name = type;
        break;
    }
    return name;
  }

  // 订单状态
  static String getOrderStatusName(
      int status, SelfPickupStationOrderModel? stationOrder) {
    String statusStr = '';
    //1 待处理 2待付款 3待发货 4已发货5已签收11审核中12审核失败
    switch (status) {
      case 1:
        statusStr = '待处理';
        break;
      case 2:
        statusStr = '待支付';
        break;
      case 3:
        statusStr = '待发货';
        break;
      case 4:
        if (stationOrder == null) {
          statusStr = '已发货';
        } else {
          if (stationOrder.status == 1) {
            statusStr = '已到自提点';
          } else if (stationOrder.status == 3) {
            statusStr = '自提点出库';
          } else if (stationOrder.status == 4) {
            statusStr = '自提签收';
          }
        }
        break;
      case 5:
        if (stationOrder == null) {
          statusStr = '已签收';
        } else {
          if (stationOrder.status == 1) {
            statusStr = '已到自提点';
          } else if (stationOrder.status == 3) {
            statusStr = '自提点出库';
          } else if (stationOrder.status == 4) {
            statusStr = '自提签收';
          }
        }
        break;
      case 11:
        statusStr = '审核中';
        break;
      case 12:
        statusStr = '审核失败';
        break;
      default:
    }
    return statusStr;
  }

  // 语言占位符替换
  static List<String> parsePlaceholder(String str) {
    List<String> list = [];
    int position = 0;
    int strLength = str.length;
    while (position < strLength) {
      String char = str[position++];
      if (char == '{') {
        String sub = '';
        if (position < strLength) {
          char = str[position++];
        }
        while (position < strLength && char != '}') {
          sub += char;
          char = str[position++];
        }
        list.add(sub);
      }
    }
    return list;
  }
}
