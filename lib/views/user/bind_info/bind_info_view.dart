import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/extension/translation.dart';
import 'package:shop_app_client/views/components/button/main_button.dart';
import 'package:shop_app_client/views/components/caption.dart';
import 'package:shop_app_client/views/components/input/input_text_item.dart';
import 'package:shop_app_client/views/components/input/normal_input.dart';
import 'package:shop_app_client/views/user/bind_info/bind_info_controller.dart';

class BeePhonePage extends GetView<BeePhoneLogic> {
  const BeePhonePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.1,
        centerTitle: true,
        title: Obx(
          () => AppText(
            str: controller.flagBool.value == 1
                ? controller.phoneFlag.value
                    ? '更改手机号'.inte
                    : '绑定手机'.inte
                : controller.emailFlag.value
                    ? '更换邮箱'.inte
                    : '绑定邮箱'.inte,
            fontSize: 17,
          ),
        ),
      ),
      backgroundColor: AppStyles.bgGray,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 38.h,
          margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          child: BeeButton(
            text: '确定',
            onPressed: controller.onSubmit,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
            child: Container(
          color: Colors.white,
          child: Obx(
            () => Column(
              children: [
                InputTextItem(
                  margin: const EdgeInsets.only(left: 0),
                  padding: EdgeInsets.only(left: 14.w),
                  title:
                      controller.flagBool.value == 1 ? '联系电话'.inte : '现邮箱'.inte,
                  inputText: Container(
                    height: 55,
                    alignment: Alignment.centerLeft,
                    child: AppText(
                      str: controller.flagBool.value == 1
                          ? controller.userInfo?.phone ?? '无'.inte
                          : controller.userInfo?.email ?? '无'.inte,
                    ),
                  ),
                ),
                InputTextItem(
                  height: 55,
                  margin: const EdgeInsets.only(left: 0),
                  padding: EdgeInsets.only(left: 14.w),
                  title:
                      controller.flagBool.value == 2 ? '新邮箱'.inte : '新号码'.inte,
                  inputText: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        controller.flagBool.value == 1
                            ? GestureDetector(
                                onTap: controller.onTimezone,
                                child: Row(
                                  children: [
                                    AppText(
                                      str: '+' +
                                          controller.formatTimezone(
                                              controller.timezone.value),
                                    ),
                                    AppGaps.hGap4,
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: AppStyles.textNormal,
                                    ),
                                    AppGaps.hGap5,
                                  ],
                                ),
                              )
                            : AppGaps.empty,
                        Expanded(
                            child: NormalInput(
                          hintText: controller.flagBool.value == 2
                              ? '请输入新邮箱'.inte
                              : '请输入新号码'.inte,
                          textAlign: TextAlign.left,
                          contentPadding: const EdgeInsets.only(left: 0),
                          controller: controller.newNumberController,
                          focusNode: controller.newNumber,
                          autoFocus: false,
                          keyboardType: TextInputType.text,
                          onSubmitted: (res) {
                            FocusScope.of(context)
                                .requestFocus(controller.validation);
                          },
                          onChanged: (res) {
                            controller.mobileNumber.value = res;
                          },
                        ))
                      ],
                    ),
                  ),
                ),
                InputTextItem(
                  title: '验证码'.inte,
                  margin: const EdgeInsets.only(left: 0),
                  padding: EdgeInsets.only(left: 14.w),
                  isRequired: true,
                  flag: false,
                  inputText: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: NormalInput(
                          hintText: '请输入验证码'.inte,
                          textAlign: TextAlign.left,
                          contentPadding: const EdgeInsets.only(left: 0),
                          controller: controller.validationController,
                          focusNode: controller.validation,
                          autoFocus: false,
                          keyboardType: TextInputType.text,
                          onChanged: (res) {
                            controller.verifyCode.value = res;
                          },
                        )),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 150.w,
                          ),
                          child: Container(
                            margin:
                                EdgeInsets.only(right: 15.w, top: 8, bottom: 8),
                            child: BeeButton(
                              text: controller.sent.value,
                              backgroundColor: controller.isButtonEnable.value
                                  ? AppStyles.primary
                                  : AppStyles.bgGray,
                              textColor: controller.isButtonEnable.value
                                  ? Colors.white
                                  : Colors.grey,
                              onPressed: controller.onGetCode,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
