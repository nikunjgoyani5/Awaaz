import 'dart:developer';
import 'dart:io';

import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../core/theme/colors.dart';
import '../core/theme/text_styles.dart';
import '../core/utils/app_functions.dart';

export 'dart:io' show Platform, File;

enum PickerMode { file, gallery, camera }

class FileService {
  static Future<PermissionStatus?> storagePermission() async {
    try {
      PermissionStatus status = await Permission.storage.request();
      return status;
    } catch (e) {
      log('STORAGE PERMISSION ERROR == $e');
    }
    return null;
  }

  static Future<String?> pickFile(PickerMode pickerMode) async {
    try {
      if (pickerMode == PickerMode.file) {
        PermissionStatus? status = await storagePermission();
        if (status!.isGranted) {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.image,
            compressionQuality: 100,

          );

          if (result != null) {
            File file = File(result.files.single.path!);
            int sizeInBytes = await file.length();
            double sizeInMB = sizeInBytes / (1024 * 1024);
            if (sizeInMB > 50) {
              AppFunctions.showToast(
                  'Size should not exceed 50MB. Please try again.');
            } else {
              return file.path;
            }
          }
          return null;
        } else {
          return null;
        }
      }

      final ImagePicker picker = ImagePicker();
      XFile? image;
      if (pickerMode == PickerMode.gallery) {
        image = await picker.pickImage(source: ImageSource.gallery);
      } else if (pickerMode == PickerMode.camera) {
        image = await picker.pickImage(source: ImageSource.camera);
      }
      if (image != null) {
        return image.path;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({
    super.key,
    required this.callback,
  });

  final Function(PickerMode) callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.sp, top: 20.h),
          child: Text(
            'Choose Photo!',
            style: TextStyles.semiBold(25.sp, fontColor: AppColors.whiteColor),
          ),
        ),
        spaceH(20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => callback(PickerMode.gallery),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(
                        Icons.add_photo_alternate,
                        color: AppColors.textWhiteColor,
                      ),
                    ),
                  ),
                  spaceH(10.h),
                  Text(
                    'From Gallery',
                    style: TextStyles.semiBold(16.sp),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () => callback(PickerMode.camera),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primaryColor,
                      child: Icon(
                        Icons.add_a_photo,
                        color: AppColors.textWhiteColor,
                      ),
                    ),
                  ),
                  spaceH(10.h),
                  Text(
                    'From Camera',
                    style: TextStyles.semiBold(16.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
        spaceH(30.h),
      ],
    );
  }
}

/*class FilePickerBottomSheet extends StatelessWidget {
  final bool? isBusinessImage;

  const FilePickerBottomSheet(
      {super.key, required this.callback, this.isBusinessImage = false});

  final Function(PickerMode) callback;

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Photo!',
            style: TextStyles.semiBold(25.sp, fontColor: AppColors.black),
          ).paddingOnly(left: 15.sp),
          Gap(20.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => callback(PickerMode.file),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.green,
                        child: Icon(
                          Icons.attach_file,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Text(
                      'From File',
                      style: TextStyles.semiBold(16.sp),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => callback(PickerMode.gallery),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.green,
                        child: Icon(
                          Icons.add_photo_alternate,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Text(
                      'From Gallery',
                      style: TextStyles.semiBold(16.sp),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => callback(PickerMode.camera),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.green,
                        child: Icon(
                          Icons.add_a_photo,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Text(
                      'From Camera',
                      style: TextStyles.semiBold(16.sp),
                    ),
                  ],
                ),
              ),
              (isBusinessImage == true &&
                      appController.selectedBusiness?.logo != null)
                  ? Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {
                              Get.back();
                              Get.back();
                              SettingsPageController settingController =
                                  Get.find();
                              await settingController.removeBusinessImage();
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.green,
                              child: Icon(
                                Icons.delete,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          const Gap(10),
                          Text(
                            'Remove',
                            style: TextStyles.semiBold(16.sp),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Gap(30.sp),
        ],
      ),
    );

    /// ORIGINAL
    // return Container(
    //   width: double.infinity,
    //   decoration: BoxDecoration(
    //     color: AppColors.white,
    //     borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
    //   ),
    //   child: Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Gap(4.sp),
    //       Container(
    //         height: 4,
    //         width: 80,
    //         decoration: BoxDecoration(
    //             color: AppColors.grey929da9,
    //             borderRadius: BorderRadius.circular(50)),
    //       ),
    //       Gap(20.sp),
    //       Text(
    //         'Choose Photo!',
    //         style: TextStyles.bold(20.sp),
    //       ),
    //       Gap(20.sp),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Expanded(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 InkWell(
    //                   onTap: () => callback(PickerMode.file),
    //                   child:  CircleAvatar(
    //                     radius: 20,
    //                     backgroundColor: AppColors().dynamicThemeColor,
    //                     child: Icon(
    //                       Icons.attach_file,
    //                       color: AppColors.white,
    //                     ),
    //                   ),
    //                 ),
    //                  Gap(10),
    //                 Text(
    //                   'From File',
    //                   style: TextStyles.semiBold(16.sp),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Expanded(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 InkWell(
    //                   onTap: () => callback(PickerMode.gallery),
    //                   child:  CircleAvatar(
    //                     radius: 20,
    //                     backgroundColor: AppColors().dynamicThemeColor,
    //                     child: Icon(
    //                       Icons.add_photo_alternate,
    //                       color: AppColors.white,
    //                     ),
    //                   ),
    //                 ),
    //                  Gap(10),
    //                 Text(
    //                   'From Gallery',
    //                   style: TextStyles.semiBold(16.sp),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Expanded(
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 InkWell(
    //                   onTap: () => callback(PickerMode.camera),
    //                   child:  CircleAvatar(
    //                     radius: 20,
    //                     backgroundColor: AppColors().dynamicThemeColor,
    //                     child: Icon(
    //                       Icons.add_a_photo,
    //                       color: AppColors.white,
    //                     ),
    //                   ),
    //                 ),
    //                  Gap(10),
    //                 Text(
    //                   'From Camera',
    //                   style: TextStyles.semiBold(16.sp),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //       Gap(30.sp)
    //     ],
    //   ),
    // );
  }
}*/
