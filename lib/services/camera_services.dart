import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/utils/app_functions.dart';
import '../core/widget/common_alert_dialogue.dart';

class CameraService {
  static late List<CameraDescription> cameras;

  static Future<void> initializeCameras() async {
    cameras = await availableCameras();
  }

  static Future requestCameraPermission(BuildContext context) async {
    await Permission.camera.request();
    var status = await Permission.camera.status;
    if (status.isDenied) {
      log('Camera permission denied');
      await Permission.locationWhenInUse.request();
    } else if (status.isPermanentlyDenied) {
      log('Camera permission permanently denied');
      showAppDialog(
          dismissDialog: false,
          context,
          CommonAlertDialogue(
              dialogWidget: AppPermissionDialog(
            showCancelButton: true,
            title: 'Camera permission permanently denied',
            message:
                'Your device Camera permission permanently denied.\n To use this feature you need to give permission.',
          )));
    }
  }
}
