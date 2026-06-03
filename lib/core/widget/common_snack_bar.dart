import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/text_styles.dart';

SnackBar showCustomSnackBar(
    {required String message,
    Color? bgColor,
    TextStyle? titleStyle,
    TextStyle? messageStyle}) {
  return SnackBar(
    content: Center(
      child: Text(
        message,
        style: TextStyles.regular(16.sp),
      ),
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    backgroundColor: Colors.black87,
    margin: EdgeInsets.all(5),
    duration: Duration(seconds: 2),
  );
}
