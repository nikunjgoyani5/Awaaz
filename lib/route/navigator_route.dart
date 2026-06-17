// import 'package:get/get.dart';
//
// class NavigatorRoute {
//   static navigateTo(String page, {dynamic arguments}) async {
//     Get.toNamed(page,arguments: arguments);
//   }
//
//   static navigateBack(context: context) async {
//     NavigatorRoute.navigateBack(context:  context);
//   }
//
//   static navigateToRemoveUntil(String page) async {
//     Get.offAllNamed(page);
//   }
//
//   static navigateToReplacement(String page) async {
//     Get.offAndToNamed(page);
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class NavigatorRoute {
  static navigateTo(String page, BuildContext context,
      {dynamic arguments}) async {
    // Get.toNamed(page,arguments: arguments);
    context.push(page, extra: arguments);
  }

  static navigateBack({required BuildContext context}) async {
    // NavigatorRoute.navigateBack(context:  context);
    context.pop();
  }

  static navigateToRemoveUntil(String page, BuildContext context) async {
    // Get.offAllNamed(page);
    context.go(page);
  }

  static navigateToReplacement(String page) async {
    Get.offAndToNamed(page);
  }

  static navigateToSpecificPage(String page, BuildContext context) async {
    context.go(page);
  }
}
