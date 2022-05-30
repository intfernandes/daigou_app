/*
  代理信息
 */
import 'package:jiyun_app_client/common/http_client.dart';
import 'package:jiyun_app_client/models/agent_data_count_model.dart';
import 'package:jiyun_app_client/models/agent_model.dart';
import 'package:jiyun_app_client/models/bank_model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/models/withdrawal_item_model.dart';
import 'package:jiyun_app_client/models/withdrawal_model.dart';
import 'package:jiyun_app_client/services/base_service.dart';
import 'package:flutter/foundation.dart';

class AgentService {
  // 代理信息
  static const String agentProfileApi = 'agent/info';

  // 代理信息统计数据
  static const String agentSubCountApi = 'agent/my-sub-count';

  // 可以提现的订单的列表
  static const String availableWithDrawApi = 'commission/normal-list';

  // 已提现订单列表
  static const String withdrawedApi = 'commission/withdraw-normal-list';

  // 佣金报表列表
  static const String allWithDrawApi = 'balance/apply-commission-list';

  // 提现接口
  static const String agentCommissionWithdrawApi =
      'balance/apply-commission-withdraw';

  // 申请成为代理
  static const String applyAgentApi = 'agent/apply';

  // 推广好友
  static const String agentSubApi = 'agent/my-sub';

  // 银行名称列表
  static const String bankListApi = 'bank';

  // 绑定提现信息
  static const String agentBindApi = 'agent/bind';

  /*
    得到统计信息
   */
  static Future<AgentDataCountModel?> getDataCount() async {
    AgentDataCountModel? result;

    await HttpClient()
        .get(agentSubCountApi, queryParameters: null)
        .then((response) =>
            {result = AgentDataCountModel.fromJson(response.data)})
        .onError((error, stackTrace) => {});

    return result;
  }

  /*
    得到代理信息
    基础信息, 包括二维码，基础信息，银行卡
   */
  static Future<AgentModel?> getProfile() async {
    AgentModel? result;

    await HttpClient().get(agentProfileApi).then((response) {
      if (kDebugMode) {
        print(response);
      }
      var data = response.data;
      result = AgentModel.fromJson(response.data["agent"]);
    });
    return result;
  }

  /*
    申请提现
   */
  static Future<Map> applyWithDraw(Map params) async {
    Map result = {'ok': false, 'msg': ''};

    await HttpClient()
        .post(agentCommissionWithdrawApi, data: params)
        .then((response) => {
              result = {
                'ok': response.ok,
                'msg': response.msg ?? response.error!.message
              }
            })
        .onError((error, stackTrace) => {});

    return result;
  }

  /*
    可以提现的订单的列表
   */
  static Future<Map> getAvailableWithDrawList(
      [Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    List<WithdrawalModel> dataList = <WithdrawalModel>[];

    await HttpClient()
        .get(availableWithDrawApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(WithdrawalModel.fromJson(item));
      });
      result = {
        "dataList": dataList,
        'total': response.data['last_page'],
        'pageIndex': response.data['current_page']
      };
    });
    return result;
  }

  /*
    已提现订单列表
   */
  static Future<Map> getWithdrawedList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    List<WithdrawalModel> dataList = <WithdrawalModel>[];

    await HttpClient()
        .get(withdrawedApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(WithdrawalModel.fromJson(item));
      });
      result = {
        "dataList": dataList,
        'total': response.data['last_page'],
        'pageIndex': response.data['current_page']
      };
    });
    return result;
  }

  /*
    获取佣金报表列表
    包括提现中
   */
  static Future<Map> getCheckoutWithDrawList(
      [Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    List<WithdrawalItemModel> dataList = <WithdrawalItemModel>[];

    await HttpClient()
        .get(allWithDrawApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(WithdrawalItemModel.fromJson(item));
      });
      result = {
        "dataList": dataList,
        'total': response.data['last_page'],
        'pageIndex': response.data['current_page']
      };
    });
    return result;
  }

  /*
    申请成为代理
   */
  static Future<bool> applyAgent([Map<String, dynamic>? params]) async {
    bool result = false;
    await HttpClient()
        .post(applyAgentApi, queryParameters: null)
        .then((response) => {result = response.ret})
        .onError((error, stackTrace) => {});

    return result;
  }

  /* 
    推广好友
   */
  static Future<Map> getSubList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;
    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};
    List<UserModel> dataList = [];
    await HttpClient()
        .get(agentSubApi, queryParameters: params)
        .then((response) {
      var list = response.data;
      list['data']?.forEach((item) {
        dataList.add(UserModel.fromJson(item));
      });
      result = {
        "dataList": dataList,
        'total': response.data['last_page'],
        'pageIndex': response.data['current_page']
      };
    });
    return result;
  }

  /*
    银行列表
   */
  static Future<Map> getBankList([Map<String, dynamic>? params]) async {
    var page = (params is Map) ? params!['page'] : 1;

    Map result = {"dataList": null, 'total': 1, 'pageIndex': page};

    List<BankModel> dataList = <BankModel>[];

    await HttpClient()
        .get(bankListApi, queryParameters: params)
        .then((response) {
      response.data?.forEach((item) {
        dataList.add(BankModel.fromJson(item));
      });
      result = {
        "dataList": dataList,
        'total': response.meta?['last_page'],
        'pageIndex': response.meta?['current_page']
      };
    });

    return result;
  }

  /*
    绑定提现信息
  */
  static Future<void> agentBind(
      Map<String, dynamic> params, OnSuccess onSuccess, OnFail onFail) async {
    await HttpClient().put(agentBindApi, data: params).then((response) {
      if (response.ok) {
        onSuccess(response.msg);
      } else {
        onFail(response.error!.message);
      }
    }).onError((error, stackTrace) => onFail(error.toString()));
  }
}
