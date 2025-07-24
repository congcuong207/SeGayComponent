import 'package:flutter/material.dart';

/// A customizable card widget that provides various styling options.
///
/// This widget provides a flexible card with customizable properties such as color,
/// elevation, border radius, gradient, and interaction capabilities. It can be used 
/// in many contexts where content needs to be displayed in a visually distinct container.
///
/// The card will size itself according to its child, unless specific dimensions
/// are provided through [width] and [height]. It can also respond to tap gestures
/// if an [onTap] callback is provided.
///
/// See also:
///
///  * [Card], the standard Material Design card in Flutter.
///  * [Container], a general-purpose widget for containing other widgets.
///  * [InkWell], which provides the ink splash effect when tapped.
///  * [BoxDecoration], which is used to decorate the card.
///  * [SgCard.elevated], [SgCard.outlined], and [SgCard.gradient] for specialized card variants.

class SgCard extends StatelessWidget {
  /// The widget to display inside the card.
  final Widget child;
  
  /// The padding inside the card. Defaults to EdgeInsets.all(16) if not provided.
  final EdgeInsetsGeometry? padding;
  
  /// The margin around the card.
  final EdgeInsetsGeometry? margin;
  
  /// The width of the card. If null, the card will size itself to its content.
  final double? width;
  
  /// The height of the card. If null, the card will size itself to its content.
  final double? height;
  
  /// The background color of the card. If null, it will use the theme's card color.
  final Color? color;
  
  /// The color of the shadow. If null, it will use a semi-transparent black.
  final Color? shadowColor;
  
  /// The radius of the card's corners. Defaults to 8.0.
  final double borderRadius;
  
  /// The elevation of the card, which determines the size of the shadow. Defaults to 2.0.
  final double elevation;
  
  /// The callback that is called when the card is tapped.
  final VoidCallback? onTap;
  
  /// The border to draw around the card.
  final BoxBorder? border;
  
  /// The gradient to apply to the card background.
  final Gradient? gradient;
  
  /// How the child should be positioned within the card.
  final AlignmentGeometry? alignment;
  
  /// How to clip the contents of the card. Defaults to [Clip.none].
  final Clip clipBehavior;

  /// Creates a card with customizable properties.
  ///
  /// The [child] parameter is required, while all others are optional.
  const SgCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.shadowColor,
    this.borderRadius = 8.0,
    this.elevation = 2.0,
    this.onTap,
    this.border,
    this.gradient,
    this.alignment,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: shadowColor ?? Colors.black.withValues(alpha: 0.1),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                  spreadRadius: elevation / 2,
                )
              ]
            : null,
        border: border,
        gradient: gradient,
      ),
      child: child,
    );

    return Container(
      margin: margin,
      clipBehavior: clipBehavior,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: onTap != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(borderRadius),
                child: cardContent,
              ),
            )
          : cardContent,
    );
  }

  /// Creates an elevated card with a more pronounced shadow.
  ///
  /// This factory creates a card with a higher elevation (4.0) for a more
  /// prominent appearance. Useful for important content that needs to stand out.
  factory SgCard.elevated({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    Color? color,
    double borderRadius = 8.0,
    VoidCallback? onTap,
    Color? shadowColor,
  }) {
    return SgCard(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius,
      onTap: onTap,
      elevation: 4.0,
      shadowColor: shadowColor,
      child: child,
    );
  }

  /// Creates an outlined card with a border and no elevation.
  ///
  /// This factory creates a card with a border and no shadow. Useful for
  /// content that should be visually contained but not elevated.
  factory SgCard.outlined({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    Color? color,
    double borderRadius = 8.0,
    VoidCallback? onTap,
    Color borderColor = Colors.grey,
  }) {
    return SgCard(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      color: color,
      borderRadius: borderRadius,
      onTap: onTap,
      elevation: 0,
      border: Border.all(color: borderColor, width: 1),
      child: child,
    );
  }

  /// Creates a card with a gradient background.
  ///
  /// This factory creates a card with a gradient background. Useful for
  /// content that needs a visually striking container.
  factory SgCard.gradient({
    required Widget child,
    required Gradient gradient,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    double borderRadius = 8.0,
    VoidCallback? onTap,
  }) {
    return SgCard(
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      borderRadius: borderRadius,
      onTap: onTap,
      gradient: gradient,
      child: child,
    );
  }
}
