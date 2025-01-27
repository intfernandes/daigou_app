import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop_app_client/common/image_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop_app_client/config/color_config.dart';
import 'package:shop_app_client/views/components/indicator.dart';

class ImgItem extends StatelessWidget {
  const ImgItem(this.image,
      {Key? key,
      this.width,
      this.height,
      this.fit = BoxFit.cover,
      this.placeholderWidget,
      this.format = "png",
      this.holderColor,
      this.holderImg})
      : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String format;
  final String? holderImg;
  final Widget? placeholderWidget;
  final Color? holderColor;

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty || image == "null") {
      return holderImg != null
          ? LoadAssetImage(holderImg!,
              height: height, width: width, fit: fit, format: format)
          : Container(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              alignment: Alignment.center,
              color: holderColor ?? AppStyles.textGrayC,
              child: const Indicator(),
            );
    } else {
      if (image.startsWith("http")) {
        return CachedNetworkImage(
          imageUrl: image,
          placeholder: (context, url) => holderImg != null
              ? LoadAssetImage(
                  holderImg!,
                )
              : (placeholderWidget ??
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    alignment: Alignment.center,
                    color: holderColor ?? AppStyles.textGrayC,
                    child: const Indicator(),
                  )),
          errorWidget: (context, url, error) => holderImg != null
              ? LoadAssetImage(
                  holderImg!,
                )
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  alignment: Alignment.center,
                  color: holderColor ?? AppStyles.textGrayC,
                  child: const Indicator(),
                ),
          width: width,
          height: height,
          fit: fit,
        );
      } else {
        return LoadAssetImage(image,
            height: height, width: width, fit: fit, format: format);
      }
    }
  }
}

/// 加载本地资源图片
class LoadAssetImage extends StatelessWidget {
  const LoadAssetImage(
    this.image, {
    Key? key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.format = 'png',
  }) : super(key: key);

  final String image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String format;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      ImgLoadConfig.getImgPath(image, format: format),
      height: height,
      width: width,
      fit: fit,
      color: color,
    );
  }
}
