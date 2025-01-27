import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/models/ship_line_model.dart';
import 'package:shop_app_client/services/ship_line_service.dart';

class LineQueryResultController extends GlobalController {
  final lineData = RxList<ShipLineModel>();
  final postDic = Rxn<Map<String, dynamic>?>();
  final isEmpty = false.obs;
  final emptyMsg = ''.obs;
  final volumnWeight = Rxn<String?>();
  final fromQuery = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 获取路由参数
    var arguments = Get.arguments;
    postDic.value = arguments?['data'];
    if (arguments?['query'] != null) {
      fromQuery.value = true;
      double length = arguments?['data']['length'].isNotEmpty
          ? double.parse(arguments?['data']['length'])
          : 0;
      double width = arguments?['data']['width'].isNotEmpty
          ? double.parse(arguments?['data']['width'])
          : 0;
      double height = arguments?['data']['height'].isNotEmpty
          ? double.parse(arguments?['data']['height'])
          : 0;
      volumnWeight.value = ((length * width * height) / 1000000).toString();
    }
    getLines();
  }

  getLines() async {
    var params = {
      'country_id': postDic.value?['country_id'] ?? '',
      'area_id': postDic.value?['area_id'],
      'sub_area_id': postDic.value?['sub_area_id'],
      'warehouse_id': postDic.value?['warehouse_id'] ?? '',
      'prop_ids': (postDic.value?['props'] ?? []),
    };
    if (postDic.value?['weight'] != null) {
      params['weight'] = postDic.value?['weight'] ?? '';
    }
    if (postDic.value?['length'] != null) {
      params['length'] = postDic.value?['length'] ?? '';
    }
    if (postDic.value?['width'] != null) {
      params['width'] = postDic.value?['width'] ?? '';
    }
    if (postDic.value?['height'] != null) {
      params['height'] = postDic.value?['height'] ?? '';
    }
    // if (postDic.value?['is_delivery'] != null) {
    //   params['is_delivery'] = postDic.value?['is_delivery'] ?? '';
    // }
    if (postDic.value?['station_id'] != null) {
      params['station_id'] = postDic.value?['station_id'] ?? '';
    }
    if (postDic.value?['package_ids'] != null) {
      params['package_ids'] = postDic.value?['package_ids'] ?? '';
    }
    Map result = await ShipLineService.getList(params: params);
    lineData.value = result['list'];
    if (!result['ok']) {
      isEmpty.value = true;
      emptyMsg.value = result['msg'];
    }
  }
}
