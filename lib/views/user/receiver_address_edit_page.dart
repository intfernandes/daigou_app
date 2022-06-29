/*
  收件地址编辑
 */

import 'package:jiyun_app_client/common/util.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/events/application_event.dart';
import 'package:jiyun_app_client/events/receiver_address_refresh_event.dart';
import 'package:jiyun_app_client/models/alphabetical_country_model.dart';
import 'package:jiyun_app_client/models/area_model.dart';
import 'package:jiyun_app_client/models/country_model.dart';
import 'package:jiyun_app_client/models/receiver_address_model.dart';
import 'package:jiyun_app_client/services/address_service.dart';
import 'package:jiyun_app_client/services/common_service.dart';
import 'package:jiyun_app_client/views/components/base_dialog.dart';
import 'package:jiyun_app_client/views/components/button/main_button.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:jiyun_app_client/views/components/input/input_text_item.dart';
import 'package:jiyun_app_client/views/components/input/normal_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';

class ReceiverAddressEditPage extends StatefulWidget {
  final Map? arguments;
  const ReceiverAddressEditPage({Key? key, this.arguments}) : super(key: key);

  @override
  ReceiverAddressEditPageState createState() => ReceiverAddressEditPageState();
}

class ReceiverAddressEditPageState extends State<ReceiverAddressEditPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final textEditingController = TextEditingController();

  // 收件人
  final TextEditingController _recipientNameController =
      TextEditingController();
  final FocusNode _recipientName = FocusNode();
  // 联系电话
  final TextEditingController _mobileNumberController = TextEditingController();
  final FocusNode _mobileNumber = FocusNode();
  // 邮编
  final TextEditingController _zipCodeController = TextEditingController();
  final FocusNode _zipCode = FocusNode();

  // 详细地址
  final TextEditingController _streetNameController = TextEditingController();
  final FocusNode _streetName = FocusNode();

  FocusNode blankNode = FocusNode();

  ReceiverAddressModel model = ReceiverAddressModel.empty();
  bool isEdit = false;

  CountryModel countryModel = CountryModel();
  AreaModel? areaModel;
  AreaModel? subAreaModel;

  @override
  void initState() {
    super.initState();

    setState(() {
      //如果是编辑
      if (widget.arguments?['isEdit'] == '1') {
        isEdit = true;
        model = widget.arguments?['address'] as ReceiverAddressModel;
        _recipientNameController.text = model.receiverName;
        _mobileNumberController.text = model.phone;
        _zipCodeController.text = model.postcode;
        if (model.area != null) {
          areaModel = model.area;
          if (model.subArea != null) {
            subAreaModel = model.subArea;
          }
        }
        _streetNameController.text = model.address ?? '';
      } else {
        model.phone = '';
        model.receiverName = '';
        model.timezone = '';
        model.city = '';
        model.countryId = 999;
        model.address = '';
        model.postcode = '';
        model.doorNo = '';
      }
    });
    if (isEdit) {
      getCountryData();
    }
  }

  /*
    得到国家数据
   */
  getCountryData() async {
    List<AlphabeticalCountryModel> alphaListModel =
        await CommonService.getCountryListByAlphabetical();

    for (AlphabeticalCountryModel alphaModel in alphaListModel) {
      for (CountryModel cmodel in alphaModel.items) {
        if (cmodel.id == model.country!.id) {
          setState(() {
            countryModel = cmodel;
          });
        }
      }
    }
  }

  onDelete() async {
    bool? data = await onDeleteAlter();
    if (data != null) {
      EasyLoading.show();
      var result = await AddressService.deleteReciever(model.id!);
      EasyLoading.dismiss();
      if (result) {
        EasyLoading.showSuccess('删除成功').then((value) {
          ApplicationEvent.getInstance()
              .event
              .fire(ReceiverAddressRefreshEvent());
          Navigator.pop(context);
        });
      } else {
        EasyLoading.showError('删除失败');
      }
    }
  }

  // 删除地址
  Future<bool?> onDeleteAlter() {
    return BaseDialog.confirmDialog(context, '确认要删除地址吗');
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
            str: !isEdit ? '添加地址' : '修改地址',
            color: ColorConfig.textBlack,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: ColorConfig.bgGray,
        bottomNavigationBar: SafeArea(
            child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                height: isEdit ? 110 : 50,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin:
                          const EdgeInsets.only(right: 15, left: 15, top: 10),
                      height: 40,
                      width: double.infinity,
                      child: MainButton(
                        text: '确认提交',
                        onPressed: onUpdateClick,
                      ),
                    ),
                    isEdit
                        ? Container(
                            margin: const EdgeInsets.only(
                                right: 15, left: 15, top: 10),
                            width: double.infinity,
                            height: 40,
                            child: MainButton(
                              text: '删除',
                              backgroundColor: Colors.white,
                              onPressed: onDelete,
                              textColor: ColorConfig.textRed,
                            ),
                          )
                        : Container(),
                  ],
                ))),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: buildAddressContent(),
          ),
        ));
  }

  Widget buildAddressContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputTextItem(
          title: "收件人",
          inputText: NormalInput(
            hintText: "请输入收件人名字",
            textAlign: TextAlign.right,
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
            controller: _recipientNameController,
            focusNode: _recipientName,
            maxLength: 40,
            onSubmitted: (res) {
              FocusScope.of(context).requestFocus(_mobileNumber);
            },
            onChanged: (res) {
              model.receiverName = res;
            },
          ),
        ),
        GestureDetector(
          onTap: () async {
            var s = await Navigator.pushNamed(context, '/CountryListPage');
            if (s == null) return;
            CountryModel a = s as CountryModel;
            setState(() {
              model.timezone = a.timezone!;
            });
          },
          child: InputTextItem(
            title: "电话区号",
            inputText: Container(
              padding: const EdgeInsets.only(right: 15, left: 0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Caption(
                    str: model.timezone.isEmpty ? "请选择电话区号" : model.timezone,
                    color: model.timezone.isEmpty
                        ? ColorConfig.textGray
                        : ColorConfig.textDark,
                    fontSize: 14,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: ColorConfig.textGray,
                  ),
                ],
              ),
            ),
          ),
        ),
        InputTextItem(
          title: "联系电话",
          inputText: NormalInput(
            hintText: "请输入收件人电话",
            textAlign: TextAlign.right,
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
            maxLength: 20,
            controller: _mobileNumberController,
            focusNode: _mobileNumber,
            keyboardType: TextInputType.phone,
            onSubmitted: (res) {
              FocusScope.of(context).requestFocus(_zipCode);
            },
            onChanged: (res) {
              model.phone = res;
            },
          ),
        ),
        GestureDetector(
          onTap: () async {
            var s = await Navigator.pushNamed(context, '/CountryListPage');
            if (s == null) {
              return;
            }
            CountryModel a = s as CountryModel;

            setState(() {
              countryModel = a;
              areaModel = null;
              subAreaModel = null;
            });
          },
          child: InputTextItem(
            title: "国家",
            inputText: Container(
              padding: const EdgeInsets.only(right: 15, left: 0),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Caption(
                    str: countryModel.name == null
                        ? '请选择国家/地区'
                        : countryModel.name!,
                    color: countryModel.name == null
                        ? ColorConfig.textGray
                        : ColorConfig.textDark,
                    fontSize: 14,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: ColorConfig.textGray,
                  ),
                ],
              ),
            ),
          ),
        ),
        InputTextItem(
          title: "邮编",
          inputText: NormalInput(
            hintText: "请输入邮编",
            contentPadding: const EdgeInsets.only(top: 17, right: 15),
            textAlign: TextAlign.right,
            controller: _zipCodeController,
            focusNode: _zipCode,
            maxLength: 20,
            onSubmitted: (res) {
              FocusScope.of(context).requestFocus(_streetName);
            },
            onChanged: (res) {
              model.postcode = res;
            },
          ),
        ),
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Caption(
                str: '详细地址',
              ),
              NormalInput(
                controller: _streetNameController,
                focusNode: _streetName,
                maxLength: 300,
                hintText: '请输入详细地址',
                maxLines: 10,
                contentPadding: const EdgeInsets.only(top: 10),
                onChanged: (res) {
                  model.address = res;
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  onUpdateClick() async {
    if (model.receiverName == '') {
      Util.showToast('请填写收货人');
      return;
    }

    if (model.timezone == '') {
      Util.showToast('请选择区号');
      return;
    }

    if (model.phone == '') {
      Util.showToast('请填写电话号码');
      return;
    }

    if (countryModel.id == null) {
      Util.showToast('请选择国家');
      return;
    }

    Map<String, dynamic> data = {
      'receiver_name': model.receiverName,
      'timezone': model.timezone,
      'phone': model.phone,
      'address': model.address,
      'country_id': countryModel.id,
      'postcode': model.postcode,
      'area_id': areaModel?.id ?? '',
      'sub_area_id': subAreaModel?.id ?? '',
    };
    EasyLoading.show();
    Map result = {};
    if (isEdit) {
      result = await AddressService.updateReciever(model.id!, data);
    } else {
      result = await AddressService.addReciever(data);
    }
    EasyLoading.dismiss();
    if (result['ok']) {
      EasyLoading.showSuccess(result['msg']).then((value) {
        ApplicationEvent.getInstance()
            .event
            .fire(ReceiverAddressRefreshEvent());
        Navigator.of(context).pop();
      });
    } else {
      EasyLoading.showError(result['msg']);
    }
  }

  @override
  bool get wantKeepAlive => true;

  showPickerDestion(BuildContext context) {
    Picker(
      adapter: PickerDataAdapter(data: getPickerSubView()),
      title: const Text("选择区域"),
      cancelText: '取消',
      confirmText: '确认',
      selectedTextStyle: const TextStyle(color: Colors.blue, fontSize: 12),
      onCancel: () {
        // showPicker = false;
      },
      onConfirm: (Picker picker, List value) {
        setState(() {
          areaModel = countryModel.areas![value.first];
          subAreaModel = countryModel.areas![value.first].areas![value.last];
        });
      },
    ).showModal(this.context);
  }

  getPickerSubView() {
    List<PickerItem> data = [];
    for (var item in countryModel.areas!) {
      var containe = PickerItem(
          text: Caption(
            fontSize: 24,
            str: item.name,
          ),
          children: getSubAreaViews(item));
      data.add(containe);
    }
    return data;
  }

  getSubAreaViews(AreaModel areasitem) {
    List<PickerItem> subList = [];
    for (var item in areasitem.areas!) {
      var subArea = PickerItem(
        text: Caption(
          fontSize: 24,
          str: item.name,
        ),
      );
      subList.add(subArea);
    }
    return subList;
  }
}
