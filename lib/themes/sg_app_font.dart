import 'package:flutter/material.dart';
import '../common/sg_colors.dart';

class SGAppFont {
  SGAppFont._();
  
  // Font sizes
  static const double headline1Size = 32.0;
  static const double headline2Size = 24.0;
  static const double headline3Size = 20.0;
  static const double headline4Size = 18.0;
  static const double headline5Size = 16.0;
  static const double headline6Size = 14.0;
  static const double bodyLargeSize = 16.0;
  static const double bodyMediumSize = 14.0;
  static const double bodySmallSize = 12.0;
  static const double captionSize = 10.0;
  
  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  
  // Line heights
  static const double tightLineHeight = 1.2;
  static const double normalLineHeight = 1.5;
  static const double looseLineHeight = 1.8;
  
  // Headings
  static TextStyle headline1({
    Color color = SGAppColors.neutral800,
    FontWeight fontWeight = bold,
    double height = tightLineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: headline1Size,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
  
  static TextStyle headline2({
    Color color = SGAppColors.neutral800,
    FontWeight fontWeight = bold,
    double height = tightLineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: headline2Size,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
  
  static TextStyle headline3({
    Color color = SGAppColors.neutral800,
    FontWeight fontWeight = semiBold,
    double height = tightLineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: headline3Size,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
  
  static TextStyle headline4({
    Color color = SGAppColors.neutral800,
    FontWeight fontWeight = semiBold,
    double height = tightLineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: headline4Size,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
  
  static TextStyle headline5({
    Color color = SGAppColors.neutral800,
    FontWeight fontWeight = medium,
    double height = tightLineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: headline5Size,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
  
  static TextStyle headline6({
    Color color = SGAppColors.neutral800,
    FontWeight fontWeight = medium,
    double height = tightLineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: headline6Size,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
  
  // Body styles
  static TextStyle bodyLarge({
    Color color = SGAppColors.neutral700,
    FontWeight fontWeight = regular,
    double height = normalLineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: bodyLargeSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
  
  static TextStyle bodyMedium({
    Color color = SGAppColors.neutral700,
    FontWeight fontWeight = regular,
    double height = normalLineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: bodyMediumSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
  
  static TextStyle bodySmall({
    Color color = SGAppColors.neutral700,
    FontWeight fontWeight = regular,
    double height = normalLineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: bodySmallSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
  
  // Other styles
  static TextStyle caption({
    Color color = SGAppColors.neutral600,
    FontWeight fontWeight = regular,
    double height = normalLineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: captionSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
  
  // Button text styles
  static TextStyle buttonLarge({
    Color color = SGAppColors.neutral0,
    FontWeight fontWeight = semiBold,
    double height = normalLineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: bodyLargeSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
  
  static TextStyle buttonMedium({
    Color color = SGAppColors.neutral0,
    FontWeight fontWeight = semiBold,
    double height = normalLineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: bodyMediumSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
  
  static TextStyle buttonSmall({
    Color color = SGAppColors.neutral0,
    FontWeight fontWeight = medium,
    double height = normalLineHeight,
    TextDecoration? decoration,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: bodySmallSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
  
  // Link text styles
  static TextStyle link({
    Color color = SGAppColors.primary600,
    FontWeight fontWeight = medium,
    double fontSize = bodyMediumSize,
    double height = normalLineHeight,
    TextDecoration decoration = TextDecoration.underline,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      fontStyle: fontStyle,
    );
  }
}
