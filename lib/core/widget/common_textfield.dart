import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';
import '../theme/text_styles.dart';
import 'outline_input_border.dart';

class CommonTextFieldIos extends StatelessWidget {
  const CommonTextFieldIos({
    super.key,
    required this.hintText,
    required this.controller,
    this.maxLength /* = 50*/,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.onSubmitted,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.height,
    this.autofocus = false,
    this.readOnly = false,
    this.expands = false,
    this.radius,
    this.maxLines = 3,
    this.minLines = 1,
    this.focusNode,
    this.fillColor,
    this.onTap,
    this.errorBorderSide,
    this.focusedErrorBorderSide,
    this.textStyle,
  });

  final String hintText;
  final int? maxLength;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final double? height;
  final bool autofocus;
  final bool readOnly;
  final bool expands;
  final BorderRadius? radius;
  final int? maxLines;
  final int? minLines;
  final TextStyle? textStyle;
  final FocusNode? focusNode;
  final Color? fillColor;
  final void Function()? onTap;
  final BorderSide? errorBorderSide;
  final BorderSide? focusedErrorBorderSide;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 55.h,
      child: CupertinoTextField(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        // focusNode: focusNode,
        maxLength: maxLength,
        maxLines: maxLines,
        minLines: minLines,
        expands: expands,
        readOnly: readOnly,
        onTap: onTap,
        // autofocus: autofocus,
        inputFormatters: inputFormatters,
        // validator: validator,
        onChanged: onChanged,
        obscureText: obscureText,
        onSubmitted: onSubmitted,
        keyboardType: keyboardType,
        controller: controller,
        cursorColor: AppColors.blackColor,
        // textInputAction: TextInputAction.done,
        textAlignVertical: TextAlignVertical.center,
        style: textStyle ??
            TextStyles.medium(18.sp, fontColor: AppColors.blackColor),
        placeholder: hintText,
        placeholderStyle: TextStyles.medium(
          18.sp,
          fontColor: AppColors.textHintGrayColor,
        ),
        prefix: prefixIcon,
        suffix: suffixIcon,
        decoration: BoxDecoration(
          color: fillColor ?? AppColors.whiteColor,
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
    );
  }
}

class CommonTextField extends StatelessWidget {
  const CommonTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.onSubmitted,
    this.borderColor,
    this.textAlign,
    this.hintColor,
    this.contentPadding,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.height,
    this.autofocus = false,
    this.readOnly = false,
    this.expands = false,
    this.radius,
    this.cursorColor,
    this.maxLines = 3,
    this.minLines = 1,
    this.focusNode,
    this.fillColor,
    this.textColor,
    this.onTap,
    this.errorBorderSide,
    this.focusedErrorBorderSide,
    this.textStyle,
    this.hintTextStyle,
    this.prefixPadding,
  });

  final String hintText;
  final int? maxLength;
  final EdgeInsets? contentPadding;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final double? height;
  final bool autofocus;
  final bool readOnly;
  final bool expands;
  final BorderRadius? radius;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final int? minLines;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? hintColor;
  final Color? cursorColor;
  final Color? textColor;
  final Color? borderColor;
  final void Function()? onTap;
  final BorderSide? errorBorderSide;
  final BorderSide? focusedErrorBorderSide;
  final EdgeInsets? prefixPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 100),
      child: ClipRRect(
        borderRadius: radius ?? BorderRadius.circular(100),
        child: TextFormField(
          textAlign: textAlign ?? TextAlign.left,
          focusNode: focusNode,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          readOnly: readOnly,
          onTap: onTap,
          autofocus: autofocus,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          obscureText: obscureText,
          onFieldSubmitted: onSubmitted,
          keyboardType: keyboardType,
          controller: controller,
          cursorColor: cursorColor ?? AppColors.blackColor,
          cursorHeight: 19.h,
          textInputAction: TextInputAction.done,
          textAlignVertical: TextAlignVertical.center,
          style: textStyle ??
              TextStyles.medium(18.sp,
                  fontColor: textColor ?? AppColors.blackColor),
          decoration: InputDecoration(
            counterText: '',
            hintText: hintText,
            filled: true,
            fillColor: fillColor ?? AppColors.whiteColor,
            hintStyle: hintTextStyle ??
                TextStyles.medium(
                  16.sp,
                  fontColor: hintColor ?? AppColors.textHintGrayColor,
                ),

            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: prefixPadding ?? const EdgeInsets.only(left: 10),
                    child: prefixIcon,
                  )
                : null,
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: suffixIcon,
                  )
                : null,
            contentPadding: contentPadding,
            // contentPadding: const EdgeInsets.all(12),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class CommonCommentTextField extends StatelessWidget {
  const CommonCommentTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.onSubmitted,
    this.borderColor,
    this.textAlign,
    this.hintColor,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.height,
    this.autofocus = false,
    this.readOnly = false,
    this.expands = false,
    this.radius,
    this.cursorColor,
    this.maxLines = 3,
    this.minLines = 1,
    this.focusNode,
    this.fillColor,
    this.onTap,
    this.errorBorderSide,
    this.focusedErrorBorderSide,
    this.textStyle,
  });

  final String hintText;
  final int? maxLength;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final double? height;
  final bool autofocus;
  final bool readOnly;
  final bool expands;
  final BorderRadius? radius;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextStyle? textStyle;
  final int? minLines;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? hintColor;
  final Color? cursorColor;
  final Color? borderColor;
  final void Function()? onTap;
  final BorderSide? errorBorderSide;
  final BorderSide? focusedErrorBorderSide;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 100),
      child: ClipRRect(
        borderRadius: radius ?? BorderRadius.circular(100),
        child: TextFormField(
          textAlign: textAlign ?? TextAlign.left,
          focusNode: focusNode,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          readOnly: readOnly,
          onTap: onTap,
          autofocus: autofocus,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          obscureText: obscureText,
          onFieldSubmitted: onSubmitted,
          keyboardType: keyboardType,
          controller: controller,
          cursorColor: cursorColor ?? AppColors.blackColor,
          textInputAction: TextInputAction.done,
          textAlignVertical: TextAlignVertical.center,
          style: textStyle ??
              TextStyles.medium(18.sp, fontColor: AppColors.blackColor),
          decoration: InputDecoration(
            counterText: '',
            hintText: hintText,
            filled: true,
            fillColor: fillColor ?? AppColors.whiteColor,
            hintStyle: TextStyles.medium(
              16.sp,
              fontColor: hintColor ?? AppColors.textHintGrayColor,
            ),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            // contentPadding: EdgeInsets.only(bottom: 16.h, left: 20.w),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(7.r),
            //   borderSide: BorderSide(
            //     color: borderColor ?? const Color(0xffD8DDE3),
            //     width: 1,
            //   ),
            // ),
            // enabledBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(7.r),
            //   borderSide: BorderSide(
            //     color: borderColor ?? const Color(0xffD8DDE3),
            //     width: 1,
            //   ),
            // ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.r),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.commentTextFieldColor,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.r),
              borderSide: BorderSide(
                color: borderColor ?? AppColors.redColor,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.r),
              borderSide: const BorderSide(
                color: AppColors.redColor,
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CommonMainTextField extends StatelessWidget {
  const CommonMainTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.onSubmitted,
    this.borderColor,
    this.textAlign,
    this.hintColor,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.height,
    this.autofocus = false,
    this.readOnly = false,
    this.expands = false,
    this.radius,
    this.cursorColor,
    this.maxLines = 3,
    this.minLines = 1,
    this.focusNode,
    this.fillColor,
    this.onTap,
    this.errorBorderSide,
    this.focusedErrorBorderSide,
    this.textStyle,
    this.labelText,
    this.textFieldAlignment,
    this.textFieldPadding,
    this.textInputAction,
  });

  final String? labelText;
  final String hintText;
  final int? maxLength;
  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final double? height;
  final bool autofocus;
  final bool readOnly;
  final bool expands;
  final BorderRadius? radius;
  final TextAlign? textAlign;
  final Alignment? textFieldAlignment;
  final int? maxLines;
  final TextStyle? textStyle;
  final int? minLines;
  final FocusNode? focusNode;
  final Color? fillColor;
  final Color? hintColor;
  final Color? cursorColor;
  final Color? borderColor;
  final void Function()? onTap;
  final BorderSide? errorBorderSide;
  final BorderSide? focusedErrorBorderSide;
  final EdgeInsetsGeometry? textFieldPadding;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    /*return Container(
      height: height ?? 75.h,
      decoration: BoxDecoration(
          borderRadius: radius ?? BorderRadius.circular(10),
          color: fillColor ?? AppColors.actionBtnBgColor),
      alignment: textFieldAlignment ?? Alignment.center,
      child: Padding(
        padding: textFieldPadding ?? EdgeInsets.zero,
        child: TextFormField(
          textAlign: textAlign ?? TextAlign.left,
          focusNode: focusNode,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          readOnly: readOnly,
          onTap: onTap,
          autofocus: autofocus,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          obscureText: obscureText,
          onFieldSubmitted: onSubmitted,
          keyboardType: keyboardType,
          controller: controller,
          cursorColor: cursorColor ?? AppColors.whiteColor,
          cursorHeight: 19.h,
          textInputAction: TextInputAction.done,
          textAlignVertical: TextAlignVertical.center,
          style: textStyle ??
              TextStyles.medium(20.sp, fontColor: AppColors.textWhiteColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor ?? AppColors.actionBtnBgColor,
            contentPadding: EdgeInsets.only(left: 20.w, bottom: 6.h),
            hintText: hintText,
            labelText: labelText,
            labelStyle: TextStyles.regular(18.sp,
                fontColor: AppColors.textHintGrayColor),
            hintStyle: TextStyles.medium(
              20.sp,
              fontColor: hintColor ?? AppColors.textHintGrayColor,
            ),
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: suffixIcon,
                  )
                : null,
            border: OutlineInputBorder(
                borderRadius: radius ?? BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlineInputBorder(
                borderRadius: radius ?? BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(
                borderRadius: radius ?? BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.transparent)),
          ),
        ),
      ),
    );*/
    return Container(
      // height: height ?? 60.h,
      decoration: BoxDecoration(
        color: fillColor ?? AppColors.actionBtnBgColor,
        borderRadius: radius ?? BorderRadius.circular(10.r),
      ),
      // constraints: const BoxConstraints(maxHeight: 100),
      alignment: Alignment.topCenter,
      child: Padding(
        padding: textFieldPadding ?? EdgeInsets.zero,
        child: TextFormField(
          textAlign: textAlign ?? TextAlign.left,
          focusNode: focusNode,
          maxLength: maxLength,
          maxLines: maxLines,
          minLines: minLines,
          expands: expands,
          readOnly: readOnly,
          onTap: onTap,
          autofocus: autofocus,
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: onChanged,
          obscureText: obscureText,
          onFieldSubmitted: onSubmitted,
          keyboardType: keyboardType,
          controller: controller,
          cursorColor: cursorColor ?? AppColors.whiteColor,
          cursorHeight: 18.h,
          textInputAction: textInputAction ?? TextInputAction.done,
          textAlignVertical: TextAlignVertical.top,
          style: textStyle ??
              TextStyles.medium(18.sp, fontColor: AppColors.textWhiteColor),
          decoration: InputDecoration(
            prefixIcon: prefixIcon,

            filled: true,
            fillColor: fillColor ?? AppColors.actionBtnBgColor,
            // contentPadding: EdgeInsets.only(left: 20.w, bottom: 6.h),
            hintText: hintText,
            labelText: labelText,
            labelStyle: TextStyles.regular(16.sp,
                fontColor: AppColors.textHintGrayColor),
            hintStyle: TextStyles.medium(
              18.sp,
              fontColor: hintColor ?? AppColors.textHintGrayColor,
            ),
            suffixIcon: suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: suffixIcon,
                  )
                : null,
            border: OutlinedInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            focusedBorder: OutlinedInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
            enabledBorder: OutlinedInputBorder(
                borderSide: BorderSide(color: Colors.transparent)),
          ),
        ),
      ),
    );
  }
}
