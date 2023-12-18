import 'package:get/state_manager.dart';
import 'package:jiyun_app_client/config/base_conctroller.dart';
import 'package:jiyun_app_client/services/station_service.dart';

class StationController extends GlobalLogic {
  final pageIndex = 0.obs;

  loadList({type}) async {
    pageIndex.value = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {
      'page': (++pageIndex.value),
    };
    var data = await StationService.getList(dic);
    return data;
  }
}