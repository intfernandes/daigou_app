import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app_client/config/base_conctroller.dart';
import 'package:shop_app_client/models/order_model.dart';
import 'package:shop_app_client/models/pay_type_model.dart';
import 'package:shop_app_client/models/user_info_model.dart';
import 'package:shop_app_client/models/user_model.dart';
import 'package:shop_app_client/models/user_vip_price_model.dart';
import 'package:shop_app_client/services/balance_service.dart';

class TransferPaymentController extends GlobalController {
  final selectImg = [''].obs;

  UserModel? userModel = Get.find<AppStore>().userInfo.value;

  final isLoading = false.obs;

  // 验证码
  TextEditingController transferAccountController = TextEditingController();
  final FocusNode transferAccountNode = FocusNode();
  FocusNode blankNode = FocusNode();

  // 支付方式数据模型
  final payModel = Rxn<PayTypeModel?>();

  // 会员充值数据模型
  final vipPriceModel = Rxn<UserVipPriceModel?>();

  // 余额充值数据
  final amount = Rxn<double?>();

  // 订单付款数据
  final orderModel = Rxn<OrderModel?>();

  List<int> shopOrderIds = [];

  final isRequest = false.obs;
  final modelType =
      0.obs; // 0-->购买会员  1-->充值余额 2-->集运订单付款 3-->代购订单付款 4-->代购补款订单

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    payModel.value = arguments['payModel'];
    modelType.value = arguments['transferType'];
    if (modelType.value == 0) {
      vipPriceModel.value = arguments['contentModel'];
    } else if (modelType.value == 1) {
      amount.value = arguments['amount'];
    } else if (modelType.value == 2) {
      orderModel.value = arguments['contentModel'];
    } else {
      shopOrderIds = arguments['ids'];
      amount.value = arguments['amount'];
    }
  }

  // 提交
  onSubmit() async {
    if (isRequest.value) return;
    isRequest.value = true;

    List<String> listImg = [];
    for (var item in selectImg) {
      if (item != '') {
        listImg.add(item);
      }
    }
    Map result = {};
    if (modelType.value == 0) {
      // 0会员充值转账
      Map<String, dynamic> upData = {
        'transfer_account': transferAccountController.text,
        'tran_amount': vipPriceModel.value!.price,
        'images': listImg,
        'price_type': vipPriceModel.value!.type,
        'price_id': vipPriceModel.value!.id,
        'payment_id': payModel.value!.id,
      };
      result = await BalanceService.buyVipTransfer(upData);
    } else if (modelType.value == 1) {
      //  1余额充值转账
      Map<String, dynamic> upData = {
        'transfer_account': transferAccountController.text,
        'tran_amount': amount.value! * 100,
        'images': listImg,
        'payment_type_id': payModel.value!.id,
        'trans_currency': currencyModel.value?.code ?? '',
        'trans_rate': currencyModel.value?.rate ?? 1,
      };
      result = await BalanceService.rechargeTransfer(upData);
    } else if (modelType.value == 2) {
      // 2 订单付款转账
      Map<String, dynamic> upData = {
        'order_number': orderModel.value!.orderSn,
        'transfer_account': transferAccountController.text,
        'images': listImg,
        'remark': '',
        'payment_id': payModel.value!.id,
      };
      result = await BalanceService.orderPayTransfer(upData);
    } else {
      // 商城订单
      Map<String, dynamic> upData = {
        'id': modelType.value == 3 ? shopOrderIds : shopOrderIds.first,
        'transfer_account': transferAccountController.text,
        'images': listImg,
        'payment_id': payModel.value!.id,
        'tran_amount': ((amount.value ?? 0) * 100).toInt(),
      };
      if (modelType.value == 3) {
        result = await BalanceService.onShopOrderTransfer(upData);
      } else {
        result = await BalanceService.onProblemOrderTransfer(upData);
      }
    }
    isRequest.value = false;

    if (result['ok']) {
      Get.find<AppStore>().getBaseCountInfo();
      Get
        ..back()
        ..back(result: 'succeed');
    }
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
