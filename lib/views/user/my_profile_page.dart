/*
  个人信息
*/

import 'package:flutter/cupertino.dart';
import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/common/upload_util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/config/routers.dart';
import 'package:jiyun_app_client/models/model.dart';
import 'package:jiyun_app_client/models/user_model.dart';
import 'package:jiyun_app_client/services/user_service.dart';
import 'package:jiyun_app_client/storage/user_storage.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:jiyun_app_client/views/components/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  MyProfilePageState createState() => MyProfilePageState();
}

class MyProfilePageState extends State<MyProfilePage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final textEditingController = TextEditingController();
  String userImg = '';

  bool isloading = false;
  UserModel? userModel;

  // 用户名
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameNode = FocusNode();
  // 微信号
  final TextEditingController _weChatNumberController = TextEditingController();
  final FocusNode _weChatNumber = FocusNode();
  // 城市
  final TextEditingController _cityNameController = TextEditingController();
  final FocusNode _cityName = FocusNode();

  FocusNode blankNode = FocusNode();

  @override
  void initState() {
    super.initState();
    created();
  }

  created() async {
    EasyLoading.show();
    userModel = await UserService.getProfile();
    EasyLoading.dismiss();
    setState(() {
      _cityNameController.text = userModel!.liveCity;
      _weChatNumberController.text = userModel!.wechatId;
      _nameController.text = userModel!.name;
      isloading = true;
    });
  }

  // 更改个人信息
  onSubmit() async {
    Map<String, dynamic> upData = {
      'name': userModel!.name,
      'avatar': userImg.isEmpty ? userModel!.avatar : userImg,
      'gender': userModel!.gender, // 性别
      'wechat_id': userModel!.wechatId, // 微信
      'birth': userModel!.birth ?? '', // 生日
      'live_city': userModel!.liveCity, // 当前城市
    };
    EasyLoading.show();
    var result = await UserService.updateByModel(upData);
    EasyLoading.dismiss();
    if (result['ok']) {
      Provider.of<Model>(context, listen: false).setUserInfo(result['data']);
      await UserStorage.setUserInfo(result['data']);
      EasyLoading.showSuccess(result['msg']);
      Routers.pop(context);
    } else {
      EasyLoading.showToast(result['msg']);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
          title: Caption(
            str: Translation.t(context, '个人信息'),
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: ColorConfig.bgGray,
        body: isloading
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      buildCustomViews(context),
                      Container(
                        height: 50,
                        color: ColorConfig.white,
                      ),
                      Gaps.line,
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          color: ColorConfig.white,
                          height: 55,
                          padding: const EdgeInsets.only(left: 10, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    color: ColorConfig.white,
                                    height: 55,
                                    width: 90,
                                    alignment: Alignment.centerLeft,
                                    child: Caption(
                                      str: Translation.t(context, '用户昵称'),
                                    ),
                                  ),
                                  Container(
                                    color: ColorConfig.white,
                                    height: 55,
                                    width: ScreenUtil().screenWidth - 25 - 100,
                                    alignment: Alignment.centerLeft,
                                    child: NormalInput(
                                      hintText: Translation.t(context, '请输入昵称'),
                                      textAlign: TextAlign.left,
                                      contentPadding: const EdgeInsets.only(
                                          top: 17, bottom: 0),
                                      controller: _nameController,
                                      focusNode: _nameNode,
                                      autoFocus: false,
                                      keyboardType: TextInputType.text,
                                      onSubmitted: (res) {
                                        FocusScope.of(context)
                                            .requestFocus(_weChatNumber);
                                      },
                                      onChanged: (res) {
                                        userModel!.name = res;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gaps.line,
                      Container(
                        color: ColorConfig.white,
                        height: 55,
                        padding: const EdgeInsets.only(left: 10, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  color: ColorConfig.white,
                                  height: 55,
                                  width: 90,
                                  alignment: Alignment.centerLeft,
                                  child: Caption(
                                    str: Translation.t(context, '用户ID'),
                                  ),
                                ),
                                Caption(
                                  str: userModel!.id.toString(),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Gaps.line,
                      GestureDetector(
                        onTap: () {
                          showPickerModal(context);
                        },
                        child: Container(
                          color: ColorConfig.white,
                          height: 55,
                          padding: const EdgeInsets.only(left: 10, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    color: ColorConfig.white,
                                    height: 55,
                                    width: 90,
                                    alignment: Alignment.centerLeft,
                                    child: Caption(
                                      str: Translation.t(
                                          context, '性别'), // 1 男  2 女
                                    ),
                                  ),
                                  Caption(
                                    str: userModel!.gender == null
                                        ? Translation.t(context, '请选择性别')
                                        : userModel!.gender == 1
                                            ? Translation.t(context, '男')
                                            : Translation.t(context, '女'),
                                    color: userModel!.gender == null
                                        ? ColorConfig.textGray
                                        : ColorConfig.textDark,
                                  )
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios,
                                color: ColorConfig.textGrayC,
                                size: 18,
                              )
                            ],
                          ),
                        ),
                      ),
                      // Gaps.line,
                      // GestureDetector(
                      //   onTap: () {
                      //     Routers.push(
                      //         '/ChangeMobileEmailPage', context, {'type': 1});
                      //   },
                      //   child: Container(
                      //     color: ColorConfig.white,
                      //     height: 55,
                      //     padding: const EdgeInsets.only(left: 10, right: 15),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: <Widget>[
                      //         Row(
                      //           children: <Widget>[
                      //             Container(
                      //               color: ColorConfig.white,
                      //               height: 55,
                      //               width: 90,
                      //               alignment: Alignment.centerLeft,
                      //               child: Caption(
                      //                 str: Translation.t(context, '手机号码'),
                      //               ),
                      //             ),
                      //             Caption(
                      //               str: userModel!.phone == null ||
                      //                       userModel!.phone!.isEmpty
                      //                   ? Translation.t(context, '绑定手机号')
                      //                   : userModel!.phone!,
                      //               color: userModel!.email == null ||
                      //                       userModel!.email!.isEmpty
                      //                   ? ColorConfig.textGray
                      //                   : ColorConfig.textDark,
                      //             ),
                      //           ],
                      //         ),
                      //         userModel!.phone == null ||
                      //                 userModel!.phone!.isEmpty
                      //             ? const Icon(
                      //                 Icons.arrow_forward_ios,
                      //                 color: ColorConfig.textGrayC,
                      //                 size: 18,
                      //               )
                      //             : Caption(
                      //                 str: Translation.t(context, '更改手机号'),
                      //                 color: ColorConfig.primary,
                      //               )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Gaps.line,
                      GestureDetector(
                        onTap: () {
                          Routers.push(
                              '/ChangeMobileEmailPage', context, {'type': 2});
                        },
                        child: Container(
                          color: ColorConfig.white,
                          height: 55,
                          padding: const EdgeInsets.only(left: 10, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    color: ColorConfig.white,
                                    height: 55,
                                    width: 90,
                                    alignment: Alignment.centerLeft,
                                    child: Caption(
                                      str: Translation.t(context, '电子邮箱'),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    height: 55,
                                    child: Caption(
                                      // fontSize: 14,
                                      lines: 2,
                                      str: userModel!.email == null ||
                                              userModel!.email!.isEmpty
                                          ? Translation.t(context, '绑定电子邮箱')
                                          : userModel!.email!,
                                      color: userModel!.email == null ||
                                              userModel!.email!.isEmpty
                                          ? ColorConfig.textGray
                                          : ColorConfig.textDark,
                                    ),
                                  )
                                ],
                              ),
                              userModel!.email == null ||
                                      userModel!.email!.isEmpty
                                  ? const Icon(
                                      Icons.arrow_forward_ios,
                                      color: ColorConfig.textGrayC,
                                      size: 18,
                                    )
                                  : Caption(
                                      str: Translation.t(context, '更改邮箱'),
                                      color: ColorConfig.primary,
                                    )
                            ],
                          ),
                        ),
                      ),
                      Gaps.line,
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: Container(
                      //     color: ColorConfig.white,
                      //     height: 55,
                      //     padding: const EdgeInsets.only(left: 10, right: 15),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: <Widget>[
                      //         Row(
                      //           children: <Widget>[
                      //             Container(
                      //               color: ColorConfig.white,
                      //               height: 55,
                      //               width: 90,
                      //               alignment: Alignment.centerLeft,
                      //               child: const Caption(
                      //                 str: '微信号',
                      //               ),
                      //             ),
                      //             Container(
                      //                 color: ColorConfig.white,
                      //                 height: 55,
                      //                 width: 200,
                      //                 alignment: Alignment.centerLeft,
                      //                 child: NormalInput(
                      //                   hintText: "请输入您的微信号",
                      //                   textAlign: TextAlign.left,
                      //                   contentPadding: const EdgeInsets.only(
                      //                       top: 17, bottom: 0),
                      //                   controller: _weChatNumberController,
                      //                   focusNode: _weChatNumber,
                      //                   autoFocus: false,
                      //                   keyboardType: TextInputType.text,
                      //                   onSubmitted: (res) {
                      //                     FocusScope.of(context)
                      //                         .requestFocus(_cityName);
                      //                   },
                      //                   onChanged: (res) {
                      //                     userModel!.wechatId = res;
                      //                   },
                      //                 )),
                      //           ],
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Gaps.line,
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          color: ColorConfig.white,
                          height: 55,
                          padding: const EdgeInsets.only(left: 10, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    color: ColorConfig.white,
                                    height: 55,
                                    width: 90,
                                    alignment: Alignment.centerLeft,
                                    child: Caption(
                                      str: Translation.t(context, '现居城市'),
                                    ),
                                  ),
                                  Container(
                                    color: ColorConfig.white,
                                    height: 55,
                                    width: 200,
                                    alignment: Alignment.centerLeft,
                                    child: NormalInput(
                                      hintText:
                                          Translation.t(context, '请输入现居城市'),
                                      textAlign: TextAlign.left,
                                      contentPadding: const EdgeInsets.only(
                                          top: 19, bottom: 0),
                                      controller: _cityNameController,
                                      focusNode: _cityName,
                                      autoFocus: false,
                                      keyboardType: TextInputType.text,
                                      onSubmitted: (res) {
                                        FocusScope.of(context)
                                            .requestFocus(blankNode);
                                      },
                                      onChanged: (res) {
                                        userModel!.liveCity = res;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gaps.line,
                      Gaps.vGap20,
                      SizedBox(
                        width: ScreenUtil().screenWidth - 30,
                        height: 40,
                        child: MainButton(
                          text: '确认',
                          onPressed: onSubmit,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container());
  }

  showPickerModal(BuildContext context) {
    Picker(
        adapter: PickerDataAdapter<String>(pickerdata: [
          Translation.t(context, '男'),
          Translation.t(context, '女')
        ]),
        changeToFirst: true,
        hideHeader: false,
        cancelText: Translation.t(context, '取消'),
        confirmText: Translation.t(context, '确认'),
        onConfirm: (Picker picker, List value) {
          setState(() {
            if (value.first == 0) {
              userModel!.gender = 1;
            } else {
              userModel!.gender = 2;
            }
          });
        }).showModal(this.context); //_scaffoldKey.currentState);
  }

  Widget buildCustomViews(BuildContext context) {
    var headerView = Container(
        padding: const EdgeInsets.only(left: 15, top: 50, right: 15),
        color: ColorConfig.white,
        constraints: const BoxConstraints.expand(
          height: 150.0,
        ),
        //设置背景图片
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    onTap: () async {
                      UploadUtil.imagePicker(
                        onSuccessCallback: (imageUrl) async {
                          setState(() {
                            userImg = imageUrl;
                          });
                        },
                        context: context,
                        child: CupertinoActionSheet(
                          title: Text(Translation.t(context, '请选择上传方式')),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: Text(Translation.t(context, '相册')),
                              onPressed: () {
                                Navigator.pop(context, 'gallery');
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: Text(Translation.t(context, '照相机')),
                              onPressed: () {
                                Navigator.pop(context, 'camera');
                              },
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: Text(Translation.t(context, '取消')),
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                        decoration: const BoxDecoration(
                          color: ColorConfig.white,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        height: 100,
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: LoadImage(
                            userImg.isEmpty ? userModel!.avatar : userImg,
                            fit: BoxFit.fitWidth,
                            holderImg: "AboutMe/about-logo",
                            format: "png",
                          ),
                        ))),
              ],
            ),
          ],
        ));
    return headerView;
  }

  @override
  bool get wantKeepAlive => true;
}
