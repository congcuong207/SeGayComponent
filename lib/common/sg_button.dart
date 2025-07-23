import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_text.dart';

class SGButton extends StatefulWidget {
  final String text;
  final String? iconButton;
  final double width;
  final double height;
  final double? sizeWidthIcon;
  final double? sizeHeightIcon;
  final bool outlined;
  final bool enabled;
  final double borderRadius;
  final Color? mainColor;
  final Color? colorIcon;
  final EdgeInsetsGeometry? padding;
  final FontWeight? fontWeight;
  final VoidCallback? onPressed;
  final Color? defaultBGColor;

  const SGButton({
    super.key,
    required this.text,
    this.iconButton,
    this.width = 100.0,
    this.height = 48.0,
    this.sizeWidthIcon,
    this.sizeHeightIcon,
    this.outlined = false,
    this.enabled = true,
    this.borderRadius = 5,
    this.mainColor,
    this.colorIcon,
    this.padding,
    this.fontWeight,
    this.onPressed,
    this.defaultBGColor,
  });

  static const Color defaultOrange = Color(0xFFFFA726);

  @override
  State<SGButton> createState() => _SGButtonState();
}

class _SGButtonState extends State<SGButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final Color orange = widget.mainColor ?? SGButton.defaultOrange;
    final isOutlined = widget.outlined || _hovering;
    final style = isOutlined
        ? OutlinedButton.styleFrom(
            // backgroundColor: Colors.blue,
            side: BorderSide(color: orange, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            padding: widget.padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius)),
            padding: widget.padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          );
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.iconButton != null)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Image.asset(
              widget.iconButton!,
              width: widget.sizeWidthIcon,
              height: widget.sizeHeightIcon,
              color: isOutlined ? orange : widget.colorIcon,
              fit: BoxFit.contain,
            ),
          ),
        Expanded(
          child: SGText(
            textAlign: TextAlign.center,
            text: widget.text,
            style: TextStyle(
                color: isOutlined ? orange : Colors.white,
                fontWeight: widget.fontWeight,
                fontSize: 16,
                height: 1.2),
          ),
        ),
      ],
    );
    final button = isOutlined
        ? OutlinedButton(
            onPressed: widget.enabled ? widget.onPressed : null,
            style: style,
            child: child,
          )
        : ElevatedButton(
            onPressed: widget.enabled ? widget.onPressed : null,
            style: style,
            child: child,
          );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: _hovering ? orange : Colors.black),
            color: widget.defaultBGColor,
            borderRadius: BorderRadius.circular(widget.borderRadius)),
        child: child,
      ),
    );
  }
}
