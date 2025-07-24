import 'package:flutter/material.dart';

class SGResponsive {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 650;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 650 &&
        MediaQuery.of(context).size.width < 1100;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1100;
  }

  static Widget buildResponsive({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    required Widget desktop,
  }) {
    if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  // Định nghĩa các margin và padding cho từng loại màn hình
  static double horizontalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return 120.0;
    } else if (isTablet(context)) {
      return 60.0;
    } else {
      return 20.0;
    }
  }

  static double verticalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return 80.0;
    } else if (isTablet(context)) {
      return 60.0;
    } else {
      return 40.0;
    }
  }

  // Kích thước của container content tối đa
  static double maxContentWidth = 1400;
} 