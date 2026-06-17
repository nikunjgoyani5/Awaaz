import 'package:eagle_eye_admin/controller/forgot_password_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  ForgotPasswordController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return GetBuilder<ForgotPasswordController>(
      builder: (controller) {
        return Scaffold(
          body: Form(
            key: controller.resetPasswordformKey,
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
                              "Reset Password",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700),
                            ),
                          ),
                          Gap(45.h),
                          CommonTextField(
                            topLabel: "New Password",
                            hintText: "Enter new password",
                            controller: controller.passwordController,
                            obscureText: controller.isPasswordSecure,
                            suffixIcon: IconButton(
                              onPressed: () {
                                if (controller.isPasswordSecure) {
                                  controller.isPasswordSecure = false;
                                } else {
                                  controller.isPasswordSecure = true;
                                }
                                controller.update();
                                setState(() {});
                              },
                              icon: (controller.isPasswordSecure == false)
                                  ? Assets.icons.icEyeOff.svg()
                                  : Assets.icons.icEye.svg(),
                            ).paddingOnly(right: 10),
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return "Please enter a password";
                              }

                              return null;
                            },
                            onSubmitted: (value) async {
                              await controller.resetPassword(context, pl);
                            },
                          ),
                          Gap(5.h),
                          CommonTextField(
                            topLabel: "Confirm Password",
                            hintText: "Enter confirm password",
                            obscureText: controller.isConfirmPassSecure,

                            suffixIcon: IconButton(
                              onPressed: () {
                                if (controller.isConfirmPassSecure) {
                                  controller.isConfirmPassSecure = false;
                                } else {
                                  controller.isConfirmPassSecure = true;
                                }
                                controller.update();
                                setState(() {});
                              },
                              icon: (controller.isConfirmPassSecure == false)
                                  ? Assets.icons.icEyeOff.svg()
                                  : Assets.icons.icEye.svg(),
                            ).paddingOnly(right: 10),
                            controller: controller.confirmPasswordController,
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return "Please enter a confirm password";
                              }
                              if (p0 !=
                                  controller.passwordController.text) {
                                return "Password does not match";
        }
                              return null;
                            },
                            onSubmitted: (value) async {
                              await controller.resetPassword(context, pl);
                            },

                          ),
                          Gap(50.h),
                          CommonButton(
                            onPressed: () async {
                             await controller.resetPassword(context, pl);
                            },
                            widget: Text(
                              "Reset Password",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          Gap(20.h),
                        ],
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
