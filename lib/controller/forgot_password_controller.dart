import 'dart:async';
import 'dart:developer';

import 'package:eagle_eye_admin/api/repository/auth_repository.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ForgotPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final forgotPasswordFormKey = GlobalKey<FormState>();
  final otpformKey = GlobalKey<FormState>();
  final resetPasswordformKey = GlobalKey<FormState>();
  final _resendRemainingSeconds = 60.obs;

  bool isPasswordSecure = true;
  bool isConfirmPassSecure = true;

  int get resendRemainingSeconds => _resendRemainingSeconds.value;

  set resendRemainingSeconds(int value) =>
      _resendRemainingSeconds.value = value;

  final _enableResend = true.obs;

  bool get enableResend => _enableResend.value;

  set enableResend(bool value) => _enableResend.value = value;

  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendRemainingSeconds > 0) {
        resendRemainingSeconds--;
        enableResend = false;
        update();
      } else {
        enableResend = true;
        timer.cancel();
        update();
      }
    });
  }

  void resendButtonPressed(BuildContext context, ProgressLoader pl) async {
    otpController.clear();
    await resendOTPOnEmail(context, pl);
    resendRemainingSeconds = 60;
    enableResend = false;
    update();
    startTimer();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> sendOTPOnEmail(BuildContext context, ProgressLoader pl) async {
    if (forgotPasswordFormKey.currentState?.validate() == true) {
      // try {
      //   await pl.show();
      //   var res = await AuthRepository.forgotPasswordWithEmail(
      //       email: emailController.text);
      //   log("sendOTPOnEmail :- $res");
      //   await pl.hide();
      //   showToast(
      //     title: 'Otp Verification',
      //     message: 'OTP send successfully!',
      //     context: context,
      //   );
      //   NavigatorRoute.navigateTo(AppRoutes.otpScreen);
      // } on DioException catch (e) {
      //   await pl.hide();
      //   showToast(
      //     title: 'Forgot Password!',
      //     message: e.response?.data['message'],
      //     bgColor: AppColors.red,
      //     context: context,
      //   );
      // } catch (e) {
      //   await pl.hide();
      //   log('$e');
      // }

      try {
        await pl.show();
        ResponseModel response = await AuthRepository.forgotPasswordWithEmail(
          context: context,
            email: emailController.text);

        debugPrint('Forgot Data === ${response.body}');
        if (response.status == true) {
          await pl.hide();
          showToast(
            title: 'Otp Verification',
            message: 'OTP send successfully!',
            context: context,
          );
          NavigatorRoute.navigateTo(AppRoutes.otpScreen,context);
        } else {
          showToast(
            title: 'Forgot Password!',
            message: response.message,
            bgColor: AppColors.red,
            context: context,
          );
        }
        await pl.hide();
      } catch (e) {
        await pl.hide();
        debugPrint('Cache Error ${e.toString()}');
      }
    }
  }

  Future<void> resendOTPOnEmail(BuildContext context, ProgressLoader pl) async {
    if (forgotPasswordFormKey.currentState?.validate() == true) {
      try {
        await pl.show();
        ResponseModel res = await AuthRepository.resendOTPEmail(
          context: context,
            email: emailController.text,);
        log("resendOTPOnEmail :- $res");
        if(res.status== true ){
          await pl.hide();
          showToast(
            title: 'Forgot Password!',
            message: 'OTP send successfully!',
            context: context,
          );
          NavigatorRoute.navigateTo(AppRoutes.otpScreen,context);
        }
        else {
          await pl.hide();
          showToast(
            title: 'Forgot Password!',
            message: res.message,
            bgColor: AppColors.red,
            context: context,
          );
        }

      } catch (e) {
        await pl.hide();
        log('$e');
      }
    }
  }

  Future<void> verifyMailOtp(BuildContext context, ProgressLoader pl) async {
    if (otpformKey.currentState?.validate() == true) {
      try {
        await pl.show();
        ResponseModel response = await AuthRepository.verifyEmailOtp(
          context: context,
          email: emailController.text,
          otp: otpController.text,
        );

        log("verifyMailOtp :- $response");
        if (response.status == true) {
          await pl.hide();
          showToast(
            title: 'Otp Verification',
            message: 'OTP verified successfully!',
            context: context,
          );
          NavigatorRoute.navigateTo(AppRoutes.resetPassword,context);
        } else {
          await pl.hide();
          showToast(
            title: 'Verify',
            message: response.message,
            bgColor: AppColors.red,
            context: context,
          );
        }
        await pl.hide();
      } catch (e) {
        await pl.hide();
        debugPrint('Cache Error ${e.toString()}');
      }
    }
  }

  Future<void> resetPassword(BuildContext context, ProgressLoader pl) async {
    if (resetPasswordformKey.currentState?.validate() == true) {
      // try {
      //   await pl.show();
      //   var res = await AuthRepository.resetPassword(
      //     password: passwordController.text,
      //     email: emailController.text,
      //   );
      //   await pl.hide();
      //   showToast(
      //       context: context,
      //       title: 'Reset Password!',
      //       message: res.message);
      //   NavigatorRoute.navigateToRemoveUntil(AppRoutes.login);
      // } on DioException catch (e) {
      //   await pl.hide();
      //   showToast(
      //       context: context,
      //       title: 'Reset Password!',
      //       message: e.response != null
      //           ? e.response?.data['message'] ?? 'Something went wrong.'
      //           : 'Something went wrong.',
      //       bgColor: AppColors.red);
      // } catch (e) {
      //   await pl.hide();
      //   log('$e');
      // }
      try {
        await pl.show();
        ResponseModel response = await AuthRepository.resetPassword(
          context: context,
          password: passwordController.text,
          email: emailController.text,
        );

        if (response.status == true) {
          await pl.hide();
          showToast(
              context: context,
              title: 'Reset Password!',
              message: response.message);
          NavigatorRoute.navigateToRemoveUntil(AppRoutes.login,context);
        } else {
          await pl.hide();
          showToast(
              context: context,
              title: 'Reset Password!',
              message: response.message,
              bgColor: AppColors.red);
        }
        await pl.hide();
      } catch (e) {
        await pl.hide();
        debugPrint('Cache Error ${e.toString()}');
      }
    }
  }
}
