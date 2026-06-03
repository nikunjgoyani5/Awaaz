import 'package:eagle_eye/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/text_styles.dart';

class CommonRadioListTile extends StatelessWidget {
  final String title;
  final Function(int? value) onChanged;
  final int value;
  final TextStyle? textStyle;
  final int? groupValue;

  const CommonRadioListTile(
      {super.key,
      required this.title,
      required this.onChanged,
      required this.value,
      this.groupValue,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return RadioListTile<int>(
      contentPadding: EdgeInsets.zero,
      value: value,
      activeColor: AppColors.primaryColor,
      groupValue: groupValue,
      radioScaleFactor: 1,
      onChanged: (value) {
        onChanged(value);
      },
      title: Text(
        title,
        style: textStyle ??
            TextStyles.regular(20.sp, fontColor: AppColors.whiteColor),
      ),
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}
