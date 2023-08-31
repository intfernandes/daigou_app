import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/extension/rate_convert.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/withdrawal_model.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/user/agent/agent_withdraw_detail/controller.dart';

class AgentWithdrawDetailPage extends GetView<AgentWithdrawDetailController> {
  const AgentWithdrawDetailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        title: ZHTextLine(
          str: '结算详情'.ts,
          fontSize: 17,
        ),
        elevation: 0.5,
        backgroundColor: Colors.white,
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildDetailTitle(),
            Sized.vGap15,
            buildCommissionList(),
          ],
        ),
      ),
    );
  }

  Widget buildDetailTitle() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(15),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              child: ZHTextLine(
                fontSize: 22,
                str: (controller.detailModel.value?.amount ?? 0).rate(),
                color: BaseStylesConfig.textRed,
              ),
            ),
            Sized.vGap20,
            ZHTextLine(
              str:
                  '流水号'.ts + '：${controller.detailModel.value?.serialNo ?? ''}',
            ),
            Sized.vGap5,
            ZHTextLine(
              str: '收款方式'.ts +
                  '：${controller.detailModel.value?.withdrawTypeName ?? ''}',
            ),
            Sized.vGap5,
            ZHTextLine(
              str: '收款账户'.ts +
                  '：${controller.detailModel.value?.user?.name ?? ''}',
            ),
            Sized.vGap5,
            ZHTextLine(
              str: '结算状态'.ts +
                  '：' +
                  (controller.detailModel.value?.status == 0
                      ? '审核中'.ts
                      : (controller.detailModel.value?.status == 1
                              ? '审核通过'
                              : '审核拒绝')
                          .ts),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCommissionList() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ZHTextLine(
              str: '结算明细'.ts,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Obx(
            () => ListView.builder(
              shrinkWrap: true,
              itemCount: controller.detailModel.value?.commissions?.length ?? 0,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: buildCommissionItem,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCommissionItem(BuildContext context, int index) {
    WithdrawalModel model = controller.detailModel.value!.commissions![index];
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: BaseStylesConfig.line),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ZHTextLine(
                str: model.createdAt,
                fontSize: 14,
              ),
              ZHTextLine(
                str: model.orderAmount.rate(showPriceSymbol: false) + '元',
                fontSize: 14,
              ),
            ],
          ),
          Sized.vGap5,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ZHTextLine(
                str: '转运单号'.ts + '：' + model.orderNumber,
                fontSize: 14,
              ),
              ZHTextLine(
                str: '佣金'.ts +
                    '：+' +
                    '{count}元'.tsArgs({
                      'count':
                          model.commissionAmount.rate(showPriceSymbol: false)
                    }),
                fontSize: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
