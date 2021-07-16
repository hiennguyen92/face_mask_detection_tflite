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
  static TextStyle regularTextStyle(
          {double? fontSize, Color? color, double? height}) =>
      TextStyle(
          fontFamily: AppFonts.fontFamily,
          fontWeight: FontWeight.w300,
          fontSize: fontSize ?? 14,
          color: color ?? Colors.black,
          height: height);

  // Font medium
  static TextStyle mediumTextStyle({double? fontSize, Color? color, double? height}) =>
      TextStyle(
          fontFamily: AppFonts.fontFamily,
          fontWeight: FontWeight.w500,
          fontSize: fontSize ?? 14,
          color: color ?? Colors.black,
          height: height);

  // Font bold
  static TextStyle boldTextStyle({double? fontSize, Color? color, double? height}) =>
      TextStyle(
          fontFamily: AppFonts.fontFamily,
          fontWeight: FontWeight.w700,
          fontSize: fontSize ?? 14,
          color: color ?? Colors.black,
          height: height);
}

class AppColors {
  static const Color white = Colors.white;
  static const Color red = Colors.red;
  static const Color yellow = Colors.yellow;
  static const Color green = Colors.green;
  static const Color black = Colors.black;
  static const Color yellowAccent = Colors.yellowAccent;
  static const Color transparent = Colors.transparent;
  static const Color greenAccent = Colors.greenAccent;
}

class AppImages {
  static const String illustrator = "assets/images/illustrator.jpg";
}

class AppStrings {
  static const String withMask = "with_mask";
  static const String withoutMask = "without_mask";
  static const String labelString = "label";
  static const String confidenceString = "confidence";
  static const String dontShake = "Don\'t Shake your mobile";
  static const String wearingMask = "Wearing mask";
  static const String noMask = "No mask";
  static const String pickIFG = "Pick Image from gallery";
  static const String selectImageP = "Select an Image to Show Preview";
  static const String gilroy = "Gilroy";
  static const String noCamera = 'Looks like there are no cameras';
  static const String codeString = "Code";
  static const String liveCamera = "Live Camera";
  static const String title = 'Face Mask Detection';
  static const String fromGallery = "From Gallery";

  static const String urlString = "https://github.com/hiennguyen92/face_mask_detection_tflite";
}
