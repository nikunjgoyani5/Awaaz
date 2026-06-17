
import 'package:eagle_eye_admin/controller/event_detail_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EventAttachFileDailoge extends StatefulWidget {
  const EventAttachFileDailoge({super.key});

  @override
  State<EventAttachFileDailoge> createState() => _EventAttachFileDailogeState();
}

class _EventAttachFileDailogeState extends State<EventAttachFileDailoge> {
  bool isHovered = false;
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return GetBuilder<EventDetailController>(builder: (controller) {
      return Dialog(
        key: key,
        alignment: Alignment.topCenter,
        insetPadding: EdgeInsets.only(top: 40.h),
        backgroundColor: AppColors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 1536
                ? MediaQuery.of(context).size.width * 0.30
                : MediaQuery.of(context).size.width > 1024
                    ? MediaQuery.of(context).size.width * 0.30
                    : MediaQuery.of(context).size.width > 600
                        ? MediaQuery.of(context).size.width * 0.2
                        : MediaQuery.of(context).size.width * 0.1,
          ),
          decoration: BoxDecoration(
            color: AppColors.borderColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    "Upload Media",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.white, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      NavigatorRoute.navigateBack(context: context);
                    },
                  )
                ],
              ),
              Gap(30.h),


              (controller.uploadedFileBytes != null)
                  ? MouseRegion(
                      onHover: (_) => setState(() => isHovered = true),
                      onExit: (_) => setState(() => isHovered = false),
                      child: Stack(
                        children: [
                          Container(
                            height: 280.h,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.memory(
                                controller.uploadedFileBytes!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (isHovered)
                            Positioned.fill(
                              child: InkWell(
                                onTap: () {
                                  controller.uploadedFile = null;
                                  controller.uploadedFileBytes = null;
                                  controller.update();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha:0.6),
                                    borderRadius: BorderRadius.circular(8),
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
                        controller.openAttachFileDialogBox(context);

                      },
                      child: Container(
                        height: 280.h,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Assets.icons.icAttachFile.svg(
                                height: 45.h,
                                width: 45.w,
                              ),
                              Gap(10.w),
                              Text(
                                'Attach File',
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
              Gap(30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      child: Row(
                        children: [
                          Checkbox(
                            checkColor: AppColors.white,
                            activeColor: AppColors.blue,
                            value: controller.uploadFileCheckBox,
                            onChanged: (value) {
                              setState(() {
                                controller.uploadFileCheckBox =
                                    value ?? false;
                              });
                              controller.update();
                            },
                          ),
                          Gap(10.w),
                          Text(
                            "Sensitive Content",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall!
                                .copyWith(
                                color: AppColors.white,
                                fontWeight:
                                FontWeight.w500),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 50.h,
                    width: 150.w,
                    child: CommonButton(
                      color: AppColors.green,
                      radius: 5.r,
                      onPressed: () {

                        controller.uploadPostFilesAPI(pl, context);

                      },
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Attach File",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              Gap(15.h),
            ],
          ),
        ),
      );
    });
  }
}
