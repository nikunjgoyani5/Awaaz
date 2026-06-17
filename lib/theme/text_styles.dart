import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  static TextStyle bold(
    double fontSize, {
    Color? fontColor,
  }) {
    return TextStyle(
      color: fontColor,
      fontSize: fontSize.sp,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle arvoBold(double fontSize,
      {Color? fontColor, TextDecoration? decoration, Color? decorationColor}) {
    return TextStyle(
        color: fontColor,
        fontSize: fontSize.sp,
        fontFamily: "Arvo",
        fontWeight: FontWeight.w600,
        decoration: decoration,
        decorationStyle: TextDecorationStyle.solid,
        decorationColor: decorationColor);
  }

  static TextStyle semiBold(double fontSize,
      {Color? fontColor, TextDecoration? decoration, Color? decorationColor}) {
    return TextStyle(
        color: fontColor,
        fontSize: fontSize.sp,
        fontFamily: "Poppins",
        fontWeight: FontWeight.w600,
        decoration: decoration,
        decorationStyle: TextDecorationStyle.solid,
        decorationColor: decorationColor);
  }

  static TextStyle medium(
    double fontSize, {
    Color? fontColor,
  }) {
    return TextStyle(
      color: fontColor,
      fontSize: fontSize.sp,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle regular(
    double fontSize, {
    Color? fontColor,
  }) {
    return TextStyle(
      color: fontColor,
      fontSize: fontSize.sp,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle light(
    double fontSize, {
    Color? fontColor,
  }) {
    return TextStyle(
      color: fontColor,
      fontSize: fontSize.sp,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w300,
    );
  }
}
