import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/models/country_model.dart';
import 'package:shop_app_client/models/goods_category_model.dart';
import 'package:shop_app_client/models/warehouse_model.dart';
import 'package:shop_app_client/services/warehouse_service.dart';
import 'package:shop_app_client/views/components/caption.dart';

class LineQueryController extends GlobalController {
  final TextEditingController weightController = TextEditingController();
  final FocusNode weightNode = FocusNode();
  final TextEditingController longController = TextEditingController();
  final FocusNode longNode = FocusNode();
  final TextEditingController wideController = TextEditingController();
  final FocusNode wideNode = FocusNode();
  final TextEditingController highController = TextEditingController();
  final FocusNode highNode = FocusNode();
  // final selectPropList = RxList<ParcelPropsModel>();
  // final propList = RxList<ParcelPropsModel>();
  final list = RxList<WareHouseModel>();
  final selectCountry = Rxn<CountryModel?>();
  final selectWareHouse = Rxn<WareHouseModel?>();
  final category = Rxn<GoodsCategoryModel?>();

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  @override
  void onClose() {
    weightNode.dispose();
    longNode.dispose();
    wideNode.dispose();
    highNode.dispose();
    super.onClose();
  }

  void initData() async {
    showLoading();
    var data = await WarehouseService.getList();

    hideLoading();
    list.value = data;
    if (list.isNotEmpty) {
      selectWareHouse.value = list.first;
      if (selectWareHouse.value!.countries!.isNotEmpty) {
        selectCountry.value = selectWareHouse.value!.countries!.first;
      }
    }
    // getProps();
  }

  // getProps() async {
  //   var propData = await GoodsService.getPropList({
  //     'country_id': selectCountry.value?.id,
  //   });
  //   propList.value = propData;
  // }

  // 选择国家
  onCountry() async {
    var s = await GlobalPages.push(GlobalPages.country,
        arg: {'warehouseId': selectWareHouse.value!.id, 'showArea': 1});
    if (s == null) return;
    if (s is Map) {
      selectCountry.value = s['country'];
    } else {
      selectCountry.value = (s as CountryModel);
    }
    // selectPropList.clear();
    // getProps();
  }

  // 重量加减
  onWeight(int step) {
    num weight =
        weightController.text.isEmpty ? 0 : num.parse(weightController.text);
    weight += step;
    weightController.text = weight <= 0 ? '0' : '$weight';
  }

  // 选择属性
  // onProps(ParcelPropsModel prop) {
  //   int index = selectPropList.indexWhere((e) => e.id == prop.id);
  //   if (index != -1) {
  //     selectPropList.removeAt(index);
  //   } else {
  //     selectPropList.add(prop);
  //   }
  // }

  getWarehousePicker() {
    return list
        .map(
          (e) => PickerItem(
            text: AppText(
              fontSize: 24,
              str: e.warehouseName ?? '',
            ),
          ),
        )
        .toList();
  }

  void onSubmit() {
    if (weightController.text.isEmpty) {
      showToast('请输入重量');
      return;
    } else if (category.value == null) {
      showToast('请选择物品分类');
      return;
    }

    Map<String, dynamic> dic = {
      'country_id': selectCountry.value?.id ?? '',
      'countryName': selectCountry.value?.name,
      'length': longController.text,
      'width': wideController.text,
      'height': highController.text,
      'weight': num.parse(weightController.text) * 1000,
      'props': (category.value!.props ?? []).map((e) => e.id).toList(),
      'propList': category.value!.props ?? [],
      'warehouse_id': selectWareHouse.value?.id ?? '',
      'warehouseName': selectWareHouse.value?.warehouseName ?? '',
    };
    GlobalPages.push(GlobalPages.lineQueryResult,
        arg: {"data": dic, "query": true});
  }
}
