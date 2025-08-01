import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_text.dart';

class SGButtonIcon extends StatefulWidget {
  final String text;
  final String? iconButton;
  final double width;
  final double height;
  final double sizeWidthIcon;
  final double sizeHeightIcon;
  final double? sizeText;
  final double? borderWidth;
  final double paddingIconLeft;
  final bool enabled;
  final bool isOutlined;
  final bool isBorder;
  final bool isHover;
  final double borderRadius;
  final Color? colorHover;
  final Color? colorTextHover;
  final Color? colorText;
  final Color? colorBorder;
  final Color? defaultBGColor;
  final Color? colorIcon;
  final EdgeInsetsGeometry? padding;
  final FontWeight? fontWeight;
  final VoidCallback? onPressed;
  final Decoration? decoration;

  const SGButtonIcon({
    super.key,
    required this.text,
    this.iconButton,
    this.width = 100.0,
    this.height = 48.0,
    this.sizeWidthIcon = 24,
    this.sizeHeightIcon = 24,
    this.sizeText,
    this.borderWidth,
    this.paddingIconLeft = 2,
    this.enabled = true,
    this.isOutlined = false,
    this.isBorder = false,
    this.isHover = true,
    this.borderRadius = 5,
    this.colorHover,
    this.colorTextHover,
    this.colorText,
    this.colorBorder,
    this.defaultBGColor,
    this.colorIcon,
    this.padding,
    this.fontWeight,
    this.onPressed,
    this.decoration,
  });

  static const Color defaultOrange = Color(0xFFFFA726);

  @override
  State<SGButtonIcon> createState() => _SGButtonState();
}

class _SGButtonState extends State<SGButtonIcon> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.iconButton != null)
          Padding(
            padding: EdgeInsets.only(left: widget.paddingIconLeft, right: 5),
            child: Image.asset(
              widget.iconButton!,
              width: widget.sizeWidthIcon,
              height: widget.sizeHeightIcon,
              color: _hovering ? widget.colorHover : widget.colorIcon,
              fit: BoxFit.contain,
            ),
          ),
        Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: 2,
                  right: widget.iconButton != null ? widget.paddingIconLeft : 0),
              child: SGText(
                textAlign: TextAlign.center,
                fontWeight: widget.fontWeight ?? FontWeight.bold,
                text: widget.text,
                size: widget.sizeText ?? 16,
                color: !widget.isOutlined
                    ? widget.colorText ?? Colors.white
                    : _hovering
                        ? widget.colorTextHover ?? widget.colorHover
                        : widget.isBorder
                            ? widget.colorText
                            : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          decoration: widget.decoration ?? _buildDecoration(),
          child: child,
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      border: _getBorder(),
      color: widget.defaultBGColor,
      borderRadius: BorderRadius.circular(widget.borderRadius),
    );
  }

  Border? _getBorder() {
    // Không phải outline - sử dụng border mặc định
    // if (!widget.isOutlined) {
    //   return Border.all(
    //     color: widget.colorBorder ?? Colors.black,
    //     width: widget.borderWidth ?? 2,
    //   );
    // }
    
    // Đang hover - sử dụng border hover
    if (_hovering && widget.isHover) {
      return Border.all(
        color: widget.colorHover ?? Colors.black,
        width: widget.borderWidth ?? 2,
      );
    }
    
    // Có border nhưng không hover
    if (widget.isBorder) {
      return Border.all(
        color: widget.colorBorder ?? Colors.black,
        width: widget.borderWidth ?? 2,
      );
    }
    
    // Trường hợp không có border
    return null;
  }
}
