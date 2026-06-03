import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    this.onPressed,
    required this.widget,
    this.radius,
    this.color,
    this.width,
    this.height,
  });

  final VoidCallback? onPressed;
  final Widget widget;
  final double? radius;
  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 100.r)),
        backgroundColor: color ?? AppColors.primaryColor,
        elevation: 0,
        padding: EdgeInsets.zero,
        minimumSize: Size(
          width ?? MediaQuery.of(context).size.width,
          height ?? 55.sp,
        ),
        fixedSize: Size(
          width ?? MediaQuery.of(context).size.width,
          height ?? 55.sp,
        ),
      ),
      onPressed: onPressed != null
          ? () {
              HapticFeedback.lightImpact();
              onPressed!();
            }
          : null,
      child: widget,
    );
  }
}
