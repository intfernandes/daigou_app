import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/tracking_model.dart';
import 'package:shop_app_client/views/components/banner.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/empty_app_bar.dart';
import 'package:shop_app_client/views/components/empty_box.dart';
import 'package:shop_app_client/views/components/input/base_input.dart';
import 'package:shop_app_client/views/express/express_query_controller.dart';
import 'package:timeline_tile/timeline_tile.dart';

/*
  物流跟踪
 */

class BeeTrackingView extends GetView<BeeTrackingController> {
  const BeeTrackingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: const EmptyAppBar(),
      backgroundColor: AppStyles.bgGray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().setHeight(190),
                  child: const BannerBox(imgType: 'track_image'),
                ),
                Positioned(
                  left: 15,
                  top: ScreenUtil().statusBarHeight,
                  child: const BackButton(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSearchView(),
                  AppGaps.vGap10,
                  Obx(
                    () => controller.isSearch.value
                        ? buildResultView()
                        : AppGaps.empty,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 快递单号
  Widget buildSearchView() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Obx(
              () => AppText(
                str: '物流跟踪'.inte,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          AppGaps.line,
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 45,
              decoration: BoxDecoration(
                color: AppStyles.bgGray,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Obx(
                        () => BaseInput(
                          board: true,
                          controller: controller.expressNumController,
                          focusNode: controller.expressNumNode,
                          autoShowRemove: false,
                          isCollapsed: true,
                          maxLength: 50,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          hintText: '请输入快递单号'.inte,
                          onSubmitted: (data) {
                            controller.onQuery();
                          },
                        ),
                      ),
                    ),
                    BeeButton(
                      text: '查询',
                      borderRadis: 0,
                      onPressed: controller.onQuery,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  // 物流结果
  Widget buildResultView() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Obx(
        () => controller.trackingList.isEmpty
            ? emptyBox('暂无物流信息')
            : ListView.builder(
                itemCount: controller.trackingList.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, int index) {
                  TrackingModel model = controller.trackingList[index];
                  return TimelineTile(
                    isFirst: index == 0,
                    isLast: index == controller.trackingList.length - 1,
                    indicatorStyle: IndicatorStyle(
                      width: 17,
                      height: 17,
                      padding: const EdgeInsets.only(right: 10),
                      drawGap: true,
                      indicatorXY: 0,
                      indicator: Icon(
                        index == 0 ? Icons.check_circle : Icons.circle,
                        size: 17,
                        color: index == 0 ? AppStyles.green : Colors.grey[300],
                      ),
                      iconStyle: index == 0
                          ? IconStyle(
                              iconData: Icons.check,
                              fontSize: 15,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    endChild: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          str: model.ftime,
                          fontSize: 14,
                          color: AppStyles.textGray,
                        ),
                        AppGaps.vGap10,
                        AppText(
                          str: model.context,
                          lines: 10,
                        ),
                        AppGaps.vGap15,
                      ],
                    ),
                    beforeLineStyle: LineStyle(
                      thickness: 2,
                      color: (index == 0 || index == 1)
                          ? AppStyles.green
                          : Colors.grey[300]!,
                    ),
                    afterLineStyle: index > 0
                        ? LineStyle(
                            thickness: 2,
                            color: Colors.grey[300]!,
                          )
                        : null,
                  );
                },
              ),
      ),
    );
  }
}
