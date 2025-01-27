import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/caption.dart';

class TitleCell extends StatelessWidget {
  const TitleCell({
    Key? key,
    required this.title,
    this.onMore,
    this.other,
  }) : super(key: key);
  final String title;
  final Function? onMore;
  final Widget? other;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: [
                Obx(
                  () => AppText(
                    str: title.inte,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                other ?? AppGaps.empty
              ],
            ),
          ),
          onMore != null
              ? GestureDetector(
                  onTap: () {
                    onMore!();
                  },
                  child: Row(
                    children: [
                      Obx(
                        () => AppText(
                          str: '更多'.inte,
                          fontSize: 14,
                          color: AppStyles.textNormal,
                        ),
                      ),
                      5.horizontalSpace,
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppStyles.textNormal,
                        size: 14,
                      ),
                    ],
                  ),
                )
              : AppGaps.empty,
        ],
      ),
    );
  }
}
