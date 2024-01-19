// ignore_for_file: constant_identifier_names

import 'package:huanting_shop/common/http_client.dart';
import 'package:flutter/material.dart';
import 'package:huanting_shop/models/warehouse_model.dart';

class WarehouseService extends ChangeNotifier {
  // 获取包裹的仓库数据
  static const String LISTAPI = 'warehouse-address/get-list';
  // 获取一个默认仓库
  static const String defaultApi = 'warehouse-address';

  static const String simpleListApi = 'warehouse-address/simple-list';

  // 获取仓库列表
  static Future<List<WareHouseModel>> getList(
      [Map<String, dynamic>? params]) async {
    List<WareHouseModel> result = [];
    await BeeRequest.instance
        .get(LISTAPI, queryParameters: params)
        .then((response) => {
              response.data.forEach((good) {
                result.add(WareHouseModel.fromJson(good));
              })
            })
        .onError((error, stackTrace) => {});
    return result;
  }

  // 获取仓库列表
  static Future<List<WareHouseModel>> getSimpleList(
      [Map<String, dynamic>? params]) async {
    List<WareHouseModel> result = [];
    await BeeRequest.instance
        .get(simpleListApi, queryParameters: params)
        .then((response) => {
              response.data.forEach((good) {
                result.add(WareHouseModel.fromJson(good));
              })
            })
        .onError((error, stackTrace) => {});
    return result;
  }

  // 获取某个国家的仓库列表
  static Future<WareHouseModel?> getDefaultWarehouse() async {
    WareHouseModel? result;
    await BeeRequest.instance
        .get(defaultApi)
        .then((response) => {
              if (response.ok && response.data != null)
                {result = WareHouseModel.fromJson(response.data)}
            })
        .onError((error, stackTrace) => {});
    return result;
  }
}
