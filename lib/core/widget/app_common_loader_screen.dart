import 'package:eagle_eye/core/widget/app_custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AppCommonLoaderScreen extends StatelessWidget {
  final bool inAsyncCall;
  final Widget child;
  final Widget? progressIndicator;

  const AppCommonLoaderScreen(
      {super.key, required this.inAsyncCall, required this.child, this.progressIndicator});

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: inAsyncCall,
      progressIndicator: progressIndicator ?? AppCustomLoader(),
      child: child,
    );
  }
}
