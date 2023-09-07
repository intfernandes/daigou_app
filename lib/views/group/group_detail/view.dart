import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:jiyun_app_client/common/fade_route.dart';
import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/extension/translation.dart';
import 'package:jiyun_app_client/models/group_model.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:jiyun_app_client/views/group/group_detail/controller.dart';
import 'package:jiyun_app_client/views/group/widget/countdown_widget.dart';
import 'package:jiyun_app_client/views/group/widget/distance_widget.dart';
import 'package:jiyun_app_client/views/group/widget/group_detail/group_parcel_info.dart';
import 'package:jiyun_app_client/views/group/widget/member_avatar_widget.dart';
import 'package:jiyun_app_client/views/group/widget/triangle_painter.dart';

import '../../components/photo_view_gallery_screen.dart';

class GroupDetailPage extends GetView<GroupDetailController> {
  const GroupDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0.5,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: ZHTextLine(
          str: '拼团详情'.ts,
          fontSize: 18,
        ),
      ),
      backgroundColor: BaseStylesConfig.bgGray,
      bottomNavigationBar: Obx(
        () => controller.model.value?.status == 0
            ? Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: SafeArea(
                  child: Row(
                    children: [
                      !controller.model.value!.isGroupLeader! &&
                              !controller.model.value!.isJoined!
                          ? Expanded(
                              child: SizedBox(
                                height: 50,
                                child: MainButton(
                                  text: '申请加入',
                                  onPressed: () {
                                    controller.onAddGroup(context);
                                  },
                                ),
                              ),
                            )
                          : Sized.empty,
                      controller.model.value!.isDismissible == true
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: SizedBox(
                                  height: 50,
                                  child: MainButton(
                                    text: '取消拼团',
                                    backgroundColor: BaseStylesConfig.primary,
                                    onPressed: () {
                                      controller.onCancelGroup(context);
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Sized.empty,
                      controller.model.value!.isGroupLeader == true
                          ? Expanded(
                              child: SizedBox(
                                height: 50,
                                child: MainButton(
                                  text: '完成并提交拼团',
                                  onPressed: () {
                                    controller.onEndGroup(context);
                                  },
                                ),
                              ),
                            )
                          : Sized.empty,
                      controller.model.value!.canSubmit &&
                              !controller.model.value!.isSubmitted!
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: SizedBox(
                                  height: 50,
                                  child: MainButton(
                                    text: '提交拼团货物',
                                    onPressed: controller.onSubmitParcel,
                                  ),
                                ),
                              ),
                            )
                          : Sized.empty,
                    ],
                  ),
                ),
              )
            : Sized.empty,
      ),
      body: SingleChildScrollView(
        child: Obx(() => controller.model.value != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    leaderInfoCell(context),
                    Sized.vGap10,
                    detailInfoCell(context),
                    Sized.vGap10,
                    groupLineCell(),
                    Sized.vGap10,
                    membersCell(context),
                    controller.model.value!.isJoined!
                        ? MemberGroupParcelInfo(
                            model: controller.model.value!,
                            onChooseParcel: controller.onChooseParcel,
                            localModel: controller.localModel,
                            onHasParcel: () {
                              controller.model.value!.canSubmit = true;
                              controller.model.refresh();
                            },
                          )
                        : Sized.vGap10,
                    Html(data: controller.tipsContent.value ?? ''),
                  ],
                ),
              )
            : Sized.empty),
      ),
    );
  }

  // 团长信息
  Widget leaderInfoCell(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ZHTextLine(
          str: controller.model.value!.name!,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
        Sized.vGap15,
        Row(
          children: [
            Stack(
              children: [
                ClipOval(
                  child: LoadImage(
                    controller.model.value!.members![0].avatar!,
                    width: 50,
                    height: 50,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 5,
                  child: Container(
                    width: 40,
                    alignment: Alignment.center,
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    decoration: BoxDecoration(
                      color: BaseStylesConfig.groupText,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: ZHTextLine(
                      str: '团长'.ts,
                      color: Colors.white,
                      fontSize: 9,
                    ),
                  ),
                ),
              ],
            ),
            Sized.hGap10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ZHTextLine(
                    str: controller.model.value!.leader?.name ?? '',
                    fontSize: 14,
                  ),
                  Sized.vGap5,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const LoadImage(
                            'Group/group-1',
                            width: 20,
                            height: 20,
                          ),
                          Container(
                            height: 20,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: ZHTextLine(
                              str: '认证团长'.ts,
                              color: BaseStylesConfig.groupText,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      controller.model.value!.status == 0 &&
                              controller.model.value!.isGroupLeader!
                          ? GestureDetector(
                              onTap: () {
                                controller.onChangeRemark(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: LoadImage(
                                  'Group/edit',
                                  width: 20,
                                ),
                              ),
                            )
                          : Sized.empty,
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              decoration: BoxDecoration(
                color: BaseStylesConfig.groupText,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ZHTextLine(
                      str: controller.model.value!.remark!.isNotEmpty
                          ? controller.model.value!.remark!
                          : '团长什么都没说'.ts,
                      color: Colors.white,
                      lines: 20,
                    ),
                  ),
                  Sized.hGap15,
                  controller.model.value!.images != null &&
                          controller.model.value!.images!.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(FadeRoute(
                                page: PhotoViewGalleryScreen(
                              images:
                                  controller.model.value!.images!, //传入图片list
                              index: 0, //传入当前点击的图片的index
                              heroTag: '', //传入当前点击的图片的hero tag （可选）
                            )));
                          },
                          child: LoadImage(
                            controller.model.value!.images!.first,
                            width: 100,
                            height: 100,
                          ),
                        )
                      : Sized.empty,
                ],
              ),
            ),
            Positioned(
              top: 1,
              left: 20,
              child: CustomPaint(
                painter: TrianglePainer(
                  strokeColor: BaseStylesConfig.groupText,
                  strokeWidth: 10,
                  paintingStyle: PaintingStyle.fill,
                ),
                child: const SizedBox(
                  width: 10,
                  height: 8,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget groupLineCell() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ZHTextLine(
                str: '拼团发货渠道'.ts,
                fontWeight: FontWeight.bold,
              ),
              GestureDetector(
                onTap: () {
                  Routers.push(Routers.lineDetail, {
                    'id': controller.model.value!.expressLine?.id,
                    'type': 1
                  });
                },
                child: ZHTextLine(
                  str: '查看渠道规则'.ts,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Sized.vGap10,
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ZHTextLine(
                  str: controller.model.value!.warehouseName ?? '',
                ),
                Column(
                  children: [
                    ZHTextLine(
                      str: controller.model.value!.expressLine?.referenceTime ??
                          '',
                      color: BaseStylesConfig.green,
                      fontSize: 12,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: LoadImage(
                        'Group/arrow',
                        format: 'jpg',
                        width: 100,
                      ),
                    ),
                    ZHTextLine(
                      str: controller.model.value!.expressLine?.name ?? '',
                      color: BaseStylesConfig.groupText,
                      fontSize: 12,
                    )
                  ],
                ),
                ZHTextLine(
                  str: controller.model.value!.country ?? '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget detailInfoCell(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ZHTextLine(
                    str: controller.model.value!.code ?? '',
                    fontWeight: FontWeight.bold,
                  ),
                  Sized.hGap5,
                  GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(
                          ClipboardData(text: controller.model.value!.code));
                      controller.showSuccess('复制成功');
                    },
                    child: const Icon(
                      Icons.copy_rounded,
                      color: BaseStylesConfig.green,
                      size: 16,
                    ),
                  ),
                ],
              ),
              ZHTextLine(
                str: Util.getGroupStatusName(controller.model.value!.status!),
                color: controller.model.value!.status == 0
                    ? BaseStylesConfig.groupText
                    : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          infoItemCell(
            '提货地址',
            crossAxisAlignment: CrossAxisAlignment.start,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ZHTextLine(
                  str: controller.model.value!.address!.getContent(),
                  fontSize: 13,
                  lines: 3,
                ),
                controller.coordinate.value != null &&
                        controller.model.value!.coordinate != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ZHTextLine(
                              str: '距离你约'.ts,
                              fontSize: 12,
                              color: BaseStylesConfig.green,
                            ),
                            DistanceWidget(
                              startPosition: controller.coordinate.value!,
                              endPosition: controller.model.value!.coordinate!,
                            ),
                          ],
                        ),
                      )
                    : Sized.empty
              ],
            ),
          ),
          infoItemCell(
            '截团时间',
            crossAxisAlignment: CrossAxisAlignment.start,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ZHTextLine(
                  str: controller.model.value!.endTime ?? '',
                  fontSize: 13,
                ),
                controller.model.value!.status == 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CountdownWidget(
                              total: controller.model.value!.endUntil ?? 0,
                              showSeconds: false,
                              color: BaseStylesConfig.green,
                            ),
                            controller.model.value!.isGroupLeader!
                                ? GestureDetector(
                                    onTap: () {
                                      controller.onDelayDays(context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: const LoadImage(
                                        'Group/edit',
                                        width: 20,
                                      ),
                                    ),
                                  )
                                : Sized.empty,
                          ],
                        ),
                      )
                    : Sized.empty,
              ],
            ),
          ),
          infoItemCell(
            '联系电话',
            content: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ZHTextLine(
                  str: controller.model.value!.address!.phone,
                  fontSize: 13,
                ),
                Sized.hGap10,
                GestureDetector(
                  onTap: () {
                    controller
                        .onContact(controller.model.value!.address!.phone);
                  },
                  child: const Icon(
                    Icons.phone_forwarded_rounded,
                    color: BaseStylesConfig.green,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          infoItemCell('发起时间',
              str: controller.model.value!.createdAt ?? '', showBorder: false),
        ],
      ),
    );
  }

  Widget infoItemCell(
    String label, {
    bool showBorder = true,
    String? str,
    Widget? content,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      decoration: BoxDecoration(
        border: Border(
          bottom: showBorder
              ? const BorderSide(color: BaseStylesConfig.line)
              : BorderSide.none,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          ZHTextLine(
            str: label.ts,
            color: BaseStylesConfig.textGrayC,
            fontSize: 13,
          ),
          Sized.hGap15,
          Flexible(
            child: content ??
                ZHTextLine(
                  str: str!,
                  fontSize: 13,
                  lines: 5,
                ),
          ),
        ],
      ),
    );
  }

  Widget membersCell(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ZHTextLine(
                      str: '成员'.ts +
                          ' (${controller.model.value!.membersCount})',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    controller.model.value!.isGroupLeader!
                        ? GestureDetector(
                            onTap: () {
                              Routers.push(Routers.groupMemberDetail,
                                  {'id': controller.model.value!.id});
                            },
                            child: ZHTextLine(
                              str: '查看参团详情'.ts,
                              fontSize: 13,
                            ),
                          )
                        : Sized.empty,
                  ],
                ),
                Sized.vGap15,
                Sized.line,
                Sized.vGap15,
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.model.value!.membersCount,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: ((context, index) {
                    GroupMemberModel member =
                        controller.model.value!.members![index];
                    return MemberAvatarWidget(
                      member: member,
                      right: -10,
                      leaderFirst: true,
                    );
                  }),
                ),
                Sized.line,
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ZHTextLine(
                        str: '全团已入库'.ts,
                        fontWeight: FontWeight.bold,
                        color: BaseStylesConfig.green,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          weightItemCell(
                              '总入库重量', controller.model.value!.packageWeight!),
                          Sized.vGap5,
                          weightItemCell('总入库体积量',
                              controller.model.value!.packageVolumeWeight!),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          controller.model.value!.isJoined! &&
                  controller.model.value!.status == 0
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: BaseStylesConfig.line),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Expanded(
                      //   child: GestureDetector(
                      //     onTap: onShareWx,
                      //     child: Container(
                      //       color: Colors.transparent,
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         children: [
                      //           const LoadImage(
                      //             'Group/group-4',
                      //             width: 20,
                      //           ),
                      //           Sized.hGap10,
                      //           ZHTextLine(
                      //             str: XLI10n.t(context, '邀请好友参团'),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      controller.model.value!.isExitable!
                          ? Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  controller.onExistGroup(context);
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border(
                                      left: BorderSide(
                                          color: BaseStylesConfig.line),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: ZHTextLine(
                                    str: '退出拼团'.ts,
                                    color: BaseStylesConfig.primary,
                                  ),
                                ),
                              ),
                            )
                          : Sized.empty,
                    ],
                  ),
                )
              : Sized.empty,
        ],
      ),
    );
  }

  Widget weightItemCell(String label, num weight) {
    return Row(
      children: [
        ZHTextLine(
          str: label.ts + '：',
        ),
        ZHTextLine(
          str: (weight / 1000).toStringAsFixed(2) +
              (controller.localModel?.weightSymbol ?? ''),
          color: BaseStylesConfig.textRed,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
