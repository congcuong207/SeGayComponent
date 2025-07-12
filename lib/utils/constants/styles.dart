import 'package:flutter/material.dart';
import 'package:se_gay_components/utils/constants/colors.dart';

abstract class AppStyles {
  static String FONT_FAMILY_LATO = 'lato';
  static String FONT_FAMILY_BOLD = 'RobotoBold';
  static String FONT_FAMILY_LIGHT = 'RobotoLight';

  //TEXT_STYLE
  static TextStyle defaultTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: ColorValues.blackColor,
    fontFamily: FONT_FAMILY_LATO,
  );

  static TextStyle defaultTextStyleBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: ColorValues.blackColor,
    fontFamily: FONT_FAMILY_LATO,
  );

  static TextStyle titleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: ColorValues.blackColor,
    fontFamily: FONT_FAMILY_LATO,
  );

  static TextStyle tablePriceTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: ColorValues.blackColor,
    fontFamily: FONT_FAMILY_LATO,
  );

  static TextStyle errorTextStyle = TextStyle(
    fontSize: 14,
    color: ColorValues.errorColor,
    fontWeight: FontWeight.w500,
    fontFamily: FONT_FAMILY_LATO,
  );
  static TextStyle buttonTextStyle = TextStyle(
    fontSize: 14,
    color: ColorValues.blackColor,
    fontWeight: FontWeight.w500,
    fontFamily: FONT_FAMILY_LATO,
  );

  static TextStyle appNameTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: ColorValues.color1890FF,
    fontFamily: FONT_FAMILY_LATO
  );
}
