import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/services/balance_service.dart';

class RechargeHistoryController extends GlobalController {
  RechargeHistoryController();

  int pageIndex = 0;

  loadList({type}) async {
    pageIndex = 0;
    return await loadMoreList();
  }

  loadMoreList() async {
    Map<String, dynamic> dic = {
      "page": (++pageIndex),
    };
    var data = await BalanceService.getRechargeList(dic);
    return data;
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
