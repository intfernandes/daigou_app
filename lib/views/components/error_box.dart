import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/load_image.dart';

class ErrorBox extends StatelessWidget {
  const ErrorBox({
    Key? key,
    this.onRefresh,
  }) : super(key: key);
  final Function? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImgItem(
          'Home/network_err',
          width: 300.w,
        ),
        SizedBox(
          width: 120.w,
          child: BeeButton(
            text: '重新请求',
            borderRadis: 999,
            onPressed: onRefresh,
          ),
        )
      ],
    );
  }
}
