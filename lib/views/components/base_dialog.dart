import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/order_model.dart';
import 'package:jiyun_app_client/models/parcel_box_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';

/*
  公共弹窗
 */

class BaseDialog {
  // 确认弹窗
  static Future<bool?> confirmDialog(BuildContext context, String content,
      {String? title,
      bool showCancelButton = true,
      bool barrierDismissible = false}) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              alignment: Alignment.center,
              child: Text((title ?? '提示').ts),
            ),
            content: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(content),
            ),
            actions: <Widget>[
              showCancelButton
                  ? TextButton(
                      child: ZHTextLine(
                        str: '取消'.ts,
                        color: BaseStylesConfig.textNormal,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  : Sized.empty,
              TextButton(
                child: ZHTextLine(
                  str: '确认'.ts,
                  color: BaseStylesConfig.textBlack,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  // ios 风格 确认弹窗
  static Future<bool?> cupertinoConfirmDialog(
      BuildContext context, String content,
      {String? title,
      bool showCancelButton = true,
      bool barrierDismissible = false}) {
    return showDialog<bool>(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text((title ?? "提示").ts),
          content: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(content),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text('取消'.ts),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            CupertinoDialogAction(
              child: Text('确定'.ts),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  // 普通弹窗
  static void normalDialog(
    BuildContext context, {
    String? title,
    double? titleFontSize,
    required Widget child,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: ScreenUtil().screenHeight - 200,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: const BoxDecoration(
                            border: Border(
                          bottom: BorderSide(color: BaseStylesConfig.line),
                        )),
                        alignment: Alignment.center,
                        child: ZHTextLine(
                          str: title,
                          fontSize: titleFontSize ?? 15,
                        ),
                      )
                    : Sized.empty,
                child,
                Sized.line,
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: ZHTextLine(
                        str: '确认'.ts, color: BaseStylesConfig.primary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 多箱物流
  static void showBoxsTracking(
      BuildContext context, OrderModel orderModel) async {
    List<Widget> list = [];
    for (var i = 0; i < orderModel.boxes.length; i++) {
      ParcelBoxModel boxModel = orderModel.boxes[i];
      var view = CupertinoActionSheetAction(
        child: Text(
          '${'子订单'.ts}-' '${i + 1}',
        ),
        onPressed: () {
          Navigator.of(context)
              .pop(boxModel.logisticsSn.isEmpty ? '' : boxModel.logisticsSn);
        },
      );
      list.add(view);
    }
    String? result = await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: list,
            cancelButton: CupertinoActionSheetAction(
              child: Text('取消'.ts),
              onPressed: () {
                Navigator.of(context).pop('cancel');
              },
            ),
          );
        });
    if (result == 'cancel') {
      return;
    }
    if (result != null && result.isEmpty) {
      Routers.push(Routers.orderTracking, {"order_sn": orderModel.orderSn});
    } else {
      Routers.push(Routers.orderTracking, {"order_sn": result});
    }
  }
}
