import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';

enum SGButtonState { active, inactive, loading }

class SGButton extends StatelessWidget {
  final Function() onclick;
  final String text;
  final TextStyle? textStyle;
  final double? borderRadius;
  final double? width;
  final double? height;
  final double? textSize;
  final Color? activeColor;
  final Color? unActiveColor;
  final Color? color;
  final Color? textColor;
  final SGButtonState state;
  final Border? border;

  final double? loadingSize;
  final Color? loadingColor;

  final EdgeInsetsGeometry? padding;
  final FontWeight? fontWeight;
  final Alignment? alignment;
  final Widget prefixWidget;

  const SGButton({
    super.key,
    required this.onclick,
    required this.text,
    this.textStyle,
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
    this.loadingSize,
    this.loadingColor,
  });

  @override
  Widget build(BuildContext context) {
    Color colorButton;
    Color textColor;
    if ([SGButtonState.active, SGButtonState.loading].contains(state)) {
      colorButton = activeColor ?? color ?? SGAppColors.info200;
      textColor = this.textColor ?? SGAppColors.neutral0;
    } else {
      colorButton = unActiveColor ?? Colors.grey;
      textColor = this.textColor ?? SGAppColors.neutral900;
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
        padding: padding ?? const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        alignment: alignment ?? Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 0.0),
          color: colorButton,
          border: border,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: state != SGButtonState.loading ? 1 : 0,
              child: Row(
                mainAxisSize: width == null ? MainAxisSize.min : MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  prefixWidget,
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: textStyle ??
                        TextStyle(
                          color: textColor,
                          fontSize: textSize ?? 13,
                          fontWeight: fontWeight ?? FontWeight.w400,
                        ),
                  )
                ],
              ),
            ),
            if (state == SGButtonState.loading)
              CupertinoActivityIndicator(
                color: loadingColor ?? SGAppColors.neutral900,
                radius: loadingSize ?? 6,
              ),
          ],
        ),
      ),
    );
  }
}
