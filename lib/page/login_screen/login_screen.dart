import 'package:eagle_eye_admin/controller/login_controller.dart';
import 'package:eagle_eye_admin/gen/assets.gen.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/button.dart';
import 'package:eagle_eye_admin/widget/textfeild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginController controller = Get.put(LoginController());
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller.getLoginData();

    // Automatically request focus on email field after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      emailFocusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProgressLoader pl = ProgressLoader(context, isDismissible: true);
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Scaffold(
          body: Stack(
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
                      child: Form(
                        key: controller.formKey,
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
                              keyboardType: TextInputType.emailAddress,
                              topLabel: "Email address",
                              hintText: "Email",
                              autoHints: const [AutofillHints.email],

                              controller: controller.emailController,
                              textInputAction: TextInputAction.next,
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
                                await controller.loginWithEmailNPasssword(
                                    context, pl);
                              },
                            ),


                            const Gap(20),
                            CommonTextField(

                              autoHints: const [AutofillHints.password],
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
                                await controller.loginWithEmailNPasssword(
                                    context, pl);
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

                            Gap(10.h),


                            Row(
                              children: [
                                Checkbox(
                                  checkColor:
                                  AppColors.black,
                                  activeColor:
                                  AppColors.white,
                                  value: controller
                                      .keepMeLogin,
                                  onChanged: (value) {
                                    setState(() {
                                      controller
                                          .keepMeLogin =
                                          value ??
                                              false;
                                    });
                                    controller.update();
                                  },
                                ),

                                Gap(10.w),

                                GestureDetector(
                                  child :   Text(
                                    'Keep me Login',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(color: AppColors.greyText),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      controller
                                          .keepMeLogin =   ! controller
                                          .keepMeLogin
                                      ;
                                    });
                                    controller.update();
                                  },
                                ),

                                const Spacer(),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      style: ButtonStyle(
                                        minimumSize:
                                            WidgetStatePropertyAll(Size(170, 20.h)),
                                        overlayColor: const WidgetStatePropertyAll(
                                            AppColors.transparent),
                                      ),
                                      onPressed: () {
                                        NavigatorRoute.navigateTo(
                                            AppRoutes.forgotPassword, context);
                                      },
                                      child: Text(
                                        'Forgot your password?',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .copyWith(
                                              color: AppColors.white,
                                              decoration: TextDecoration.underline,
                                            ),
                                      ),
                                    )),
                              ],
                            ),
                            Gap(50.h),
                            CommonButton(
                              onPressed: () async {
                                await controller.loginWithEmailNPasssword(
                                    context, pl);
                              },
                              widget: Text(
                                "Log In",
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
                                  onPressed: () {
                                    controller.emailController.clear();
                                    controller.passwordController.clear();
                                    NavigatorRoute.navigateTo(
                                        AppRoutes.register, context);
                                  },
                                  child: Text(
                                    'Register Now',
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
                            const Gap(40),
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
                            const Gap(40),
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
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
