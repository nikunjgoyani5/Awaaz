import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget widget;

  const CommonTextButton({super.key, this.onPressed, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed != null
            ? () {
                HapticFeedback.lightImpact();
                onPressed!();
              }
            : null,
        child: widget);
  }
}
