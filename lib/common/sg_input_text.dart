// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_gay_components/common/sg_colors.dart';

class SGInputText extends StatefulWidget {
  final TextEditingController? controller;
  final int? maxLength;
  final int? maxLines;
  final bool? hasError;
  final bool? isLoading;
  final bool? enabled;
  final bool isRequired;
  final bool readOnly;
  final bool? obscureText;
  final bool isPassword;
  final String? label;
  final String? hintText;
  final String? counterText;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color cursorColor;
  final Color? colorLabel;
  final bool? isHalfWidth;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Widget? prefix;
  final double? borderRadius;
  final double radiusSize;
  final double cursorHeight;
  final double cursorWidth;
  final VoidCallback? onClickSuffixIcon;
  final VoidCallback? onClickPrefixIcon;
  final VoidCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Border? border;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardInputType;
  final bool isShowAlwaysLabel;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final double? width;
  final TextAlign textAlign;
  final bool expandable;
  final bool onlyLine;
  final bool showBorder;

  const SGInputText({
    super.key,
    this.controller,
    this.label,
    this.isRequired = false,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius,
    this.onClickSuffixIcon,
    this.onClickPrefixIcon,
    this.obscureText = false,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.border,
    this.onChanged,
    this.focusNode,
    this.onSubmitted,
    this.hintStyle,
    this.enabled,
    this.color,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.isHalfWidth,
    this.keyboardInputType,
    this.maxLength,
    this.hasError = false,
    this.isLoading = false,
    this.inputFormatters,
    this.onTapOutside,
    this.hintText,
    this.maxLines,
    this.isShowAlwaysLabel = false,
    this.alignment,
    this.padding,
    this.textInputAction,
    this.width,
    this.isPassword = false,
    this.enabledBorderColor = const Color(0xFFE5E5E5),
    this.focusedBorderColor = Colors.blue,
    this.radiusSize = 5,
    this.counterText = "",
    this.suffix = const SizedBox(width: 16),
    this.prefix,
    this.textAlign = TextAlign.start,
    this.expandable = false,
    this.onlyLine = false,
    this.showBorder = true,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.cursorColor = SGAppColors.color092C4C,
    this.colorLabel,
    this.cursorWidth = 1,
    this.cursorHeight = 14,
  });

  @override
  State<SGInputText> createState() => _SGInputTextState();
}

class _SGInputTextState extends State<SGInputText> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool obscureText = false;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    obscureText = widget.isPassword;
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    // Remove the listener that might be interfering with text deletion
    // _controller.addListener(_updateState);
    _focusNode.addListener(_updateState);
  }

  @override
  void dispose() {
    // _controller.removeListener(_updateState);
    _focusNode.removeListener(_updateState);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final double calculatedWidth =
        widget.width ?? MediaQuery.of(context).size.width / 2;

    return SizedBox(
      width: calculatedWidth,
      child: _buildTextField(widget.width),
    );
  }

  Widget _buildTextField(double? width) {
    final double effectiveHeight =
        widget.height ?? 48.0; // Default height if not specified
    final bool shouldExpand = widget.expandable || (widget.height != null);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Container(
        width: width,
        height: widget.expandable ? 32 : effectiveHeight,
        decoration: BoxDecoration(
          // color: Colors.red,
          borderRadius: BorderRadius.circular(widget.radiusSize),
        ),
        child: TextFormField(
          controller: _controller,
          textAlignVertical: TextAlignVertical.center,
          maxLength: widget.maxLength,
          maxLines: shouldExpand ? null : _getMaxLines(),
          minLines: shouldExpand ? null : (widget.expandable ? 3 : 1),
          expands: shouldExpand,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          onTapOutside: widget.onTapOutside,
          keyboardType: _getKeyboardType(),
          enabled: widget.enabled ?? true,
          focusNode: _focusNode,
          obscureText: obscureText,
          cursorColor: widget.cursorColor,
          cursorHeight: widget.cursorHeight,
          cursorWidth: widget.cursorWidth,
          inputFormatters: _getInputFormatters(),
          style: _getTextStyle(),
          textAlign: widget.textAlign,
          decoration: _getInputDecoration(),
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onSubmitted,
        ),
      ),
    );
  }

  int? _getMaxLines() {
    if (widget.isPassword) return 1;
    if (widget.expandable) return null;
    return widget.maxLines;
  }

  TextInputType _getKeyboardType() {
    if (widget.isPassword) {
      return widget.keyboardInputType ?? TextInputType.text;
    }
    if (widget.expandable) {
      return TextInputType.multiline;
    }
    return widget.keyboardInputType ?? TextInputType.text;
  }

  List<TextInputFormatter>? _getInputFormatters() {
    return widget.inputFormatters;
  }

  TextStyle _getTextStyle() {
    return TextStyle(
      fontSize: widget.fontSize ?? 16,
      fontWeight: widget.fontWeight,
      height: 1.2,
      leadingDistribution: TextLeadingDistribution.even,
      color: (widget.enabled ?? true)
          ? widget.color ?? SGAppColors.neutral900
          : SGAppColors.neutral600,
    );
  }

  InputDecoration _getInputDecoration() {
    final bool showUnderline = widget.onlyLine && (widget.enabled ?? true);

    final bool showRegularBorder = widget.showBorder && !widget.onlyLine;

    return InputDecoration(
      label: _buildLabel(),
      counterText: widget.counterText,
      isDense: true,
      floatingLabelBehavior: widget.isShowAlwaysLabel
          ? FloatingLabelBehavior.always
          : FloatingLabelBehavior.auto,
      border: showRegularBorder ? _buildBorder() : _buildTransparentBorder(),
      enabledBorder: showUnderline
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                color: _isHovering || _focusNode.hasFocus
                    ? widget.focusedBorderColor
                    : Colors.transparent,
                width: _isHovering || _focusNode.hasFocus ? 2 : 0,
              ),
            )
          : (showRegularBorder
              ? _buildEnabledBorder()
              : _buildTransparentBorder()),
      focusedBorder: showUnderline
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                color: widget.focusedBorderColor,
                width: 2,
              ),
            )
          : (showRegularBorder
              ? _buildFocusedBorder()
              : _buildTransparentBorder()),
      disabledBorder: showRegularBorder
          ? OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radiusSize),
              borderSide:
                  BorderSide(color: widget.enabledBorderColor.withOpacity(0.5)),
            )
          : _buildTransparentBorder(),
      suffixIcon: _buildSuffixIcon(),
      prefixIcon: widget.prefixIcon,
      suffix: !widget.isPassword ? widget.suffix : null,
      prefix: widget.prefix,
      hintText: widget.hintText,
      alignLabelWithHint: true,
      filled: false,
      hintStyle: widget.hintStyle ??
          const TextStyle(
              color: Color(0XFFB5B4B4),
              fontWeight: FontWeight.normal,
              fontSize: 14),
      contentPadding: widget.padding ??
          EdgeInsets.symmetric(
              vertical:
                  widget.height != null ? (widget.height! - 20) / 2 : 12.0,
              horizontal: 12.0),
    );
  }

  OutlineInputBorder _buildBorder() {
    if (!widget.showBorder ||
        (widget.onlyLine && !_isHovering && !_focusNode.hasFocus)) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.radiusSize),
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      );
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radiusSize),
    );
  }

  OutlineInputBorder _buildEnabledBorder() {
    if (!widget.showBorder ||
        (widget.onlyLine && !_isHovering && !_focusNode.hasFocus)) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.radiusSize),
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      );
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radiusSize),
      borderSide: BorderSide(color: widget.enabledBorderColor),
    );
  }

  OutlineInputBorder _buildFocusedBorder() {
    if (!widget.showBorder ||
        (widget.onlyLine && !_isHovering && !_focusNode.hasFocus)) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.radiusSize),
        borderSide: const BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      );
    }
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radiusSize),
      borderSide: BorderSide(color: widget.focusedBorderColor),
    );
  }

  Widget? _buildSuffixIcon() {
    if (!widget.isPassword) return widget.suffixIcon;
    return _buildPasswordVisibilityToggle();
  }

  Widget _buildPasswordVisibilityToggle() {
    return InkWell(
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      onTap: _togglePasswordVisibility,
      child: Icon(
        obscureText
            ? Icons.visibility_off_outlined
            : Icons.remove_red_eye_outlined,
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  OutlineInputBorder _buildTransparentBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.radiusSize),
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 0,
      ),
    );
  }

  Widget _buildLabel() {
    double? fontSize = widget.fontSize ?? 16;
    if (widget.label == null) return const SizedBox.shrink();
    if (widget.isRequired) {
      return RichText(
        text: TextSpan(
          text: widget.label,
          style: TextStyle(
            color: widget.colorLabel ?? Colors.black,
            fontSize: fontSize,
            // fontWeight: FontWeight.w900,
          ),
          children: [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontSize: fontSize + 2),
            ),
          ],
        ),
      );
    } else {
      return Text(
        widget.label!,
        style: TextStyle(
          color: widget.colorLabel ?? Colors.black,
          fontSize: fontSize,
          // fontWeight: widget.fontWeight,
        ),
      );
    }
  }
}
