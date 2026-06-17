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

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  ForgotPasswordController controller = Get.find();

  @override
  void initState() {
    controller.startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return GetBuilder<ForgotPasswordController>(
      builder: (controller) {
        return Scaffold(
          body: Form(
            key: controller.otpformKey,
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
                              "Enter Code",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w700),
                            ),
                          ),
                          Gap(35.h),
                          CommonTextField(
                            topLabel: "OTP",
                            hintText: "Enter Code",
                            controller: controller.otpController,
                            maxLength: 4,
                            validator: (p0) {
                              if (p0 == null || p0.isEmpty) {
                                return "Please enter OTP Code";
                              }
                              if (p0.length != 4) {
                                return 'Please enter a valid OTP Code';
                              }
                              return null;
                            },
                            onSubmitted: (value) async {
                           await   controller.verifyMailOtp(context, pl);
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Become an operator? ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(color: AppColors.greyText),
                              ),
                              TextButton(
                                style: const ButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                      EdgeInsetsDirectional.zero),
                                  overlayColor: WidgetStatePropertyAll(
                                      AppColors.transparent),
                                ),
                                onPressed: controller.enableResend
                                    ? () async {
                                        await controller.resendOTPOnEmail(
                                            context, pl);
                                        setState(() {});
                                      }
                                    : null,
                                child: Text(
                                  'RESEND',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(color: AppColors.white),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              (controller.enableResend == false)
                                  ? '${controller.formatTime(controller.resendRemainingSeconds)} Sec'
                                  : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(color: AppColors.white),
                            ),
                          ),
                          Gap(50.h),
                          CommonButton(
                            onPressed: () {
                              controller.verifyMailOtp(context, pl);
                            },
                            widget: Text(
                              "Continue",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
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
