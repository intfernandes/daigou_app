import 'package:jiyun_app_client/common/translation.dart';
import 'package:jiyun_app_client/config/color_config.dart';
import 'package:jiyun_app_client/views/components/caption.dart';
import 'package:flutter/material.dart';

class PlainButton extends StatefulWidget {
  const PlainButton({
    Key? key,
    required this.text,
    this.fontSize = 15,
    this.borderRadis = 5,
    this.padding,
    this.visualDensity,
    this.borderColor = ColorConfig.primary,
    this.textColor = ColorConfig.primary,
    this.onPressed,
  }) : super(key: key);
  final String text;
  final double fontSize;
  final double borderRadis;
  final Color borderColor;
  final Color textColor;
  final Function? onPressed;
  final VisualDensity? visualDensity;
  final EdgeInsetsGeometry? padding;
  @override
  State<PlainButton> createState() => _PlainButtonState();
}

class _PlainButtonState extends State<PlainButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadis),
          ),
        ),
        visualDensity: widget.visualDensity ?? VisualDensity.standard,
        padding: MaterialStateProperty.all(
            widget.padding ?? const EdgeInsets.symmetric(horizontal: 10)),
        side: MaterialStateProperty.all(
          BorderSide(color: widget.borderColor),
        ),
      ),
      child: Caption(
        str: Translation.t(context, widget.text),
        fontSize: widget.fontSize,
        color: widget.textColor,
      ),
    );
  }
}
