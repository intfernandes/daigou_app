// ignore_for_file: unnecessary_new

/*
  我的积分
 */

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/user_point_item_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/empty_app_bar.dart';
import 'package:jiyun_app_client/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/user/vip/point/point_controller.dart';

class PointView extends GetView<PointController> {
  const PointView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: BaseStylesConfig.bgGray,
      body: ListRefresh(
        renderItem: buildCellForFirstListView,
        refresh: controller.loadList,
        more: controller.loadMoreList,
      ),
    );
  }

  Widget buildCellForFirstListView(int index, UserPointItemModel model) {
    var container = Container(
      height: 55,
      margin: const EdgeInsets.only(right: 15, left: 15),
      width: ScreenUtil().screenWidth - 30,
      color: BaseStylesConfig.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: ZHTextLine(
                str: model.ruleName,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: ZHTextLine(
                alignment: TextAlign.center,
                str: model.createdAt,
                fontSize: 12,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              child: ZHTextLine(
                str: model.type == 1
                    ? '+' + model.value.toString()
                    : '-' + model.value.toString(),
                fontSize: 15,
                color: model.type == 1
                    ? BaseStylesConfig.textDark
                    : BaseStylesConfig.textRed,
              ),
            ),
          ),
        ],
      ),
    );
    if (index == 0) {
      return Column(
        children: [
          buildCustomViews(),
          container,
        ],
      );
    }
    return container;
  }

  Widget buildCustomViews() {
    var headerView = SizedBox(
      child: Stack(
        children: <Widget>[
          SizedBox(
            child: LoadImage(
              'AboutMe/jifen-bg',
              fit: BoxFit.fitWidth,
              width: ScreenUtil().screenWidth,
            ),
          ),
          Positioned(
            top: ScreenUtil().statusBarHeight,
            left: 15,
            child: const BackButton(
              color: Colors.white,
            ),
          ),
          Positioned(
            bottom: 70,
            //设置背景图片
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().screenWidth,
              child: Column(
                children: <Widget>[
                  ZHTextLine(
                    str: (controller.userPointModel.value?.point ?? 0)
                        .toString(),
                    fontSize: 30,
                    color: BaseStylesConfig.vipNormal,
                    fontWeight: FontWeight.bold,
                  ),
                  Sized.vGap5,
                  ZHTextLine(
                    str: '可用积分'.ts,
                    color: BaseStylesConfig.vipNormal,
                  ),
                  Sized.vGap15,
                  ZHTextLine(
                    str: '使用规则'.ts +
                        '：' +
                        (controller.userPointModel.value?.configPoint ?? 0)
                            .toString() +
                        '${'积分'.ts}=' +
                        (controller.localModel?.currencySymbol ?? '') +
                        (controller.userPointModel.value?.configAmount ?? 0)
                            .toString(),
                    fontSize: 14,
                    color: BaseStylesConfig.vipNormal,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              left: 15,
              right: 15,
              bottom: 0,
              child: Container(
                  height: 55,
                  width: ScreenUtil().screenWidth - 30,
                  color: BaseStylesConfig.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: ZHTextLine(
                            str: '类型'.ts,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          child: ZHTextLine(
                            str: '时间'.ts,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                            alignment: Alignment.center,
                            child: ZHTextLine(
                              str: '明细'.ts,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  )))
        ],
      ),
    );
    return headerView;
  }
}
