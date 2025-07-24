import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SGButtonIconV2 extends StatelessWidget {
  final Function(BuildContext context)? onclick;
  final Function(BuildContext context, PointerHoverEvent event)? onHover;
  final Function(BuildContext context, PointerExitEvent event)? onExit;
  final Function(BuildContext context, PointerEnterEvent event)? onEnter;

  final double? width;
  final double? height;
  final Color? colorBackground;
  final double? iconSize;
  final double? borderRadius;
  final Widget? iconChild;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SGButtonIconV2({
    super.key,
    this.onHover,
    this.onEnter,
    this.onExit,
    this.onclick,
    this.width,
    this.height,
    this.iconChild,
    this.colorBackground,
    this.iconSize,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        onEnter?.call(context, value);
      },
      onExit: (value) {
        onExit?.call(context, value);
      },
      onHover: (value) {
        onHover?.call(context, value);
      },
      child: InkWell(
        onTap: () {
          onclick?.call(context);
        },
        child: Container(
          width: width ?? 34,
          height: height ?? 34,
          padding: padding ?? const EdgeInsets.all(0),
          margin: margin ?? const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: colorBackground ?? Colors.grey.shade100,
            borderRadius: BorderRadius.circular(borderRadius ?? 6),
          ),
          child: Center(child: iconChild),
        ),
      ),
    );
  }
}
