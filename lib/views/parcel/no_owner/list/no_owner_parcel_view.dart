// ignore_for_file: unnecessary_const

/*
  无人认领包裹
 */

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/models/parcel_model.dart';
import 'package:huanting_shop/views/components/button/main_button.dart';
import 'package:huanting_shop/views/components/caption.dart';
import 'package:huanting_shop/views/components/goods/search_input.dart';
import 'package:huanting_shop/views/components/list_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huanting_shop/views/parcel/no_owner/list/no_owner_parcel_controller.dart';

class AbnomalParcelPage extends GetView<AbnomalParcelLogic> {
  const AbnomalParcelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: AppText(
            str: '异常件认领'.ts,
            color: AppColors.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: AppColors.bgGray,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            children: <Widget>[
              headerView(),
              Expanded(
                child: Container(
                  child: buildListView(context),
                ),
              )
            ],
          ),
        ));
  }

  Widget buildListView(context) {
    return RefreshView(
      renderItem: buildCellList,
      refresh: controller.loadList,
      more: controller.loadMoreList,
      shrinkWrap: true,
    );
  }

  Widget headerView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      color: Colors.white,
      child: SearchCell(
        hintText: '请输入快递单号'.ts,
        onSearch: (value) {
          controller.keyword = value;
          controller.onSearch();
        },
      ),
    );
  }

  Widget buildCellList(int index, ParcelModel model) {
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 10, right: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    AppText(
                      str: '快递单号'.ts + '：',
                      fontSize: 14,
                    ),
                    AppText(
                      str: model.expressNum ?? "",
                      fontSize: 14,
                    ),
                  ],
                ),
                5.verticalSpaceFromWidth,
                AppText(
                  str: '${'入库时间'.ts}：' + (model.inStorageAt ?? ""),
                  fontSize: 13,
                  color: AppColors.textGray,
                ),
              ],
            ),
          ),
          BeeButton(
            text: '认领',
            onPressed: () {
              controller.toDetail(model);
            },
          ),
        ],
      ),
    );
  }
}
