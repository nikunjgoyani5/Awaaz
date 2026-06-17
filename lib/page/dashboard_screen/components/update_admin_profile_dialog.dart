import 'dart:io';

import 'package:eagle_eye_admin/controller/dashboard_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class UpdateAdminProfileDialog extends StatefulWidget {
  const UpdateAdminProfileDialog({super.key});

  @override
  State<UpdateAdminProfileDialog> createState() =>
      _UpdateAdminProfileDialogState();
}

class _UpdateAdminProfileDialogState extends State<UpdateAdminProfileDialog> {
  DashboardController controller = Get.put(DashboardController());

  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    DashboardController controller = Get.find();
    controller.adminNameController.text = StorageService.getName() ?? '';
  }

  bool isHovered = false;

  GlobalKey<FormState> profileKey = GlobalKey();
  Widget buildImage() {
    if (kIsWeb) {
      if (controller.selectedImageOrVideo != null) {
        return Image.memory(
          controller.selectedImageOrVideoBytes!,
          fit: BoxFit.fill,
        );
      }
      return Image.network(
        'https://via.placeholder.com/150',
        fit: BoxFit.fill,
      );
    } else {
      if (controller.selectedImageOrVideo != null) {
        return Image.file(
          File(controller.selectedImageOrVideo!.path),
          fit: BoxFit.fill,
        );
      }
      return Container(
        color: Colors.grey,
        child: const Center(
          child: Text(
            'No Image Available',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return GetBuilder<DashboardController>(builder: (controller) {
      return Dialog(
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.only(top: 40.h, bottom: 40.h),
        backgroundColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: StatefulBuilder(
          builder: (con, update) {
            return Container(
              height: 500,
              width: 500,
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              decoration: BoxDecoration(
                color: AppColors.borderColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: profileKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            NavigatorRoute.navigateBack(context: context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    Gap(20.h),
                    Expanded(
                      child: (controller.selectedImageOrVideo != null)
                          ? MouseRegion(
                              onHover: (_) => setState(() => isHovered = true),
                              onExit: (_) => setState(() => isHovered = false),
                              child: Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: buildImage()),
                                  ),
                                  if (isHovered)
                                    Positioned.fill(
                                      child: InkWell(
                                        onTap: () {
                                          controller.selectedFile = null;
                                          controller.selectedImageOrVideo =
                                              null;
                                          controller.update();
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withValues(alpha: 0.6),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.delete,
                                                    color: Colors.red),
                                                Gap(5.w),
                                                const Text(
                                                  'Remove File',
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : InkWell(
                              borderRadius: BorderRadius.circular(8.r),
                              onTap: () async {
                                await controller.openVideoOrImageDailoge(
                                    context: context);
                                // controller.selectedFile =
                                //     await controller.pickFile();
                                // controller.update();
                              },
                              child: Container(
                                height: 200.h,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: AppColors.attachCardColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 20.h),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Assets.icons.icAttachFile.svg(
                                        height: 45.h,
                                        width: 45.w,
                                      ),
                                      Gap(10.w),
                                      Text(
                                        'Attach Video/Image',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: AppColors.white,
                                                fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                    Gap(15.h),
                    CommonTextField(
                      topLabel: "Name",
                      hintText: "Enter name",
                      controller: controller.adminNameController,
                      validator: (p0) {
                        if (p0 == null || p0.trim().isEmpty) {
                          controller.adminNameController.clear();
                          return "Name is required";
                        }
                        return null;
                      },
                    ),
                    Gap(25.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 170.w,
                          height: 50.h,
                          child: CommonButton(
                            color: Colors.white,
                            radius: 5,
                            widget: Text(
                              "Update Profile",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                            ),
                            onPressed: () async {
                              if (profileKey.currentState?.validate() ??
                                  false) {
                                await controller.updateAdminProfile(
                                    context, pl);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    Gap(10.h),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
