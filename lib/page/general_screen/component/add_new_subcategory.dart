import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/controller/general_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/dailoges.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddNewSubCategory extends StatefulWidget {
  const AddNewSubCategory({super.key});

  @override
  State<AddNewSubCategory> createState() => _AddNewSubCategoryState();
}

class _AddNewSubCategoryState extends State<AddNewSubCategory> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.only(top: 40.h, bottom: 40.h),
      backgroundColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: GetBuilder<GeneralController>(builder: (controller) {
        return StatefulBuilder(
          builder: (con, update) {
            return  Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Form(
                key: controller.subCategoryFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Create Sub Category",
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.w600, color: AppColors.white),
                        ),
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
                    Text(
                      'Sub Category Icon',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w500),
                    ),
                    Gap(10.h),
                    (controller.subCategoryIconBytes != null)
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
                                controller.subCategoryIconBytes!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (isHovered)
                            Positioned.fill(
                              child: InkWell(
                                onTap: () {
                                  controller.subCategoryIcon = null;
                                  controller.subCategoryIconBytes = null;
                                  controller.update();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
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
                        showDialog(
                          context: context,
                          builder: (context) {
                            return PhotoOrVideoOptionDailoge(
                              isVideoHide: true,
                              onPhotoTap: () async {
                                controller.subCategoryIcon =
                                await controller.pickMedia(MediaType.image);
                                controller.subCategoryIconBytes = await controller
                                    .subCategoryIcon!
                                    .readAsBytes();

                                controller.update();
                                setState(() {

                                });
                                NavigatorRoute.navigateBack(context: context);
                              },
                            );
                          },
                        );
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
                    Gap(20.h),
                    Text(
                      'Sub Category Name',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.white, fontWeight: FontWeight.w500),
                    ),
                    Gap(10.h),
                    CommonTextField(
                        hintText: 'Enter Sub Category Name',
                        validator: (value) {
                          if(value!.isEmpty){
                            return 'Please enter sub category name !';
                          }
                          return null;
                        },
                        controller: controller.subCategoryNameController),
                    Gap(20.h),


                    Row(
                      children: [
                        const Spacer(),
                        SizedBox(
                          width: 135.w,
                          height: 40.h,
                          child: CommonButton(
                            color: AppColors.green,
                            radius: 5,
                            widget: Text(
                              'Create',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () async {
                              await controller.createSubCategory(
                                  context, pl);

                              controller.update();
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
