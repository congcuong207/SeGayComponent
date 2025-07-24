import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';

// ignore: must_be_immutable
class SGText extends StatelessWidget {
  final String? text;
  final TextAlign? textAlign;
  final TextStyle? style;
  final double? size;
  final FontWeight? fontWeight;
  final bool? isUpper;
  final Color? color;
  final FontStyle? fontStyle;
  final TextDecoration? textDecoration;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? lineHeight;
  const SGText(
      {super.key,
      this.text,
      this.textAlign,
      this.size,
      this.fontWeight,
      this.color,
      this.fontStyle,
      this.textDecoration,
      this.maxLines,
      this.isUpper,
      this.overflow,
      this.lineHeight,
      this.style});
  @override
  Widget build(BuildContext context) {
    return Text(
      isUpper ?? false ? text!.toUpperCase() : text!,
      style: style ??
          TextStyle(
              fontWeight: fontWeight,
              fontSize: size ?? 16,
              fontStyle: fontStyle ?? FontStyle.normal,
              decoration: textDecoration ?? TextDecoration.none,
              color: color ?? SGAppColors.neutral900,
              height: lineHeight),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}
