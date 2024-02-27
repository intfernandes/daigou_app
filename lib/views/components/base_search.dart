import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:huanting_shop/config/color_config.dart';
import 'package:huanting_shop/config/routers.dart';
import 'package:huanting_shop/extension/translation.dart';
import 'package:huanting_shop/views/components/input/base_input.dart';
import 'package:huanting_shop/views/components/load_image.dart';
import 'package:huanting_shop/views/shop/goods_detail/goods_detail_binding.dart';
import 'package:huanting_shop/views/shop/goods_detail/goods_detail_view.dart';
import 'package:huanting_shop/views/shop/platform_goods/platform_goods_binding.dart';
import 'package:huanting_shop/views/shop/platform_goods/platform_goods_list_view.dart';

class BaseSearch extends StatefulWidget {
  const BaseSearch({
    Key? key,
    this.hintText = '请输入商品名/电商平台商品链接',
    this.searchText = '代购',
    this.onSearch,
    this.needCheck = true,
    this.initData,
    this.goPlatformGoods = true,
    this.whiteBg = false,
    this.showScan = true,
  }) : super(key: key);
  final String hintText;
  final String searchText;
  final bool needCheck;
  final Function(String value)? onSearch;
  final String? initData;
  final bool goPlatformGoods;
  final bool showScan;
  final bool whiteBg;

  @override
  State<BaseSearch> createState() => _SearchCellState();
}

class _SearchCellState extends State<BaseSearch> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  String keyword = '';
  bool _isFoucsed = false;

  @override
  initState() {
    super.initState();
    if (widget.initData != null) {
      controller.text = widget.initData!;
      keyword = widget.initData!;
    }
    if (!widget.showScan) {
      focusNode.addListener(listenFocus);
    }
  }

  void listenFocus() {
    if (mounted) {
      setState(() {
        _isFoucsed = focusNode.hasFocus;
      });
    }
  }

  @override
  dispose() {
    if (!widget.showScan) {
      focusNode.removeListener(listenFocus);
    }
    focusNode.dispose();
    super.dispose();
  }

  void onConfirm(BuildContext context, String value) {
    if (value.trim().isEmpty && widget.needCheck) {
      EasyLoading.showToast('请输入搜索内容'.ts);
      return;
    }
    focusNode.unfocus();
    if (widget.onSearch != null) {
      widget.onSearch!(value);
    } else if (widget.goPlatformGoods) {
      if (value.startsWith('http')) {
        // 商品链接直接跳转到详情
        Get.to(GoodsDetailView(goodsId: value),
            arguments: {'url': value}, binding: GoodsDetailBinding(tag: value));
      } else {
        Get.to(PlatformGoodsListView(controllerTag: value),
            arguments: {'keyword': value, 'origin': value},
            binding: PlatformGoodsBinding(tag: value));
      }
      controller.text = '';
      keyword = '';
    }
  }

  void onPhotoSearch() async {
    var cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      BeeNav.push(BeeNav.imageSearch, arg: {'device': cameras.first});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: widget.whiteBg ? Colors.white : const Color(0xFFF6F7FB),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          LoadAssetImage('Home/ico_search', width: 20.w, height: 20.w),
          10.horizontalSpace,
          Expanded(
            child: Obx(
              () => BaseInput(
                board: !widget.whiteBg,
                controller: controller,
                focusNode: focusNode,
                isCollapsed: true,
                isSearchInput: true,
                maxLength: 200,
                autoShowRemove: false,
                textInputAction: TextInputAction.search,
                hintStyle:
                    TextStyle(fontSize: 12.sp, color: AppColors.textGrayC9),
                contentPadding: EdgeInsets.symmetric(vertical: 7.h),
                hintText: widget.hintText.ts,
                onSubmitted: (value) {
                  onConfirm(context, value);
                },
                onChanged: (value) {
                  setState(() {
                    keyword = value;
                  });
                },
              ),
            ),
          ),
          if (widget.showScan)
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: GestureDetector(
                onTap: onPhotoSearch,
                child:
                    LoadAssetImage('Home/ico_zxj', width: 20.w, height: 20.w),
              ),
            ),
          if (_isFoucsed && keyword.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.text = '';
                setState(() {
                  keyword = '';
                });
              },
              child: Icon(
                Icons.cancel,
                color: AppColors.textGray,
                size: 18.sp,
              ),
            ),
        ],
      ),
    );
  }
}
