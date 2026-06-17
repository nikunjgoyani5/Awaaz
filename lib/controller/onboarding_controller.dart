import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  final TextEditingController adminNameController = TextEditingController();
  final TextEditingController adminPhoneController = TextEditingController();
  String? adminProfileFileName;
  Uint8List? adminProfileFile;
  final formKey = GlobalKey<FormState>();

  Future<Uint8List?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'mp4', 'avi', 'mov'],
    );

    if (result != null) {
      Uint8List? fileBytes = result.files.single.bytes;
      String? fileName = result.files.single.name;
      log("File selected: $fileName");
      update();
      return fileBytes;
    } else {
      log("No file selected.");
    }
    return null;
  }
}
