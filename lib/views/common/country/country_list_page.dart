/*

  区号选择、国家
*/

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jiyun_app_client/common/hex_to_color.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/views/common/country/country_controller.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountryListView extends GetView<CountryController> {
  const CountryListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: ZHTextLine(
            str: '选择国家或地区'.ts,
            fontSize: 18,
          ),
          actions: [
            TextButton(
              onPressed: controller.onSearch,
              child: Obx(
                () => ZHTextLine(
                  str: !controller.isSearch.value ? '搜索'.ts : '取消'.ts,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: BaseStylesConfig.bgGray,
        body: Obx(() {
          return controller.isSearch.value
              ? Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(right: 5, left: 5),
                      child: SearchBar(
                        controller: controller.controller,
                        focusNode: controller.focusNode,
                        onSearch: (str) {},
                        onSearchClick: (str) {
                          controller.loadList(str);
                        },
                      ),
                    )
                  ],
                )
              : Stack(
                  children: <Widget>[
                    controller.dataList.isEmpty
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const SizedBox(
                                height: 140,
                                width: 140,
                                child: LoadImage(
                                  '',
                                  fit: BoxFit.contain,
                                  holderImg: "Home/empty",
                                  format: "png",
                                ),
                              ),
                              ZHTextLine(
                                str: '没有匹配的国家'.ts,
                                color: BaseStylesConfig.textGrayC,
                              )
                            ],
                          ))
                        : Padding(
                            padding: const EdgeInsets.only(left: 0, right: 0),
                            child: ListView.builder(
                                controller: controller.scrollController,
                                itemCount: controller.dataList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  List<CountryModel> cellList =
                                      controller.dataList[index].items;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      phoneCodeIndexName(
                                          context,
                                          index,
                                          controller.dataList[index].letter
                                              .toUpperCase()),
                                      ListView.builder(
                                          itemBuilder: (BuildContext context,
                                              int index2) {
                                            return GestureDetector(
                                              child: Container(
                                                color: BaseStylesConfig.white,
                                                padding: const EdgeInsets.only(
                                                    left: 15),
                                                height: 46,
                                                width:
                                                    ScreenUtil().screenWidth -
                                                        50,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: Row(
                                                    children: <Widget>[
                                                      ZHTextLine(
                                                        str: cellList[index2]
                                                            .timezone!,
                                                      ),
                                                      Sized.hGap10,
                                                      ZHTextLine(
                                                        str: cellList[index2]
                                                            .name!,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                CountryModel model =
                                                    cellList[index2];
                                                controller
                                                    .onCountrySelect(model);
                                              },
                                            );
                                          },
                                          itemCount: cellList.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics()) //禁用滑动事件),
                                    ],
                                  );
                                }),
                          ),
                    Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        left: ScreenUtil().screenWidth - 50,
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.transparent,
                          height: ScreenUtil().screenHeight,
                          width: 50,
                          child: Container(
                            color: Colors.transparent,
                            width: 30,
                            height: double.parse(
                                (35 * controller.dataList.length).toString()),
                            child: ListView.builder(
                              itemCount: controller.dataList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: Container(
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      height: 35,
                                      width: 50,
                                      child: ZHTextLine(
                                        str: controller.dataList[index].letter,
                                        color: BaseStylesConfig.main,
                                      )),
                                  onTap: () {
                                    var height = index * 25.0;
                                    for (int i = 0; i < index; i++) {
                                      height +=
                                          controller.dataList[i].items.length *
                                              46.0;
                                    }
                                    controller.scrollController.jumpTo(height);
                                  },
                                );
                              },
                            ),
                          ),
                        )),
                  ],
                );
        }));
  }

  Widget phoneCodeIndexName(BuildContext context, int index, String indexName) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 15),
      width: MediaQuery.of(context).size.width,
      height: 25,
      color: HexToColor('#F5F5F5'),
      child: ZHTextLine(
        str: indexName,
      ),
    );
  }
}
