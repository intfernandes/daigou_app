
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/config/routers.dart';
import 'package:shop_app_client/events/application_event.dart';
import 'package:shop_app_client/events/un_authenticate_event.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/models/country_model.dart';
import 'package:shop_app_client/models/express_company_model.dart';
import 'package:shop_app_client/models/goods_props.dart';
import 'package:shop_app_client/models/parcel_model.dart';
import 'package:shop_app_client/models/receiver_address_model.dart';
import 'package:shop_app_client/models/self_pickup_station_model.dart';
import 'package:shop_app_client/models/ship_line_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/models/user_model.dart';
import 'package:shop_app_client/models/value_added_service_model.dart';
import 'package:shop_app_client/models/warehouse_model.dart';
import 'package:shop_app_client/services/common_service.dart';
import 'package:shop_app_client/services/express_company_service.dart';
import 'package:shop_app_client/services/goods_service.dart';
import 'package:shop_app_client/services/parcel_service.dart';
import 'package:shop_app_client/services/warehouse_service.dart';
import 'package:shop_app_client/views/components/base_dialog.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/parcel/widget/batch_forecast.dart';

class BeeParcelCreateLogic extends GlobalController {
  ScrollController scrollController = ScrollController();
  FocusNode blankNode = FocusNode();
  final selectedCountryModel = Rxn<CountryModel?>();
  final selectedWarehouseModel = Rxn<WareHouseModel?>();
  final TextEditingController remarkController = TextEditingController();
  final FocusNode remarkNode = FocusNode();

  //预报的包裹列表
  final formData = <Rx<ParcelModel>>[ParcelModel.initEdit().obs].obs;

  // 协议确认
  final agreementBool = true.obs;
  // 协议条款
  final terms = <String, dynamic>{}.obs;

  //快递公司
  final expressCompanyList = <ExpressCompanyModel>[].obs;
  //商品属性
  List<ParcelPropsModel> goodsPropsList =
      List<ParcelPropsModel>.empty(growable: true);

  final forecastType = 1.obs;
  final addressModel = Rxn<ReceiverAddressModel?>();
  final lineModel = Rxn<ShipLineModel?>();
  final LineServiceId = <num>[].obs;

  //预报服务
  final valueAddedServiceList = <Rx<ValueAddedServiceModel>>[].obs;
  //仓库列表
  List<WareHouseModel> wareHouseList = [];
  // 默认自提点
  SelfPickupStationModel? stationModel;

  UserModel? userModel = Get.find<AppStore>().userInfo.value;


  @override
  void onInit() {
    super.onInit();
    ApplicationEvent.getInstance()
        .event
        .on<UnAuthenticateEvent>()
        .listen((event) {
      showToast('登录凭证已失效');
      GlobalPages.push(GlobalPages.login);
    });
    created();
    loadInitData();
  }

  @override
  onClose() {
    scrollController.dispose();
    blankNode.dispose();
    remarkNode.dispose();
    super.dispose();
  }

  created() async {
    var countryList = await CommonService.getCountryList();
    var _valueAddedServiceList = await ParcelService.getValueAddedServiceList();
    if (countryList.isNotEmpty) {
      valueAddedServiceList.value =
          _valueAddedServiceList.map((e) => Rx(e)).toList();
      selectedCountryModel.value = countryList[0];
      getWarehouseList();
      getProps();
    }
  }


  //加载页面所需要的数据
  loadInitData() async {
    showLoading();
    var _expressCompanyList = await ExpressCompanyService.getList();
    var _terms = await CommonService.getTerms();
    hideLoading();
    expressCompanyList.value = _expressCompanyList;
    if (_terms != null) {
      terms.value = _terms;
      showProtocol(Get.context!);
    }
  }

  // 转运协议
  showProtocol(BuildContext context) {
    BaseDialog.normalDialog(
      context,
      title: terms['title'],
      child: Flexible(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Html(data: terms['content']),
          ),
        ),
      ),
    );
  }

  // 物品属性
  getProps() async {
    var _goodsPropsList = await GoodsService.getPropList(
        {'country_id': selectedCountryModel.value?.id});
    goodsPropsList = _goodsPropsList;
  }

  // 根据国家获取仓库列表
  getWarehouseList() async {
    var data = await WarehouseService.getList(
        {'country_id': selectedCountryModel.value?.id});
    wareHouseList = data;
    selectedWarehouseModel.value = wareHouseList.first;
  }

  // 选择下单方式
  void onForecastType(BuildContext context) async {
    var data = await BaseDialog.showBottomActionSheet<int?>(
      context: context,
      list: [
        {'id': 1, 'name': '集齐再发'.inte},
        {'id': 2, 'name': '到件即发'.inte},
      ],
    );
    if (data != null) {
      forecastType.value = data;
    }
  }


  // 到件即发选择收件地址
  onAddress() async {
    var s = await GlobalPages.push(GlobalPages.addressList, arg: {'select': 1});
    if (s == null) return;

    addressModel.value = s as ReceiverAddressModel;
  }

  // 选择渠道
  onLine() async {
    var propIds = formData.fold<List>([], (pre, cur) {
      (pre).addAll((cur.value.prop ?? []).map((e) => e.id));
      return pre;
    }).toSet();
    if (addressModel.value == null) {
      showToast('请选择收货地址');
      return;
    } else if (propIds.isEmpty) {
      return showToast('请选择一个物品属性');
    }
    Map<String, dynamic> params = {
      'country_id': selectedCountryModel.value?.id,
      'area_id': addressModel.value?.area?.id ?? '',
      'sub_area_id': addressModel.value?.subArea?.id ?? '',
      'warehouse_id': selectedWarehouseModel.value?.id ?? '',
      'props': propIds.toList(),
      'postcode': addressModel.value?.postcode,
    };
    var s = await GlobalPages.push(GlobalPages.lineQueryResult,
        arg: {"data": params});
    if (s == null) return;

    lineModel.value = s as ShipLineModel;
    if ((lineModel.value!.region?.services ?? []).isNotEmpty) {
      LineServiceId.value = lineModel.value!.region!.services!
          .where((e) => e.isForced == 1)
          .map((e) => e.id)
          .toList();
    }
  }

  // 提交预报
  onSubmit() async {
    if (!agreementBool.value) {
      showToast('请同意包裹转运协议');
      return;
    } else if (forecastType.value == 2 && addressModel.value == null) {
      return showToast('请选择收货地址');
    } else if (forecastType.value == 2 && lineModel.value == null) {
      return showToast('请选择运送方式');
    }
    for (var item in formData) {
      if (item.value.expressNum == null) {
        showToast('有包裹没有填写快递单号');
        return;
      }

      // if (item.value.prop == null) {
      //   showToast('有包裹没有选择物品类型');
      //   return;
      // }
    }
    var params = getParcels();
    if (forecastType.value == 2) {
      params.addAll({
        'ship_mode': 2,
        'mode': 3,
        'express_line_id': lineModel.value!.id,
        'address_id': addressModel.value!.id,
        'line_service_ids': LineServiceId,
        'remark': remarkController.text,
      });
    }
    ParcelService.store(params, (data) {
      if (data.ok) {
        // Get.find<AppStore>().getBaseCountInfo();
        GlobalPages.pop();
      }
    }, (message) {});
  }

  // 获取快递公司
  getPickerExpressCompany(List<ExpressCompanyModel> list) {
    List<PickerItem> data = [];
    for (var item in list) {
      var containe = PickerItem(
        text: AppText(
          fontSize: 24,
          str: item.name,
        ),
      );
      data.add(containe);
    }
    return data;
  }

  getPickerWareHouse(List<WareHouseModel> list) {
    List<PickerItem> data = [];
    for (var item in list) {
      var containe = PickerItem(
        text: AppText(
          fontSize: 24,
          str: item.warehouseName!,
        ),
      );
      data.add(containe);
    }
    return data;
  }

  // 选择快递公司
  onPickerExpressName(BuildContext context, int index) {
    Picker(
      adapter: PickerDataAdapter(
          data: expressCompanyList
              .map(
                (e) => PickerItem(
                  text: AppText(
                    fontSize: 24,
                    str: e.name,
                  ),
                ),
              )
              .toList()),
      cancelText: '取消'.inte,
      confirmText: '确认'.inte,
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 12),
      onCancel: () {},
      onConfirm: (Picker picker, List value) {
        formData[index].value.expressId = expressCompanyList[value.first].id;
        formData[index].value.expressName =
            expressCompanyList[value.first].name;
      },
    ).showModal(context);
  }

  // 渠道增值服务备注
  showRemark(String title, String content) {
    BaseDialog.normalDialog(
      Get.context!,
      title: title,
      titleFontSize: 18,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Text(
          content,
        ),
      ),
    );
  }

  Map<String, dynamic> getParcels() {
    List<Map> packageList = [];
    List<int> selectService = [];
    var rate = currencyModel.value?.rate ?? 1;
    for (var item in formData) {
      Map<String, dynamic> dic = {
        'express_num': item.value.expressNum,
        'package_name': item.value.packageName ?? '日用品',
        'package_value': (item.value.packageValue ?? 1) / rate * 100,
        'prop_id': (item.value.prop ?? []).map((e) => e.id).toList(),
        'express_id': item.value.expressId ?? '',
        'qty': item.value.qty,
        'remark': item.value.remark ?? '',
      };
      packageList.add(dic);
    }
    for (var item in valueAddedServiceList) {
      if (item.value.isOpen) {
        selectService.add(item.value.id);
      }
    }
    return {
      'packages': packageList,
      'country_id': selectedCountryModel.value!.id,
      'warehouse_id': selectedWarehouseModel.value!.id,
      'op_service_ids': selectService,
    };
  }

  // 删除包裹
  onDeleteParcel(int index) async {
    blankNode.requestFocus();
    var data = await BaseDialog.confirmDialog(Get.context!, '您确定要删除这个包裹吗'.inte);
    if (data != null) {
      var removeItem = formData.removeAt(index);
      removeItem.value.editControllers!.dispose();
    }
  }

  // 选择仓库
  onPickupWarehouse(BuildContext context) {
    if (selectedCountryModel.value?.id != null) {
      Picker(
        adapter: PickerDataAdapter(data: getPickerWareHouse(wareHouseList)),
        cancelText: '取消'.inte,
        confirmText: '确认'.inte,
        selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 12),
        onCancel: () {},
        onConfirm: (Picker picker, List value) {
          selectedWarehouseModel.value = wareHouseList[value.first];
        },
      ).showModal(context);
    }
  }

  onAdd() {
    print('触发');
    formData.value.add(ParcelModel.initEdit(num: ('').toString()).obs);
    formData.refresh();
  }

  // 批量添加包裹单号
  void onBatchAdd() {
    Get.bottomSheet(
      BatchForecast(onConfirm: (value) {
        formData.value =
            value.map((e) => ParcelModel.initEdit(num: e).obs).toList();
      }),
      isScrollControlled: true,
    );
  }
}
