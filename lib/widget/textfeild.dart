import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class CommonTextField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? height;
  final int? maxLength;
  final int? maxLines;
  final String? topLabel;
  final bool? obscureText;
  final bool? readOnly;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onSubmitted;
final TextStyle? textStyle;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final Key? kKey;
  final TextEditingController? controller;
  final Color? fillColor;
  final Color? enableBorderColor;
  final String? kInitialValue;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;
  final Color? cursorColor;
 final FocusNode? focusNode;
 final Iterable<String>? autoHints;
 final TextInputAction? textInputAction;

  const CommonTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.height = 48.0,
    this.topLabel = "",
    this.obscureText = false,
    this.readOnly = false,
    this.onSaved,
    this.onTap,
    this.keyboardType,
    this.errorText,
    this.maxLength,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
    this.fillColor,
    this.enableBorderColor,
    this.kKey,
    required this.controller,
    this.kInitialValue, this.inputFormatters,
    this.onSubmitted,  this.focusNode, this.textStyle, this.cursorColor, this.autoHints, this.textInputAction
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (topLabel != null && topLabel!.isNotEmpty)
          Text(
            topLabel ?? '',
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: AppColors.white, fontWeight: FontWeight.w500),
          ),
        const Gap(8),
        TextFormField(

          textInputAction:textInputAction?? TextInputAction.next,

          autofillHints: autoHints??[],
          onFieldSubmitted: onSubmitted,
          inputFormatters: inputFormatters??[],
          readOnly: readOnly ?? false,
          initialValue: kInitialValue,
          controller: controller,
          key: kKey,
          keyboardType: keyboardType ?? TextInputType.text,
          onSaved: onSaved,
          maxLength: maxLength,
          maxLines: maxLines,
          onChanged: onChanged,
          onTap: onTap,
          validator: validator,
          obscureText: obscureText!,
          cursorColor: cursorColor??AppColors.white,
          style: textStyle??Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: AppColors.white),
          decoration: InputDecoration(
              fillColor: fillColor,
              filled: fillColor != null ? true : false,
              counter: const SizedBox.shrink(),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: enableBorderColor ?? AppColors.textFeildBorderColor,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: enableBorderColor ?? AppColors.textFeildBorderColor,
                  width: 1.5,
                ),
              ),
              errorStyle: const TextStyle(height: 0, color: AppColors.red),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.red,
                ),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.red,
                ),
              ),
              hintText: hintText,
              hintStyle: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: AppColors.grey929da9),
              errorText: errorText),
        )
      ],
    );
  }
}
