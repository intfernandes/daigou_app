import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/button/plain_button.dart';
import 'package:shop_app_client/views/components/caption.dart';

class PlatformDropdownMenu extends StatefulWidget {
  const PlatformDropdownMenu({
    Key? key,
    required this.show,
    required this.onHide,
    required this.offset,
    required this.platform,
    required this.onConfirm,
  }) : super(key: key);
  final bool show;
  final Function onHide;
  final Function(String value) onConfirm;
  final double offset;
  final String platform;

  @override
  State<PlatformDropdownMenu> createState() => _PlatformDropdownMenuState();
}

class _PlatformDropdownMenuState extends State<PlatformDropdownMenu> {
  late String platform;

  @override
  void initState() {
    super.initState();
    platform = widget.platform;
  }

  void onPlatform(String value) {
    setState(() {
      platform = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: widget.offset > 35.h ? 32.h : (35.h - widget.offset + 32.h),
      child: Container(
        color: const Color(0x80000000),
        child: Offstage(
          offstage: !widget.show,
          child: Column(
            children: [
              contentCell(),
              maskCell(),
            ],
          ),
        ),
      ),
    );
  }

  Widget contentCell() {
    List<Map<String, String>> platforms = [
      {'name': '淘宝', 'value': 'taobao'},
      {'name': '1688', 'value': '1688'},
      {'name': '京东', 'value': 'jd'},
      {'name': '拼多多', 'value': 'pinduoduo'},
    ];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.r),
          bottomRight: Radius.circular(10.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            str: '购买平台'.inte,
            fontSize: 14,
          ),
          10.verticalSpace,
          Wrap(
            spacing: 20.w,
            runSpacing: 10.w,
            children: platforms
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      onPlatform(e['value']!);
                    },
                    child: Container(
                      height: 30.h,
                      width: 100.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      decoration: BoxDecoration(
                          color: platform == e['value']
                              ? const Color(0xFFFFF8D4)
                              : AppStyles.bgGray,
                          borderRadius: BorderRadius.circular(999)),
                      child: AppText(
                        str: e['name']!.inte,
                        fontSize: 14,
                        color: platform == e['value']
                            ? Colors.black
                            : AppStyles.textGrayC9,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          20.verticalSpace,
          SizedBox(
            height: 35.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: HollowButton(
                  text: '取消',
                  textColor: AppStyles.textGray,
                  borderColor: AppStyles.textGray,
                  onPressed: () {
                    widget.onHide();
                  },
                )),
                20.horizontalSpace,
                Expanded(
                    child: BeeButton(
                  text: '确认',
                  borderRadis: 999,
                  fontWeight: FontWeight.bold,
                  onPressed: () {
                    widget.onConfirm(platform);
                  },
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 蒙层
  Widget maskCell() {
    return GestureDetector(
      onTap: () {
        widget.onHide();
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
      ),
    );
  }
}
