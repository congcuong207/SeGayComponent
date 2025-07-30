import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/themes/sg_app_font.dart';

class SGTableCell extends StatelessWidget {
  final String text;
  final Widget? child;
  final Alignment alignment;
  final double width;
  final double height;
  final TextStyle? textStyle;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool showLeftLine;
  final bool showRightLine;

  final Color leftLineColor;
  final Color rightLineColor;

  const SGTableCell({
    super.key,
    required this.text,
    this.child,
    this.alignment = Alignment.centerLeft,
    this.width = 120,
    this.height = 40,
    this.textStyle,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
    this.showLeftLine = true,
    this.showRightLine = false,
    this.leftLineColor = SGAppColors.neutral200,
    this.rightLineColor = SGAppColors.neutral200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border(
          right: showRightLine
              ? BorderSide(
                  color: rightLineColor,
                  width: 1,
                )
              : BorderSide.none,
          left: showLeftLine
              ? BorderSide(
                  color: leftLineColor,
                  width: 1,
                )
              : BorderSide.none,
        ),
      ),
      child: child ??
          Text(
            text,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: TextAlign.center,
            style: textStyle ?? SGAppFont.bodySmall(),
          ),
    );
  }
}
