import 'package:eagle_eye/core/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';

class AppPopupMenuButton extends StatelessWidget {
  final List<PopupMenuItem> popupMenuItems;
  final Color? bgColor;
  final Function()? onOpened;
  const AppPopupMenuButton(
      {super.key, required this.popupMenuItems, this.bgColor, this.onOpened});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: bgColor ?? AppColors.blackColor,
      itemBuilder: (context) {
        return popupMenuItems;
      },
      onOpened: onOpened!,
      child: InkWell(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Assets.icons.icMenu.svg(height: 20, width: 20),
      )),
    );
  }
}
