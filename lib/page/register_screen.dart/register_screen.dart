import 'package:eagle_eye_admin/controller/register_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    final ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return GetBuilder<RegisterController>(
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
                                "WELCOME TO THE OPERATOR PANEL OF AWAAZ APP",
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall!
                                    .copyWith(
                                    fontSize: 30.w,
                                        color: AppColors.white,

                                        fontWeight: FontWeight.w700),
                              ),
                            ),
                            Gap(45.h),
                            CommonTextField(
                              topLabel: "Name",
                              hintText: "Name",
                              controller: controller.nameController,
                              validator: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return "Please enter your name";
                                }

                                return null;
                              },
                              onSubmitted: (value) async {
                              await  controller.registerWithEmail(context, pl);

                              },
                            ),
                            Gap(20.h),
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
                                await  controller.registerWithEmail(context, pl);

                              },
                            ),
                            Gap(5.h),
                            CommonTextField(
                              topLabel: "Password",
                              hintText: "Password",
                              obscureText: controller.isPasswordSecure,
                              controller: controller.passwordController,
                              validator: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return "Please enter a password";
                                }
                                return null;
                              },
                              onSubmitted: (value) async {
                                await  controller.registerWithEmail(context, pl);

                              },
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
                            ),
                            Gap(20.h),

                            CommonButton(
                              onPressed: () {
                                controller.registerWithEmail(context, pl);
                              },
                              widget: Text(
                                "Register",
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Already using Awaaz? ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(color: AppColors.greyText),
                                ),
                                TextButton(
                                  style: const ButtonStyle(
                                    padding:
                                        WidgetStatePropertyAll(EdgeInsets.zero),
                                    overlayColor: WidgetStatePropertyAll(
                                        AppColors.transparent),
                                  ),
                                  onPressed: () {
                                    NavigatorRoute.navigateBack(context: context);
                                  },
                                  child: Text(
                                    'Login Now',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            color: AppColors.white,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationThickness: 1.8,
                                            decorationColor: AppColors.white),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(50),
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: AppColors.textFeildBorderColor,
                                  ),
                                ),
                                Text(
                                  'Or',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(color: AppColors.white),
                                ).paddingSymmetric(horizontal: 20),
                                const Expanded(
                                  child: Divider(
                                    color: AppColors.textFeildBorderColor,
                                  ),
                                )
                              ],
                            ),
                            const Gap(50),
                            CommonBorderButton(
                              onPressed: () async {
                                await controller.onGoogleClicked(context, pl);
                              },
                              widget: Row(
                                children: [
                                  const Spacer(),
                                  Assets.icons.icGoogle.svg(),
                                  const Spacer(),
                                  Text(
                                    'Continue with Google',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(color: AppColors.white),
                                  ),
                                  const Spacer(),
                                  const Spacer(),
                                ],
                              ),
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
