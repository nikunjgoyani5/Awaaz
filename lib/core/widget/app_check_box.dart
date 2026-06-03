import 'package:flutter/material.dart';

import '../theme/colors.dart';

class AppCheckBox extends StatefulWidget {
  final bool isChecked;
  final Color? borderColor;
  final Function(bool?)? onChanged;

  const AppCheckBox(
      {super.key, required this.isChecked, this.borderColor, this.onChanged});

  @override
  State<AppCheckBox> createState() => _AppCheckBoxState();
}

class _AppCheckBoxState extends State<AppCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        }
        return null;
      }),
      side: BorderSide(
        color: widget.borderColor ?? AppColors.whiteColor,
        width: 0.83,
      ),
      value: widget.isChecked,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!.call(value);
        }
      },
    );
  }
}
