import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:se_gay_components/common/sg_colors.dart';

class SGTextField extends StatefulWidget {
  final TextEditingController? controller;
  final bool? enabled;
  final bool readOnly;
  final String? label;
  final String? hintText;
  final Color? color;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? borderRadius;
  final VoidCallback? onClickSuffixIcon;
  final VoidCallback? onClickPreffixIcon;
  final VoidCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final bool? obscureText;
  final bool? isTextRequire;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Border? border;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final Function(String)? onSubmitted;
  final Widget? clearIcon;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool? isHalfWidth;
  final TextInputType? keyboardInputType;
  final int? maxLength;
  final int? maxLines;
  final bool? hasError;
  final bool? isLoading;
  final bool isShowAlwaysLable;
  final Alignment? alignment;
  final EdgeInsetsGeometry? padding;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;

  const SGTextField({
    super.key,
    this.controller,
    this.label,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius,
    this.onClickSuffixIcon,
    this.onClickPreffixIcon,
    this.obscureText,
    this.height,
    this.fontSize,
    this.fontWeight,
    this.border,
    this.onChanged,
    this.focusNode,
    this.onSubmitted,
    this.isTextRequire,
    this.labelStyle,
    this.hintStyle,
    this.enabled,
    this.color,
    this.clearIcon,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.isHalfWidth,
    this.keyboardInputType = TextInputType.text,
    this.maxLength,
    this.hasError = false,
    this.isLoading = false,
    this.inputFormatters,
    this.onTapOutside,
    this.hintText,
    this.maxLines = 1,
    this.isShowAlwaysLable = false,
    this.alignment,
    this.padding,
    this.textInputAction,
  });

  @override
  _VSTextFieldState createState() => _VSTextFieldState();
}

class _VSTextFieldState extends State<SGTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    _controller.addListener(_updateState);
    _focusNode.addListener(_updateState);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateState);
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool showClearIcon = _focusNode.hasFocus &&
        _controller.text.isNotEmpty &&
        widget.clearIcon != null;

    return Container(
      constraints: BoxConstraints(
        minHeight: widget.height ?? 52,
      ),
      alignment: widget.alignment,
      width: widget.isHalfWidth ?? false
          ? MediaQuery.of(context).size.width / 2 - 18
          : MediaQuery.of(context).size.width,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(widget.borderRadius ?? 0),
        ),
        color: (widget.enabled ?? true)
            ? widget.backgroundColor
            : SGAppColors.neutral300,
        border: widget.border ??
            Border.all(
                color: widget.hasError!
                    ? SGAppColors.primary600
                    : (widget.borderColor ?? SGAppColors.neutral400)),
      ),
      child: Row(
        children: [
          Visibility(
            visible: widget.prefixIcon != null,
            child: InkWell(
              onTap: widget.onClickPreffixIcon,
              child: Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 12),
                child: widget.prefixIcon,
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              textAlignVertical: TextAlignVertical.top,
              maxLength: widget.maxLength,
              maxLines: (widget.obscureText ?? false) ? 1 : widget.maxLines,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              onTapOutside: widget.onTapOutside,
              keyboardType: widget.keyboardInputType,
              enabled: widget.enabled ?? true,
              focusNode: _focusNode,
              controller: _controller,
              obscureText: widget.obscureText ?? false,
              inputFormatters: widget.inputFormatters ??
                  <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(RegExp(r'^\s+|\s+$')),
                  ],
              style: TextStyle(
                fontSize: widget.fontSize ?? 16,
                fontWeight: widget.fontWeight,
                color: (widget.enabled ?? true)
                    ? widget.color ?? SGAppColors.neutral900
                    : SGAppColors.neutral600,
              ),
              decoration: InputDecoration(
                counterText: "",
                floatingLabelBehavior: widget.isShowAlwaysLable
                    ? FloatingLabelBehavior.always
                    : FloatingLabelBehavior.auto,
                label: widget.label != null
                    ? Visibility(
                        visible: widget.label != null,
                        child: RichText(
                          text: TextSpan(
                            text: widget.label,
                            style: widget.labelStyle ??
                                const TextStyle(
                                  color: SGAppColors.neutral700,
                                  fontSize: 16.0,
                                ),
                            children: [
                              widget.isTextRequire ?? false
                                  ? const TextSpan(
                                      text: ' *',
                                      style: TextStyle(
                                        color: SGAppColors.primary600,
                                      ),
                                    )
                                  : const TextSpan(),
                            ],
                          ),
                        ),
                      )
                    : null, // Nhãn của TextField
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ??
                    const TextStyle(
                        color: Color(0XFFB5B4B4),
                        fontWeight: FontWeight.normal),
                contentPadding: widget.height == 40
                    ? const EdgeInsets.only(
                        top: 2,
                        bottom: 4,
                      )
                    : const EdgeInsets.only(
                        top: 4,
                        bottom: 2,
                      ),
              ),
              onChanged: (value) {
                if (widget.onChanged != null) {
                  widget.onChanged!(value);
                }
              },
              textInputAction: widget.textInputAction,
              onFieldSubmitted: (value) {
                if (widget.onSubmitted != null) {
                  widget.onSubmitted!(value);
                }
              },
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Visibility(
            visible: showClearIcon,
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    _controller.clear();
                    if (widget.onChanged != null) {
                      widget.onChanged!('');
                    }
                    setState(() {});
                  },
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: widget.clearIcon,
                  ),
                ),
                SizedBox(
                  width: widget.suffixIcon != null ? 16 : 0,
                )
              ],
            ),
          ),
          Visibility(
            visible: widget.suffixIcon != null,
            child: InkWell(
              onTap: widget.onClickSuffixIcon,
              child: SizedBox(
                width: 24,
                height: 24,
                child: (widget.isLoading ?? false)
                    ? const CupertinoActivityIndicator(
                        color: SGAppColors.neutral900,
                      )
                    : widget.suffixIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
