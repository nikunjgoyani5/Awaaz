import 'package:flutter/material.dart';

class NavigatorRoute {
  static navigateTo(BuildContext context, String page,
      {Map<String, dynamic>? args}) async {
    await Navigator.pushNamed(context, page, arguments: args);
  }

  static navigateBack(BuildContext context) async {
    Navigator.pop(context);
  }

  static navigateToRemoveUntil(BuildContext context, String page,
      {Map<String, dynamic>? args}) async {
    await Navigator.pushNamedAndRemoveUntil(context, page, (route) => false,
        arguments: args);
  }

  static navigateToReplacement(BuildContext context, String page,
      {Map<String, dynamic>? args}) async {
    await Navigator.pushReplacementNamed(context, page, arguments: args);
  }
}
