// import 'dart:developer';
//
// import 'package:eagle_eye_admin/route/navigator_route.dart';
// import 'package:eagle_eye_admin/theme/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:toastification/toastification.dart';
//
//
// showToast(
//     {required BuildContext context,
//     required String title,
//     required String message,
//     Color? bgColor,
//     TextStyle? titleStyle,
//     TextStyle? messageStyle}) {
//   return toastification.show(
//     context: context,
//     type: ToastificationType.success,
//     style: ToastificationStyle.flat,
//     autoCloseDuration: const Duration(seconds: 5),
//     title: Text(title, style: titleStyle),
//     description: RichText(text: TextSpan(text: message, style: messageStyle)),
//     alignment: Alignment.topRight,
//     direction: TextDirection.ltr,
//     icon:bgColor== AppColors.red ?const Icon(Icons.close): const Icon(Icons.check),
//     showIcon: true, // show or hide the icon
//     primaryColor: bgColor,
//     backgroundColor: Colors.white,
//     foregroundColor: Colors.black,
//     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
//     margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//     borderRadius: BorderRadius.circular(12),
//     boxShadow: const [
//       BoxShadow(
//         color: Color(0x07000000),
//         blurRadius: 16,
//         offset: Offset(0, 16),
//         spreadRadius: 0,
//       )
//     ],
//     showProgressBar: true,
//     closeButtonShowType: CloseButtonShowType.onHover,
//     closeOnClick: true,
//     pauseOnHover: true,
//     dragToClose: true,
//     applyBlurEffect: true,
//
//     callbacks: ToastificationCallbacks(
//       onTap: (toastItem) => log('Toast ${toastItem.id} tapped'),
//       onCloseButtonTap: (toastItem) {
//         log('Toast ${toastItem.id} close button tapped');
//
//       }
//           ,
//       onAutoCompleteCompleted: (toastItem) =>
//           log('Toast ${toastItem.id} auto complete completed'),
//       onDismissed: (toastItem) => log('Toast ${toastItem.id} dismissed'),
//     ),
//   );
// }
import 'dart:developer';

import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

showToast({
  required BuildContext context,
  required String title,
  required String message,
  Color? bgColor,
  TextStyle? titleStyle,
  TextStyle? messageStyle,
}) {
  return toastification.show(
    context: context,
    type: ToastificationType.success,
    style: ToastificationStyle.flat,
    autoCloseDuration: const Duration(seconds: 5),
    title: Text(title, style: titleStyle),
    description: RichText(text: TextSpan(text: message, style: messageStyle)),
    alignment: Alignment.topRight,
    direction: TextDirection.ltr,
    icon: bgColor == AppColors.red
        ? const Icon(Icons.close)
        : const Icon(Icons.check),
    showIcon: true,
    primaryColor: bgColor,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(
        color: Color(0x07000000),
        blurRadius: 16,
        offset: Offset(0, 16),
        spreadRadius: 0,
      )
    ],
    showProgressBar: true,
    closeButtonShowType: CloseButtonShowType.onHover,
    closeOnClick:
    true,
    pauseOnHover: true,
    dragToClose: true,
    applyBlurEffect: true,
    callbacks:
    ToastificationCallbacks(
      onTap: (toastItem) => log('Toast ${toastItem.id} tapped'),

      onAutoCompleteCompleted: (toastItem) =>
          log('Toast ${toastItem.id} auto complete completed'),
      onDismissed: (toastItem) => log('Toast ${toastItem.id} dismissed'),
    ),
  );
}
