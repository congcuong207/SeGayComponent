import 'package:flutter/material.dart';

class SGButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool outlined;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool enabled;
  final Color? mainColor;
  final FontWeight? fontWeight;

  const SGButton({
    super.key,
    required this.text,
    this.onPressed,
    this.outlined = false,
    this.borderRadius = 5,
    this.padding,
    this.enabled = true,
    this.mainColor,
    this.fontWeight,
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
            side: BorderSide(color: orange, width: 2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius)),
            padding: widget.padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: orange,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius)),
            padding: widget.padding ??
                const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          );
    final child = Text(
      widget.text,
      style: TextStyle(
        color: isOutlined ? orange : Colors.white,
        fontWeight: widget.fontWeight,
        fontSize: 16,
      ),
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
      child: button,
    );
  }
}
