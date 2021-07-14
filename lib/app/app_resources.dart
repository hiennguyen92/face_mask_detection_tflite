import 'package:flutter/material.dart';

class AppIcons {
  static const IconData exit = Icons.exit_to_app;
  static const IconData cameraFront = Icons.camera_front;
  static const IconData cameraRear = Icons.camera_rear;
  static const IconData code = Icons.code;
  static const IconData imageIcon = Icons.image;
}

class AppFonts {
  static String fontFamily = 'Roboto';
}

class AppTextStyles {
  // Font regular
  TextStyle regularTextStyle(
          {double? fontSize, Color? color, double? height}) =>
      TextStyle(
          fontFamily: AppFonts.fontFamily,
          fontWeight: FontWeight.w300,
          fontSize: fontSize ?? 14,
          color: color ?? Colors.black,
          height: height);

  // Font medium
  TextStyle mediumTextStyle({double? fontSize, Color? color, double? height}) =>
      TextStyle(
          fontFamily: AppFonts.fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: fontSize ?? 14,
          color: color ?? Colors.black,
          height: height);

  // Font bold
  TextStyle boldTextStyle({double? fontSize, Color? color, double? height}) =>
      TextStyle(
          fontFamily: AppFonts.fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: fontSize ?? 14,
          color: color ?? Colors.black,
          height: height);
}
