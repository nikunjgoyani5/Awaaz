import 'dart:io';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:eagle_eye/core/constant/app_constant.dart';
import 'package:eagle_eye/core/theme/text_styles.dart';
import 'package:eagle_eye/core/widget/common_bottom_sheet.dart';
import 'package:eagle_eye/presentation/authentication/auth_screen/bloc/auth_screen_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../core/constant/app_assets.dart';
import '../../../core/theme/colors.dart';
import '../../../core/utils/app_functions.dart';
import '../../../core/utils/app_prefrence.dart';
import '../../../core/widget/app_check_box.dart';
import '../../../core/widget/app_common_loader_screen.dart';
import '../../../core/widget/common_button.dart';
import '../../../core/widget/common_textfield.dart';
import '../../../gen/assets.gen.dart';
import '../../../services/firebase_analytics_service.dart';
import '../../../services/one_signal_notification_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    FirebaseEvents.setFirebaseEvent('auth_screen', {});
    super.initState();
    PrefService.singleclear(PrefService.eventDetailsId);
    Future.delayed(Duration.zero).then(
      (value) {
        initVideoPlayer();
      },
    );
  }

  Future notificationPermission() async {
    await OneSignalNotificationService.requestNotificationPermission();
  }

  initVideoPlayer() async {
    videoPlayerController =
        VideoPlayerController.asset(AppVideoAsset.authBgVideo);
    await Future.wait([videoPlayerController.initialize()]);
    _createChewieController();
    setState(() {});
  }

  _createChewieController() {
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: true,
        looping: true,
        showControls: false,
        showControlsOnInitialize: false,
        aspectRatio: 9 / 16,
        allowedScreenSleep: false,
        showOptions: false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (context.read<AuthScreenCubit>().state.isRegister) {
          context.read<AuthScreenCubit>().showLogInWithEmail();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<AuthScreenCubit, AuthScreenState>(
          builder: (context, state) {
            return AppCommonLoaderScreen(
              inAsyncCall: state.isLoading,
              child: GestureDetector(
                onTap: closeKeyboard,
                child: Stack(
                  children: [
                    (chewieController != null &&
                            chewieController!
                                .videoPlayerController.value.isInitialized)
                        ? Center(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.black,
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  width: videoPlayerController.value.size.width,
                                  height:
                                      videoPlayerController.value.size.height,
                                  child: Chewie(
                                    controller: chewieController!,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Image.asset(
                              AppImageAsset.authBgImg,
                              fit: BoxFit.fill,
                            ),
                          ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            BlocBuilder<AuthScreenCubit, AuthScreenState>(
                              builder: (context, state) {
                                return Visibility(
                                  visible: state.isRegister,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: IconButton(
                                          onPressed: () {
                                            FirebaseEvents.setFirebaseEvent(
                                                'show_login_with_email_btn',
                                                {});
                                            context
                                                .read<AuthScreenCubit>()
                                                .showLogInWithEmail();
                                          },
                                          icon: Assets.icons.icBackArrowWhite
                                              .svg()),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: state.isRegister ? 0.h : 100.h,
                            ),
                            Visibility(
                              visible: Platform.isAndroid,
                              child: Column(
                                children: [
                                  Assets.icons.icAppIcon.svg(),
                                  Text(
                                    'Awaaz',
                                    style: TextStyles.semiBold(40.sp,
                                        fontFamily: testTiemposHeadline),
                                  ),
                                ],
                              ),
                            ),
                            /*Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Assets.icons.icAppIcon.svg(),
                                Gap(10.w),
                                Text(
                                  'Awaaz',
                                  style: TextStyles.semiBold(40.sp,
                                      fontFamily: testTiemposHeadline),
                                ),
                              ],
                            ),*/
                            BlocBuilder<AuthScreenCubit, AuthScreenState>(
                              builder: (context, state) {
                                return Visibility(
                                    visible: state.isLogInWithEmail,
                                    child: logInWithMail());
                              },
                            ),
                            /*BlocBuilder<AuthScreenCubit, AuthScreenState>(
                              builder: (context, state) {
                                return Visibility(
                                    visible: state.isLogInWithPhone,
                                    child: logInRegisterWidget());
                              },
                            ),*/
                            /*BlocBuilder<AuthScreenCubit, AuthScreenState>(
                              builder: (context, state) {
                                return logInWithMail();
                                */ /*return Visibility(
                                    visible: state.isLogInWithEmail,
                                    child: logInWithMail());*/ /*
                              },
                            ),*/
                            BlocBuilder<AuthScreenCubit, AuthScreenState>(
                              builder: (context, state) {
                                return Visibility(
                                    visible: state.isRegister,
                                    child: register());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget logInRegisterWidget() {
    return Column(
      children: [
        /*SizedBox(
          height: 40.h,
        ),
        Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyles.bold(34.sp, fontFamily: testTiemposHeadline),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          "Log in to stay safe and keep others informed!",
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyles.medium(
            15.sp,
          ),
        ),*/
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<AuthScreenCubit>().showLogInWithEmail();
                },
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12), // Rounded corners for blur
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 5, sigmaY: 5), // Blur intensity
                    child: Container(
                      height: 65.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.1),
                        // Button background with transparency
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1),
                      ),
                      child: Text(
                        'Email Login',
                        style: TextStyles.medium(18.sp),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),*/
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FirebaseEvents.setFirebaseEvent('show_register_page_btn', {});
                  context.read<AuthScreenCubit>().showRegister();
                },
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12), // Rounded corners for blur
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    // Blur intensity
                    child: Container(
                      height: 65.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.1),
                        // Button background with transparency
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyles.medium(22.sp,
                            fontColor: AppColors.whiteColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        /*Text(
          'Social Login',
          style: TextStyles.bold(20.sp, fontColor: AppColors.whiteColor),
        ),*/
        SizedBox(
          height: 8.h,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuthScreenCubit, AuthScreenState>(
                builder: (context, state) {
                  return AppCheckBox(
                    isChecked: state.isPolicyCheck,
                    onChanged: (val) {
                      context.read<AuthScreenCubit>().setCheckbox(val ?? false);
                    },
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'I have read and I agree to the ',
                        style: TextStyles.medium(
                          18.sp,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms of Use',
                            style: TextStyles.medium(18.sp,
                                fontColor: AppColors.primaryColor,
                                textDecoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _openLink(
                                  "https://sites.google.com/view/awaaz-terms--conditions/home",
                                );
                              },
                          ),
                          TextSpan(
                            text: ' and ',
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyles.medium(18.sp,
                                fontColor: AppColors.primaryColor,
                                textDecoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _openLink(
                                  "https://sites.google.com/view/awaaz-privacy-policy/home",
                                );
                              },
                          ),
                          TextSpan(
                            text: '.',
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        googleLogInButton(context),
        SizedBox(
          height: 10.h,
        ),
        Visibility(visible: Platform.isIOS, child: appleLogInButton(context)),
        /*BlocBuilder<AuthScreenCubit, AuthScreenState>(
          buildWhen: (previous, current) =>
              previous.phoneNumberController != current.phoneNumberController,
          builder: (context, state) {
            return CommonTextField(
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(10),
              ],
              prefixIcon: SizedBox(
                height: 50,
                width: 80,
                child: CountryCodePicker(
                  onChanged: (code) {
                    if (code.dialCode != null && code.dialCode!.isNotEmpty) {
                      log(code.dialCode.toString());
                      context
                          .read<AuthScreenCubit>()
                          .getPhoneCode(code.dialCode ?? '');
                    }
                  },
                  showDropDownButton: true,
                  dialogBackgroundColor: Colors.black,
                  initialSelection: 'IN',
                  showFlag: false,
                  padding: EdgeInsets.zero,
                  textStyle: TextStyles.medium(16.sp, fontColor: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.number,
              hintText: 'Enter Phone number',
              controller: state.phoneNumberController!,
            );
          },
        ),
        SizedBox(
          height: 10.h,
        ),*/
        /*  Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuthScreenCubit, AuthScreenState>(
                builder: (context, state) {
                  return AppCheckBox(
                    isChecked: state.isPolicyCheck,
                    onChanged: (val) {
                      context.read<AuthScreenCubit>().setCheckbox(val ?? false);
                    },
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'I have read and I agree to the ',
                        style: TextStyles.medium(
                          18.sp,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms of Use',
                            style: TextStyles.medium(18.sp,
                                fontColor: AppColors.primaryColor,
                                textDecoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _openLink(
                                  "https://awaaztheeagleeye.blogspot.com/2025/02/terms-and-conditions.html",
                                );
                              },
                          ),
                          TextSpan(
                            text: ' and ',
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyles.medium(18.sp,
                                fontColor: AppColors.primaryColor,
                                textDecoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _openLink(
                                  "https://sites.google.com/view/awaaz-privacy-policy/home",
                                );
                              },
                          ),
                          TextSpan(
                            text: '.',
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),*/
        /*   SizedBox(
          height: 40.h,
        ),
        BlocBuilder<AuthScreenCubit, AuthScreenState>(
          builder: (context, state) {
            return CommonButton(
              onPressed: () {
                closeKeyboard();
                context.read<AuthScreenCubit>().onSubmitLogInPhone(context);
              },
              widget: Text('Login'),
            );
          },
        ),
      */
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  Widget logInWithMail() {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12), // Rounded corners for blur
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Blur intensity
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  // Button background with transparency
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1), width: 1),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 35.h,
                    ),
                    Text(
                      "Login",
                      style: TextStyles.bold(34.sp,
                          fontFamily: testTiemposHeadline),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Login now to stay safe and keep others informed!",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyles.medium(
                        18.sp,
                      ),
                    ),
                    /*SizedBox(
                      height: 45.h,
                    ),*/
                    /*Text(
                      'Awaaz',
                      style: TextStyles.semiBold(30.sp,
                          fontFamily: testTiemposHeadline),
                    ),*/
                    SizedBox(
                      height: 20.h,
                    ),
                    BlocBuilder<AuthScreenCubit, AuthScreenState>(
                      buildWhen: (previous, current) =>
                          previous.emailController != current.emailController,
                      builder: (context, state) {
                        return CommonTextField(
                          autofocus: false,
                          focusNode: _focusNode,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Assets.icons.icEmail.svg(),
                          ),
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          controller: state.emailController!,
                        );
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    BlocBuilder<AuthScreenCubit, AuthScreenState>(
                      builder: (context, state) {
                        return CommonTextField(
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Assets.icons.icPassword.svg(),
                          ),
                          hintText: 'Password',
                          controller: state.passwordController!,
                          maxLines: 1,
                          obscureText: !state.isPassShow,
                          suffixIcon: state.isPassShow
                              ? IconButton(
                                  onPressed: () {
                                    context
                                        .read<AuthScreenCubit>()
                                        .showPassword(false);
                                  },
                                  icon: Assets.icons.icEyeOff.svg())
                              : IconButton(
                                  onPressed: () {
                                    context
                                        .read<AuthScreenCubit>()
                                        .showPassword(true);
                                  },
                                  icon: Assets.icons.icEye.svg()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        BlocBuilder<AuthScreenCubit, AuthScreenState>(
                          builder: (context, state) {
                            return AppCheckBox(
                              isChecked: state.isRemember,
                              onChanged: (val) {
                                context
                                    .read<AuthScreenCubit>()
                                    .setRememberCheckbox(val ?? false);
                              },
                            );
                          },
                        ),
                        BlocBuilder<AuthScreenCubit, AuthScreenState>(
                            builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              context
                                  .read<AuthScreenCubit>()
                                  .setRememberCheckbox(!state.isRemember);
                            },
                            child: Text(
                              "Keep me logged in",
                              style: TextStyles.regular(
                                16.sp,
                                fontColor: AppColors.whiteColor,
                              ),
                            ),
                          );
                        }),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            context
                                .read<AuthScreenCubit>()
                                .setRememberCheckbox(false);
                            context
                                .read<AuthScreenCubit>()
                                .initForgotPassword();
                            showAppBottomSheet(
                                context,
                                AppCommonBottomSheet(
                                    isOpenWithGradient: false,
                                    body: ForgotPasswordSheet()));
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyles.medium(16.sp,
                                textDecoration: TextDecoration.underline,
                                fontColor: AppColors.whiteColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CommonButton(
                      onPressed: () {
                        closeKeyboard();
                        FirebaseEvents.setFirebaseEvent('click_login_btn', {});
                        context
                            .read<AuthScreenCubit>()
                            .onSubmitLogInEmail(context);
                      },
                      widget: Text('Login'),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        /*SizedBox(
          height: 40.h,
        ),
        Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyles.bold(34.sp, fontFamily: testTiemposHeadline),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          "Log in to stay safe and keep others informed!",
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyles.medium(
            15.sp,
          ),
        ),*/
        SizedBox(
          height: 20.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<AuthScreenCubit>().showLogInWithEmail();
                },
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12), // Rounded corners for blur
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: 5, sigmaY: 5), // Blur intensity
                    child: Container(
                      height: 65.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.1),
                        // Button background with transparency
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1),
                      ),
                      child: Text(
                        'Email Login',
                        style: TextStyles.medium(18.sp),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),*/
            Expanded(
              child: GestureDetector(
                onTap: () {
                  context.read<AuthScreenCubit>().setRememberCheckbox(false);
                  context.read<AuthScreenCubit>().showRegister();
                },
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12), // Rounded corners for blur
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    // Blur intensity
                    child: Container(
                      height: 65.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.1),
                        // Button background with transparency
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyles.medium(22.sp,
                            fontColor: AppColors.whiteColor),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
        /*Text(
          'Social Login',
          style: TextStyles.bold(20.sp, fontColor: AppColors.whiteColor),
        ),*/
        SizedBox(
          height: 8.h,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuthScreenCubit, AuthScreenState>(
                builder: (context, state) {
                  return AppCheckBox(
                    isChecked: state.isPolicyCheck,
                    onChanged: (val) {
                      context.read<AuthScreenCubit>().setCheckbox(val ?? true);
                    },
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'I have read and I agree to the ',
                        style: TextStyles.medium(
                          18.sp,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms of Use',
                            style: TextStyles.medium(18.sp,
                                fontColor: AppColors.primaryColor,
                                textDecoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _openLink(
                                  "https://sites.google.com/view/awaaz-terms--conditions/home",
                                );
                              },
                          ),
                          TextSpan(
                            text: ' and ',
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyles.medium(18.sp,
                                fontColor: AppColors.primaryColor,
                                textDecoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _openLink(
                                  "https://sites.google.com/view/awaaz-privacy-policy/home",
                                );
                              },
                          ),
                          TextSpan(
                            text: '.',
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        googleLogInButton(context),
        SizedBox(
          height: 10.h,
        ),
        Visibility(visible: Platform.isIOS, child: appleLogInButton(context)),
        /*BlocBuilder<AuthScreenCubit, AuthScreenState>(
          buildWhen: (previous, current) =>
              previous.phoneNumberController != current.phoneNumberController,
          builder: (context, state) {
            return CommonTextField(
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(10),
              ],
              prefixIcon: SizedBox(
                height: 50,
                width: 80,
                child: CountryCodePicker(
                  onChanged: (code) {
                    if (code.dialCode != null && code.dialCode!.isNotEmpty) {
                      log(code.dialCode.toString());
                      context
                          .read<AuthScreenCubit>()
                          .getPhoneCode(code.dialCode ?? '');
                    }
                  },
                  showDropDownButton: true,
                  dialogBackgroundColor: Colors.black,
                  initialSelection: 'IN',
                  showFlag: false,
                  padding: EdgeInsets.zero,
                  textStyle: TextStyles.medium(16.sp, fontColor: Colors.grey),
                ),
              ),
              keyboardType: TextInputType.number,
              hintText: 'Enter Phone number',
              controller: state.phoneNumberController!,
            );
          },
        ),
        SizedBox(
          height: 10.h,
        ),*/
        /*  Padding(
          padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuthScreenCubit, AuthScreenState>(
                builder: (context, state) {
                  return AppCheckBox(
                    isChecked: state.isPolicyCheck,
                    onChanged: (val) {
                      context.read<AuthScreenCubit>().setCheckbox(val ?? false);
                    },
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'I have read and I agree to the ',
                        style: TextStyles.medium(
                          18.sp,
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms of Use',
                            style: TextStyles.medium(18.sp,
                                fontColor: AppColors.primaryColor,
                                textDecoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _openLink(
                                  "https://awaaztheeagleeye.blogspot.com/2025/02/terms-and-conditions.html",
                                );
                              },
                          ),
                          TextSpan(
                            text: ' and ',
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyles.medium(18.sp,
                                fontColor: AppColors.primaryColor,
                                textDecoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                _openLink(
                                  "https://sites.google.com/view/awaaz-privacy-policy/home",
                                );
                              },
                          ),
                          TextSpan(
                            text: '.',
                          ),
                        ]),
                  ),
                ),
              ),
            ],
          ),
        ),*/
        /*   SizedBox(
          height: 40.h,
        ),
        BlocBuilder<AuthScreenCubit, AuthScreenState>(
          builder: (context, state) {
            return CommonButton(
              onPressed: () {
                closeKeyboard();
                context.read<AuthScreenCubit>().onSubmitLogInPhone(context);
              },
              widget: Text('Login'),
            );
          },
        ),
      */
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  Widget register() {
    return Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        Padding(
          padding: EdgeInsets.only(top: 35.h),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12), // Rounded corners for blur
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Blur intensity
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.1),
                  // Button background with transparency
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1), width: 1),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 35.h,
                    ),
                    // Text(
                    //   'Awaaz',
                    //   style: TextStyles.semiBold(30.sp,
                    //       fontFamily: testTiemposHeadline),
                    // ),
                    Text(
                      "Register",
                      style: TextStyles.bold(34.sp,
                          fontFamily: testTiemposHeadline),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Register now to stay safe and keep others informed!",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyles.medium(
                        18.sp,
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    BlocBuilder<AuthScreenCubit, AuthScreenState>(
                      builder: (context, state) {
                        return CommonTextField(
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Assets.icons.icEmail.svg(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Email',
                          controller: state.emailController!,
                        );
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    BlocBuilder<AuthScreenCubit, AuthScreenState>(
                      builder: (context, state) {
                        return CommonTextField(
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 10.w, right: 10.w),
                            child: Assets.icons.icPassword.svg(),
                          ),
                          hintText: 'Password',
                          controller: state.passwordController!,
                          maxLines: 1,
                          obscureText: !state.isPassShow,
                          suffixIcon: state.isPassShow
                              ? IconButton(
                                  onPressed: () {
                                    context
                                        .read<AuthScreenCubit>()
                                        .showPassword(false);
                                  },
                                  icon: Assets.icons.icEyeOff.svg())
                              : IconButton(
                                  onPressed: () {
                                    context
                                        .read<AuthScreenCubit>()
                                        .showPassword(true);
                                  },
                                  icon: Assets.icons.icEye.svg()),
                        );
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<AuthScreenCubit, AuthScreenState>(
                            builder: (context, state) {
                              return AppCheckBox(
                                isChecked: state.isPolicyCheck,
                                onChanged: (val) {
                                  context
                                      .read<AuthScreenCubit>()
                                      .setCheckbox(val ?? false);
                                },
                              );
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: 'I have read and I agree to the ',
                                    style: TextStyles.medium(
                                      18.sp,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Terms of Use',
                                        style: TextStyles.medium(18.sp,
                                            fontColor: AppColors.primaryColor,
                                            textDecoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            _openLink(
                                              "https://sites.google.com/view/awaaz-terms--conditions/home",
                                            );
                                          },
                                      ),
                                      TextSpan(
                                        text: ' and ',
                                      ),
                                      TextSpan(
                                        text: 'Privacy Policy',
                                        style: TextStyles.medium(18.sp,
                                            fontColor: AppColors.primaryColor,
                                            textDecoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            _openLink(
                                              "https://awaaztheeagleeye.blogspot.com/2025/02/privacy-policy.html",
                                            );
                                          },
                                      ),
                                      TextSpan(
                                        text: '.',
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    CommonButton(
                      onPressed: () {
                        closeKeyboard();
                        FirebaseEvents.setFirebaseEvent(
                            'click_register_btn', {});
                        context
                            .read<AuthScreenCubit>()
                            .onSubmitRegister(context);
                      },
                      widget: Text('Register'),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget googleLogInButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FirebaseEvents.setFirebaseEvent('click_login_with_google', {});
        context.read<AuthScreenCubit>().onClickGoogleLogin(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12), // Rounded corners for blur
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Blur intensity
          child: Container(
            height: 65.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              // Button background with transparency
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.icons.icGoogle.svg(),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  'Log in with google',
                  style: TextStyles.regular(24.sp),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget appleLogInButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FirebaseEvents.setFirebaseEvent('click_login_with_apple', {});
        context.read<AuthScreenCubit>().onClickAppleLogin(context);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12), // Rounded corners for blur
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Blur intensity
          child: Container(
            height: 65.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              // Button background with transparency
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Assets.icons.icApple.svg(),
                SizedBox(
                  width: 10.w,
                ),
                Text(
                  'Log in with Apple',
                  style: TextStyles.regular(24.sp),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openLink(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController!.dispose();
  }
}
