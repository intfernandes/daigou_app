import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/views/components/base_search.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/views/components/load_image.dart';
import 'package:get/instance_manager.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:get/get.dart';


class HomeHeader extends StatefulWidget implements PreferredSizeWidget {
  const HomeHeader({Key? key,}) : super(key: key);

  @override
  HomeHeaderState createState() => HomeHeaderState();

  @override
  Size get preferredSize => Size.fromHeight(55.h + kToolbarHeight);
}

class HomeHeaderState extends State<HomeHeader> {
  @override
  void initState() {

  }
  // Widget thisMessage() {
  //   var hasNotRead = Get.find<AppStore>().hasNotRead.value;
  //     print('你就说拿没拿到吧');
  //     print(hasNotRead);
  //     return hasNotRead
  //         ? Positioned(
  //       right: 12.w,
  //       child: ClipOval(
  //         child: Container(
  //           width: 8,
  //           height: 8,
  //           color: AppStyles.textRed,
  //         ),
  //       ),
  //     )
  //         : AppGaps.empty;
  // }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(14.w, kToolbarHeight + 10.h, 14.w, 8.h),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child:
              GestureDetector(
                onTap: () {
                  GlobalPages.push(GlobalPages.goodsCategory, arg: {'autoFocus': true});
                },
                child: const BaseSearch(readOnly: true),
              ),),
            8.horizontalSpace,
            Expanded(child:
            GestureDetector(
                onTap: (){
                  GlobalPages.push(GlobalPages.notice);
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    LoadAssetImage(
                      'Home/message',
                      width: 22.w,
                      height: 22.w,
                    ),
                    Container(
                      child: Obx((){
                        var hasNotRead = Get.find<AppStore>().hasNotRead.value;
                        return hasNotRead
                            ? Positioned(
                          right: 12.w,
                          child: ClipOval(
                            child: Container(
                              width: 8,
                              height: 8,
                              color: AppStyles.textRed,
                            ),
                          ),
                        )
                            : AppGaps.empty;
                      }),
                    )
                  ],
                ),
            )
            )
          ],
        )
    );
  }
}
