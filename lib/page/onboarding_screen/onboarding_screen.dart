
import 'package:eagle_eye_admin/controller/onboarding_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      builder: (controller) {
        return Scaffold(
          body: Form(
            key: controller.formKey,
            child: Stack(
              children: [
                Image.asset(Assets.image.mapBg.path),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gap(20.h),
                    Container(
                      padding: EdgeInsets.all(10.sp),
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width > 1536
                            ? MediaQuery.of(context).size.width * 0.36
                            : MediaQuery.of(context).size.width > 1024
                                ? MediaQuery.of(context).size.width * 0.30
                                : MediaQuery.of(context).size.width > 600
                                    ? MediaQuery.of(context).size.width * 0.2
                                    : MediaQuery.of(context).size.width * 0.1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.center,
                              child: Assets.image.aawazLogo.svg(),
                            ),
                            const Gap(22),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Onboarding Process for Admin",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w700),
                              ),
                            ),
                            Gap(50.h),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 160,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: controller.adminProfileFile != null
                                          ? Colors.green
                                          : Colors.grey,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                controller.adminProfileFile != null
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: CircleAvatar(
                                          radius: 70,
                                          backgroundImage: Image.memory(
                                                  controller.adminProfileFile!)
                                              .image,
                                        ),
                                      )
                                    : Align(
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          radius: 0,
                                          overlayColor: WidgetStateProperty.all(
                                              Colors.transparent),
                                          onTap: () async {
                                            controller.adminProfileFile =
                                                await controller.pickFile();
                                          },
                                          child: CircleAvatar(
                                            radius: 70,
                                            backgroundColor: Colors.grey[900],
                                            child: const Icon(
                                              Icons.camera_alt,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            Gap(20.h),
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                radius: 0,
                                overlayColor:
                                    WidgetStateProperty.all(Colors.transparent),
                                onTap: () {
                                  controller.adminProfileFile = null;
                                  controller.update();
                                },
                                child: SizedBox(
                                  height: 40.h,
                                  width: 160.w,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "Delete photo",
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
                            Gap(40.h),
                            CommonTextField(
                              topLabel: "Name",
                              hintText: "Name",
                              controller: controller.adminNameController,
                              validator: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return "Please enter your name";
                                }
                                return null;
                              },
                            ),
                            Gap(20.h),
                            CommonTextField(
                              topLabel: "Mobile Number",
                              hintText: "Mobile Number",
                              controller: controller.adminPhoneController,
                              validator: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return "Please enter your mobile number";
                                }
                                return null;
                              },
                            ),
                            Gap(70.h),
                            CommonButton(
                              widget: Text(
                                "Done",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              onPressed: () {
                                if (controller.formKey.currentState!
                                    .validate()) {}
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
