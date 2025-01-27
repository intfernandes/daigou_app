import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/instance_manager.dart';
import 'package:shop_app_client/common/util.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/extension/rate_convert.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/ship_line_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/views/components/caption.dart';

class LineItemWidget extends StatelessWidget {
  const LineItemWidget({
    Key? key,
    required this.model,
    this.onSelect,
    this.margin,
    this.padding,
    this.showLineType = true,
  }) : super(key: key);
  final ShipLineModel model;
  final Function? onSelect;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool showLineType;

  @override
  Widget build(BuildContext context) {
    var localModel = Get.find<AppStore>().localModel;
    var currencyModel = Get.find<AppStore>().currencyModel.value;
    return GestureDetector(
      onTap: () {
        if (onSelect != null) {
          onSelect!();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppStyles.white,
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
        ),
        margin: margin ?? EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 0),
        padding: padding ?? EdgeInsets.fromLTRB(14.w, 0, 14.w, 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showLineType) ...[
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF51CEA5),
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(10.r)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                child: AppText(
                  str: model.isDelivery == 0
                      ? '派送'.inte
                      : (model.isDelivery == 1 ? '自提'.inte : '派送/自提'.inte),
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              10.verticalSpaceFromWidth,
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  str: model.name,
                  fontSize: 18,
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppStyles.textRed),
                    children: [
                      TextSpan(text: (currencyModel?.code ?? '')),
                      TextSpan(
                        text: (model.expireFee ?? 0)
                            .priceConvert(showPriceSymbol: false),
                        style: TextStyle(fontSize: 22.sp),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            4.verticalSpaceFromWidth,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  str: model.region!.referenceTime,
                  fontSize: 13,
                ),
                AppText(
                  str: '预估运费'.inte,
                  color: AppStyles.textRed,
                  fontSize: 12,
                ),
              ],
            ),
            4.verticalSpaceFromWidth,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  str: '计费重'.inte +
                      '：' +
                      ((model.countWeight ?? 0) / 1000).toStringAsFixed(2) +
                      (localModel?.weightSymbol ?? ''),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                10.horizontalSpace,
                AppText(
                  str: BaseUtils.getLineModelName(model.mode).inte,
                  fontSize: 12,
                ),
              ],
            ),
            10.verticalSpaceFromWidth,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (model.labels != null && model.labels!.isNotEmpty)
                    ? Flexible(
                        child: Row(
                          children: model.labels!
                              .map(
                                (e) => Container(
                                  color: AppStyles.primary,
                                  margin: const EdgeInsets.only(right: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  child: AppText(
                                    str: e.name,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : AppGaps.empty,
                GestureDetector(
                    onTap: () {
                      GlobalPages.push(GlobalPages.lineDetail,
                          arg: {'line': model, 'type': 2});
                    },
                    child: AppText(
                      str: '查看详情'.inte,
                      color: AppStyles.textGrayC9,
                      fontSize: 12,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
