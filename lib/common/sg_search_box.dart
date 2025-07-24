import 'package:flutter/material.dart';
import 'package:se_gay_components/common/sg_button_icon_v2.dart';
import 'package:se_gay_components/common/sg_colors.dart';
import 'package:se_gay_components/themes/sg_app_font.dart';

class SGSearchBox extends StatelessWidget {
  final Widget? iconLeft;

  /// Width of the search box
  final double? width;

  /// Height of the search box
  final double height;

  /// Cursor width of the search box
  final double cursorWidth;

  /// Cursor height of the search box
  final double cursorHeight;

  /// Margin of the search box
  final EdgeInsetsGeometry? margin;

  /// Padding of the search box
  final EdgeInsetsGeometry padding;

  /// Background color of the search box
  final Color backgroundColor;

  /// Border color of the search box
  final Color borderColor;

  /// Cursor color of the search box
  final Color cursorColor;

  /// Border radius of the search box
  final double borderRadius;

  /// Placeholder text for the search field
  final String hintText;

  /// The controller for the text field
  final TextEditingController? controller;

  /// The search icon asset path
  final String searchIcon;

  /// Whether to show the filter button
  final bool showFilterButton;

  /// The filter icon asset path
  final String filterIcon;

  /// Callback when the search text changes
  final Function(String)? onChanged;

  /// Callback when the search is submitted
  final Function(String)? onSubmitted;

  /// Callback when the filter button is pressed
  final Function(BuildContext context)? onFilterPressed;

  /// Text style for the search input
  final TextStyle? textStyle;

  /// Text style for the hint text
  final TextStyle? hintStyle;

  /// If true, the clear button will be shown when there's text
  final bool showClearButton;

  const SGSearchBox({
    super.key,
    this.iconLeft,
    this.width,
    this.height = 34,
    this.margin,
    this.padding = const EdgeInsets.only(left: 6),
    this.backgroundColor = Colors.white,
    this.borderColor = SGAppColors.neutral400,
    this.borderRadius = 6,
    this.hintText = 'Tìm kiếm ...',
    this.cursorColor = SGAppColors.color092C4C,
    this.cursorWidth = 1,
    this.cursorHeight = 14,
    this.controller,
    this.searchIcon = "",
    this.showFilterButton = true,
    this.filterIcon = "",
    this.onChanged,
    this.onSubmitted,
    this.onFilterPressed,
    this.textStyle,
    this.hintStyle,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconLeft ?? const SizedBox.shrink(),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              cursorColor: cursorColor,
              cursorHeight: cursorHeight,
              cursorWidth: cursorWidth,
              decoration: InputDecoration(
                focusColor: SGAppColors.neutral0,
                hintText: hintText,
                hintStyle: hintStyle ??
                    SGAppFont.bodyMedium(
                      color: SGAppColors.neutral600,
                    ),
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                suffixIcon: showClearButton && controller != null && controller!.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          controller?.clear();
                          if (onChanged != null) onChanged!('');
                        },
                        child: const Icon(
                          Icons.clear,
                          size: 16,
                          color: SGAppColors.neutral600,
                        ),
                      )
                    : null,
                suffixIconConstraints: const BoxConstraints(
                  maxHeight: 24,
                  maxWidth: 24,
                ),
              ),
              style: textStyle ?? SGAppFont.bodyMedium(color: Colors.black),
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
            ),
          ),
          if (showFilterButton)
            SGButtonIconV2(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(4),
              icon: filterIcon,
              width: 26,
              onclick: onFilterPressed ?? (context) {},
            ),
        ],
      ),
    );
  }
}
