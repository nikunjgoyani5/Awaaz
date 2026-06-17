import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    this.onPressed,
    required this.widget,
    this.radius,
    this.color,
  });

  final VoidCallback? onPressed;
  final Widget widget;
  final double? radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 50.r)),
        backgroundColor: color ?? AppColors.white,
        elevation: 0,
        padding: EdgeInsets.zero,
        fixedSize: const Size(double.maxFinite, 50),
      ),
      onPressed: onPressed != null
          ? () {
              onPressed!();
            }
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget,
        ],
      ),
    );
  }
}

class CommonBorderButton extends StatelessWidget {
  const CommonBorderButton({
    super.key,
    this.onPressed,
    required this.widget,
    this.radius,
    this.color,
    this.borderColor,
  });

  final VoidCallback? onPressed;
  final Widget widget;
  final double? radius;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
            side: BorderSide(
              color: borderColor ?? AppColors.textFeildBorderColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(radius ?? 50.r)),
        backgroundColor: color ?? AppColors.black,
        elevation: 0,
        padding: EdgeInsets.zero,
        fixedSize: const Size(double.infinity, 50),
      ),
      onPressed: onPressed != null
          ? () {
              onPressed!();
            }
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget,
        ],
      ),
    );
  }
}
