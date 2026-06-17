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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordController controller = Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    final ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return GetBuilder<ForgotPasswordController>(
      builder: (controller) {
        return Scaffold(
          body: Form(
            key: controller.forgotPasswordFormKey,
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
                              "Reset your password",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700),
                            ),
                          ),
                          Gap(10.h),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Enter the email address linked to your Awaaz account and we'll send you an email.",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    color: AppColors.grey929da9,
                                    fontWeight: FontWeight.w500,
                                  ),
                              textAlign: TextAlign.center,
                            ).paddingSymmetric(horizontal: 20),
                          ),
                          Gap(35.h),
                          CommonTextField(
                            topLabel: "Email address",
                            hintText: "Email",
                            controller: controller.emailController,
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return "Please enter your email";
                              }
                              if (!p0.isEmail) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                            onSubmitted: (value) async {
                              await controller.sendOTPOnEmail(context, pl);
                            },
                          ),
                          const Gap(60),
                          CommonButton(
                            onPressed: () async {
                              await controller.sendOTPOnEmail(context, pl);
                            },
                            widget: Text(
                              "Send Link",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                          // Gap(20.h),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     Text(
                          //       'Not registered? ',
                          //       style: Theme.of(context)
                          //           .textTheme
                          //           .labelLarge!
                          //           .copyWith(color: AppColors.black),
                          //     ),
                          //     GestureDetector(
                          //       onTap: () {
                          //         NavigatorRoute.navigateTo(
                          //             context, const RegisterScreen());
                          //       },
                          //       child: Text(
                          //         'Create an account',
                          //         style: Theme.of(context)
                          //             .textTheme
                          //             .labelLarge!
                          //             .copyWith(color: AppColors.blue),
                          //       ),
                          //     ),
                          //   ],
                          // ),
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
