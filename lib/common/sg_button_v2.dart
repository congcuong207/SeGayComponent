import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum SGButtonType {
  primary,
  secondary,
  outline,
  text,
  icon,
}

enum SGButtonSize {
  small,
  medium,
  large,
}

class SGButtonV2 extends StatelessWidget {
  final Function(BuildContext context)? onclick;
  final Function(BuildContext context, PointerHoverEvent event)? onHover;
  final Function(BuildContext context, PointerExitEvent event)? onExit;
  final Function(BuildContext context, PointerEnterEvent event)? onEnter;

  final double? width;
  final double? height;
  final Color? colorBackground;
  final Color? colorText;
  final Color? colorBorder;
  final double? iconSize;
  final double? borderRadius;
  final Widget? iconChild;
  final String? text;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isDisabled;
  final bool isLoading;
  final SGButtonType buttonType;
  final SGButtonSize buttonSize;
  final MainAxisAlignment contentAlignment;
  final double? borderWidth;

  const SGButtonV2({
    super.key,
    this.onHover,
    this.onEnter,
    this.onExit,
    this.onclick,
    this.width,
    this.height,
    this.iconChild,
    this.colorBackground,
    this.colorText,
    this.colorBorder,
    this.iconSize,
    this.borderRadius,
    this.padding,
    this.margin,
    this.text,
    this.textStyle,
    this.isDisabled = false,
    this.isLoading = false,
    this.buttonType = SGButtonType.primary,
    this.buttonSize = SGButtonSize.medium,
    this.contentAlignment = MainAxisAlignment.center,
    this.borderWidth,
  });

  // Factory constructors for different button types
  factory SGButtonV2.primary({
    Key? key,
    Function(BuildContext context)? onclick,
    Function(BuildContext context, PointerHoverEvent event)? onHover,
    Function(BuildContext context, PointerExitEvent event)? onExit,
    Function(BuildContext context, PointerEnterEvent event)? onEnter,
    String? text,
    Widget? iconChild,
    bool isDisabled = false,
    bool isLoading = false,
    SGButtonSize buttonSize = SGButtonSize.medium,
    double? width,
    EdgeInsetsGeometry? margin,
  }) {
    return SGButtonV2(
      key: key,
      onclick: onclick,
      onHover: onHover,
      onExit: onExit,
      onEnter: onEnter,
      text: text,
      iconChild: iconChild,
      isDisabled: isDisabled,
      isLoading: isLoading,
      buttonType: SGButtonType.primary,
      buttonSize: buttonSize,
      width: width,
      margin: margin,
    );
  }

  factory SGButtonV2.secondary({
    Key? key,
    Function(BuildContext context)? onclick,
    Function(BuildContext context, PointerHoverEvent event)? onHover,
    Function(BuildContext context, PointerExitEvent event)? onExit,
    Function(BuildContext context, PointerEnterEvent event)? onEnter,
    String? text,
    Widget? iconChild,
    bool isDisabled = false,
    bool isLoading = false,
    SGButtonSize buttonSize = SGButtonSize.medium,
    double? width,
    EdgeInsetsGeometry? margin,
  }) {
    return SGButtonV2(
      key: key,
      onclick: onclick,
      onHover: onHover,
      onExit: onExit,
      onEnter: onEnter,
      text: text,
      iconChild: iconChild,
      isDisabled: isDisabled,
      isLoading: isLoading,
      buttonType: SGButtonType.secondary,
      buttonSize: buttonSize,
      width: width,
      margin: margin,
    );
  }

  factory SGButtonV2.outline({
    Key? key,
    Function(BuildContext context)? onclick,
    Function(BuildContext context, PointerHoverEvent event)? onHover,
    Function(BuildContext context, PointerExitEvent event)? onExit,
    Function(BuildContext context, PointerEnterEvent event)? onEnter,
    String? text,
    Widget? iconChild,
    bool isDisabled = false,
    bool isLoading = false,
    SGButtonSize buttonSize = SGButtonSize.medium,
    double? width,
    Color? colorBorder,
    EdgeInsetsGeometry? margin,
  }) {
    return SGButtonV2(
      key: key,
      onclick: onclick,
      onHover: onHover,
      onExit: onExit,
      onEnter: onEnter,
      text: text,
      iconChild: iconChild,
      isDisabled: isDisabled,
      isLoading: isLoading,
      buttonType: SGButtonType.outline,
      buttonSize: buttonSize,
      width: width,
      colorBorder: colorBorder,
      margin: margin,
    );
  }

  factory SGButtonV2.text({
    Key? key,
    Function(BuildContext context)? onclick,
    Function(BuildContext context, PointerHoverEvent event)? onHover,
    Function(BuildContext context, PointerExitEvent event)? onExit,
    Function(BuildContext context, PointerEnterEvent event)? onEnter,
    String? text,
    Widget? iconChild,
    bool isDisabled = false,
    bool isLoading = false,
    SGButtonSize buttonSize = SGButtonSize.medium,
    Color? colorText,
    EdgeInsetsGeometry? margin,
  }) {
    return SGButtonV2(
      key: key,
      onclick: onclick,
      onHover: onHover,
      onExit: onExit,
      onEnter: onEnter,
      text: text,
      iconChild: iconChild,
      isDisabled: isDisabled,
      isLoading: isLoading,
      buttonType: SGButtonType.text,
      buttonSize: buttonSize,
      colorText: colorText,
      margin: margin,
    );
  }

  factory SGButtonV2.icon({
    Key? key,
    Function(BuildContext context)? onclick,
    Function(BuildContext context, PointerHoverEvent event)? onHover,
    Function(BuildContext context, PointerExitEvent event)? onExit,
    Function(BuildContext context, PointerEnterEvent event)? onEnter,
    Widget? iconChild,
    bool isDisabled = false,
    bool isLoading = false,
    SGButtonSize buttonSize = SGButtonSize.medium,
    Color? colorBackground,
    double? iconSize,
    EdgeInsetsGeometry? margin,
  }) {
    return SGButtonV2(
      key: key,
      onclick: onclick,
      onHover: onHover,
      onExit: onExit,
      onEnter: onEnter,
      iconChild: iconChild,
      isDisabled: isDisabled,
      isLoading: isLoading,
      buttonType: SGButtonType.icon,
      buttonSize: buttonSize,
      colorBackground: colorBackground,
      iconSize: iconSize,
      margin: margin,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define default styles based on button type and size
    final defaultStyles = _getDefaultStyles(context);
    
    return MouseRegion(
      onEnter: isDisabled
          ? null
          : (value) {
              onEnter?.call(context, value);
            },
      onExit: isDisabled
          ? null
          : (value) {
              onExit?.call(context, value);
            },
      onHover: isDisabled
          ? null
          : (value) {
              onHover?.call(context, value);
            },
      child: InkWell(
        onTap: (isDisabled || isLoading)
            ? null
            : () {
                onclick?.call(context);
              },
        borderRadius: BorderRadius.circular(defaultStyles.borderRadius),
        child: Container(
          width: width ?? defaultStyles.width,
          height: height ?? defaultStyles.height,
          padding: padding ?? defaultStyles.padding,
          margin: margin ?? const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: isDisabled ? Colors.grey.shade300 : colorBackground ?? defaultStyles.backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius ?? defaultStyles.borderRadius),
            border: buttonType == SGButtonType.outline
                ? Border.all(
                    color: isDisabled ? Colors.grey.shade400 : colorBorder ?? Theme.of(context).primaryColor,
                    width: borderWidth ?? 1.0,
                  )
                : null,
          ),
          child: _buildButtonContent(defaultStyles),
        ),
      ),
    );
  }

  Widget _buildButtonContent(_ButtonStyles styles) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              buttonType == SGButtonType.primary ? Colors.white : styles.textColor,
            ),
          ),
        ),
      );
    }

    if (buttonType == SGButtonType.icon) {
      return Center(
        child: iconChild ?? const SizedBox.shrink(),
      );
    }

    // For buttons with text or text+icon
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: contentAlignment,
      children: [
        if (iconChild != null) ...[
          iconChild!,
          if (text != null) const SizedBox(width: 8),
        ],
        if (text != null)
          Text(
            text!,
            style: textStyle ??
                TextStyle(
                  color: isDisabled ? Colors.grey.shade600 : colorText ?? styles.textColor,
                  fontSize: styles.fontSize,
                  fontWeight: FontWeight.w500,
                ),
          ),
      ],
    );
  }

  _ButtonStyles _getDefaultStyles(BuildContext context) {
    final theme = Theme.of(context);
    
    // Base sizes based on button size
    double height;
    double fontSize;
    EdgeInsetsGeometry padding;
    
    switch (buttonSize) {
      case SGButtonSize.small:
        height = 32;
        fontSize = 12;
        padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
        break;
      case SGButtonSize.large:
        height = 48;
        fontSize = 16;
        padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
        break;
      case SGButtonSize.medium:
        height = 40;
        fontSize = 14;
        padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        break;
    }

    // Button type specific styles
    Color backgroundColor;
    Color textColor;
    
    switch (buttonType) {
      case SGButtonType.primary:
        backgroundColor = theme.primaryColor;
        textColor = Colors.white;
        break;
      case SGButtonType.secondary:
        backgroundColor = theme.primaryColor.withOpacity(0.1);
        textColor = theme.primaryColor;
        break;
      case SGButtonType.outline:
        backgroundColor = Colors.transparent;
        textColor = theme.primaryColor;
        break;
      case SGButtonType.text:
        backgroundColor = Colors.transparent;
        textColor = theme.primaryColor;
        break;
      case SGButtonType.icon:
        backgroundColor = Colors.grey.shade100;
        textColor = theme.primaryColor;
        height = buttonSize == SGButtonSize.small ? 32 : (buttonSize == SGButtonSize.large ? 48 : 40);
        break;
    }

    return _ButtonStyles(
      width: buttonType == SGButtonType.icon ? height : null,
      height: height,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderRadius: 6,
      padding: padding,
      fontSize: fontSize,
    );
  }
}

class _ButtonStyles {
  final double? width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double fontSize;

  _ButtonStyles({
    this.width,
    required this.height,
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
    required this.padding,
    required this.fontSize,
  });
}
