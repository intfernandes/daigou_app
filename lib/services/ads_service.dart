// ignore_for_file: constant_identifier_names

import 'package:shop_app_client/common/http_client.dart';
import 'package:shop_app_client/models/ads_pic_model.dart';

class AdsService {
  // 列表
  static const String LISTAPI = 'ads-picture';

  // 获列表
  static Future<List<BannerModel>> getList(
      [Map<String, dynamic>? params]) async {
    List<BannerModel> result = [];
    await ApiConfig.instance
        .get(LISTAPI, queryParameters: params)
        .then((response) => {
              response.data.forEach((good) {
                result.add(BannerModel.fromJson(good));
              })
            })
        .onError((error, stackTrace) => {});
    return result;
  }
}
