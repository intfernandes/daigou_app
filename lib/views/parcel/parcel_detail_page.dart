/*
  已入库包裹详情
*/

import 'package:jiyun_app_client/common/fade_route.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/goods_props.dart';
import 'package:jiyun_app_client/models/localization_model.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/parcel_goods_model.dart';
import 'package:jiyun_app_client/models/parcel_model.dart';
import 'package:jiyun_app_client/models/warehouse_model.dart';
import 'package:jiyun_app_client/services/parcel_service.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/components/photo_view_gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

/*
  包裹详情
*/

class PackageDetailPage extends StatefulWidget {
  final Map arguments;
  const PackageDetailPage({Key? key, required this.arguments})
      : super(key: key);

  @override
  PackageDetailPageState createState() => PackageDetailPageState();
}

class PackageDetailPageState extends State<PackageDetailPage>
    with SingleTickerProviderStateMixin {
  bool isLoadingLocal = false;

  late ParcelModel parcelModel;
  WareHouseModel? wareHouseModel;
  CountryModel? countryModel;
  GoodsPropsModel? goodsPropsModel;

  late LocalizationModel? localizationInfo;

  String categoriesStr = '';

  bool get wantKeepAlive => true;

  late int parcelId;

  @override
  void initState() {
    super.initState();
    parcelId = widget.arguments['id'];

    created();
  }

  created() async {
    EasyLoading.show();
    var data = await ParcelService.getDetail(parcelId);
    EasyLoading.dismiss();
    if (data != null) {
      setState(() {
        parcelModel = data;
        if (data.categories != null) {
          categoriesStr = data.categories!.map((e) => e.name).join('、');
        }
        isLoadingLocal = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    localizationInfo =
        Provider.of<Model>(context, listen: false).localizationInfo;
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: ZHTextLine(
            str: Translation.t(context, '包裹详情'),
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: ColorConfig.bgGray,
        body: isLoadingLocal
            ? WillPopScope(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[buildTopBox(), buildBottomBox()],
                  ),
                ),
                onWillPop: () async {
                  Navigator.pop(context, parcelModel.packageValue);
                  return false;
                })
            : Container());
  }

  // 商品信息
  Widget buildTopBox() {
    return Container(
      decoration: const BoxDecoration(
        color: ColorConfig.white,
      ),
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            height: 42,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ZHTextLine(
              fontWeight: FontWeight.bold,
              str: Translation.t(context, '商品信息'),
            ),
          ),
          Gaps.line,
          parcelModel.details == null
              ? buildSingleGoods()
              : buildGoodsDetails(),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: ZHTextLine(
                    str: Translation.t(context, '物品属性'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                ZHTextLine(
                  str: parcelModel.prop != null
                      ? parcelModel.prop!.map((e) => e.name).join(' ')
                      : '',
                ),
              ],
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: ZHTextLine(
                    str: Translation.t(context, '商品备注'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      parcelModel.remark ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 没有商品详细清单
  Widget buildSingleGoods() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: ZHTextLine(
                  str: Translation.t(context, '物品名称'),
                  color: ColorConfig.textNormal,
                ),
              ),
              ZHTextLine(
                str: parcelModel.packageName ?? '',
              ),
            ],
          ),
        ),
        Gaps.line,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: ZHTextLine(
                  str: Translation.t(context, '物品总价'),
                  color: ColorConfig.textNormal,
                ),
              ),
              ZHTextLine(
                  str: (parcelModel.packageValue! / 100).toStringAsFixed(2))
            ],
          ),
        ),
        Gaps.line,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          height: 42,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: ZHTextLine(
                  str: Translation.t(context, '物品数量'),
                  color: ColorConfig.textNormal,
                ),
              ),
              ZHTextLine(
                str: parcelModel.qty.toString(),
              )
            ],
          ),
        ),
      ],
    );
  }

  // 商品详细清单
  Widget buildGoodsDetails() {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: ZHTextLine(
                    str: Translation.t(context, '物品名称'),
                    color: ColorConfig.textNormal,
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: ZHTextLine(
                    str: Translation.t(context, '物品价值'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                Expanded(
                  child: ZHTextLine(
                    str: Translation.t(context, '数量'),
                    color: ColorConfig.textNormal,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            itemCount: parcelModel.details!.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return buildGoodsCell(parcelModel.details![i]);
            },
          ),
        ],
      ),
    );
  }

  // 包裹内物品
  Widget buildGoodsCell(ParcelGoodsModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: ColorConfig.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ZHTextLine(
              str: model.name ?? '',
              lines: 3,
            ),
            flex: 2,
          ),
          Expanded(
            child: ZHTextLine(
              str: model.price.toString(),
            ),
          ),
          Expanded(
            child: ZHTextLine(
              str: model.qty.toString(),
            ),
          ),
        ],
      ),
    );
  }

  // 包裹信息
  Widget buildBottomBox() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 42,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ZHTextLine(
              fontWeight: FontWeight.bold,
              str: Translation.t(context, '包裹信息'),
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: ZHTextLine(
                    str: Translation.t(context, '快递名称'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                ZHTextLine(
                  str: parcelModel.expressName ?? '',
                ),
              ],
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: ZHTextLine(
                    str: Translation.t(context, '快递单号'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                Row(
                  children: [
                    ZHTextLine(
                      str: parcelModel.expressNum ?? '',
                    ),
                    Gaps.hGap15,
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: parcelModel.expressNum),
                        ).then((value) {
                          EasyLoading.showSuccess(
                              Translation.t(context, '复制成功'));
                        });
                      },
                      child: ZHTextLine(
                        str: Translation.t(context, '复制'),
                        color: ColorConfig.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 80,
                  child: ZHTextLine(
                    str: Translation.t(context, '发往国家'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                ZHTextLine(
                  str: parcelModel.country != null
                      ? parcelModel.country!.name!
                      : '',
                ),
              ],
            ),
          ),
          Gaps.line,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 80,
                  child: ZHTextLine(
                    str: Translation.t(context, '转运仓库'),
                    color: ColorConfig.textNormal,
                  ),
                ),
                ZHTextLine(
                  str: parcelModel.warehouse != null
                      ? parcelModel.warehouse!.warehouseName!
                      : '',
                ),
              ],
            ),
          ),
          Gaps.line,
          Container(
            constraints: BoxConstraints(
              maxHeight: (parcelModel.packagePictures != null &&
                      parcelModel.packagePictures!.isNotEmpty)
                  ? double.infinity
                  : 40,
            ),
            padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ZHTextLine(
                  str: Translation.t(context, '物品照片'),
                  color: ColorConfig.textNormal,
                ),
                parcelModel.packagePictures != null
                    ? Expanded(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 5.0, //水平子Widget之间间距
                                mainAxisSpacing: 5.0, //垂直子Widget之间间距
                                crossAxisCount: 3, //一行的Widget数量
                              ), // 宽高比例
                              itemCount: parcelModel.packagePictures!.length,
                              itemBuilder: _buildGrideBtnView(
                                  parcelModel.packagePictures!)),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }

  IndexedWidgetBuilder _buildGrideBtnView(List<String> imgList) {
    return (context, index) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(FadeRoute(
              page: PhotoViewGalleryScreen(
            images: imgList, //传入图片list
            index: index, //传入当前点击的图片的index
            heroTag: '', //传入当前点击的图片的hero tag （可选）
          )));
        },
        child: Container(
          color: ColorConfig.white,
          alignment: Alignment.topCenter,
          child: LoadImage(
            imgList[index],
            fit: BoxFit.contain,
            width: 120,
            height: 60,
          ),
        ),
      );
    };
  }
}
