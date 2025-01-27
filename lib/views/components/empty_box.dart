import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/load_image.dart';

Widget emptyBox([String? content]) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Center(
        child: Column(
          children: [
            const ImgItem(
              'Home/empty',
              width: 140,
              fit: BoxFit.fitWidth,
            ),
            Obx(
              () => AppText(
                str: (content ?? '暂无内容').inte,
                color: AppStyles.textGray,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
