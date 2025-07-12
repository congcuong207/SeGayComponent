import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';

enum SGButtonState { active, inactive, loading }

// ignore: must_be_immutable
class SGButton extends StatelessWidget {
  final Function() onclick;
  final String text;
  double? borderRadius;
  double? width;
  double? height;
  double? textSize;
  Color? activeColor;
  Color? unActiveColor;
  Color? color;
  Color? textColor;
  SGButtonState state;
  Border? border;

  EdgeInsetsGeometry? padding;
  FontWeight? fontWeight;
  Alignment? alignment;
  Widget prefixWidget;

  SGButton({
    super.key,
    required this.onclick,
    required this.text,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
    this.alignment,
    this.activeColor,
    this.color,
    this.unActiveColor,
    this.state = SGButtonState.active,
    this.textColor,
    this.textSize,
    this.fontWeight,
    this.border,
    this.prefixWidget = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    Color colorButton;
    if ([SGButtonState.active, SGButtonState.loading].contains(state)) {
      colorButton = activeColor ?? color ?? SGAppColors.info200;
      textColor = textColor ?? SGAppColors.neutral0;
    } else {
      colorButton = unActiveColor ?? Colors.grey;
      textColor = textColor ?? SGAppColors.neutral900;
    }
    return InkWell(
      onTap: () {
        if (state == SGButtonState.active) {
          onclick();
        }
      },
      child: Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
        alignment: alignment,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 0.0),
          color: colorButton,
          border: border,
        ),
        child: SizedBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (state != SGButtonState.loading)
                      ? prefixWidget
                      : const SizedBox.shrink(),
                  Expanded(
                    child: Text(
                      (state != SGButtonState.loading) ? text : "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: textSize ?? 13,
                        fontWeight: fontWeight ?? FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                width: 10,
                height: 10,
                child: (state == SGButtonState.loading)
                    ? const CupertinoActivityIndicator(
                        color: SGAppColors.neutral900,
                      )
                    : const SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
