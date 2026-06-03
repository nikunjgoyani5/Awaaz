import 'dart:async';
import 'dart:developer';

import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:eagle_eye/core/widget/common_snack_bar.dart';
import 'package:eagle_eye/data/models/login_model.dart';
import 'package:eagle_eye/data/models/response_model.dart';
import 'package:eagle_eye/data/repositories/auth_repo.dart';
import 'package:eagle_eye/presentation/authentication/reset_password_screen/bloc/reset_password_screen_cubit.dart';
import 'package:eagle_eye/presentation/authentication/reset_password_screen/reset_password_screen.dart';
import 'package:eagle_eye/presentation/onboard/onboard_screen/bloc/onboard_cubit.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/routes/app_routes.dart';
import 'package:eagle_eye/services/firebase_analytics_service.dart';
import 'package:eagle_eye/services/remote_config_service/remote_config_label.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'verify_otp_cubit.freezed.dart';
part 'verify_otp_state.dart';

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit() : super(const VerifyOtpState.initial());

  String getTimerString(int time) {
    if (time < 10) {
      return '0$time';
    }
    return '$time';
  }

  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendRemainingSeconds > 0) {
        emit(state.copyWith(
            resendRemainingSeconds: state.resendRemainingSeconds - 1));
      } else {
        emit(state.copyWith(enableResend: true));
        timer.cancel();
      }
      log('SECOND ✅ ${state.resendRemainingSeconds}');
    });
  }

  void resendButtonPressed(BuildContext context,
      {required String email}) async {
    // if (state.resendRemainingSeconds == 0) {
    timer?.cancel();
    emit(state.copyWith(resendRemainingSeconds: 60, enableResend: false));
    startTimer();
    await resendOTPOnEmail(context, email: email);
    // }
  }

  void stopTimer() {
    timer?.cancel();
  }

  Future<void> onSubmitVerifyOTP(BuildContext context, String email,
      String phone, String screen, bool isPhone) async {
    if (state.otpController!.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(showCustomSnackBar(message: 'Please enter a OTP'));
    } else if (state.otpController!.text.length != 4) {
      ScaffoldMessenger.of(context)
          .showSnackBar(showCustomSnackBar(message: 'OTP must be 4 digit'));
    } else {
      if (screen == "Forgot Password") {
        await verifyEmailOtp(context, email, screen: screen);
      } else if (isPhone) {
        await verifyPhoneOtp(context, phone);
      } else {
        await verifyEmailOtp(context, email);
      }
    }
  }

  Future verifyEmailOtp(BuildContext context, String email,
      {String? screen}) async {
    emit(state.copyWith(isLoading: true));
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    bool isNewOnboard = false;
    isNewOnboard = remoteConfig.getBool(RemoteConfigLabel.isNewOnboard);
    try {
      ResponseModel response = await AuthRepository.verifyEmailOtp(
          data: {'otp': num.parse(state.otpController!.text), 'email': email});
      log('Verify OTP response === ${response.toJson()}');
      if (response.status == true) {
        AppFunctions.showToast(response.message);
        stopTimer();
        if (screen == "Forgot Password") {
          context.read<ResetPasswordCubit>().init();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(
                email: email,
              ),
            ),
          );
        } else {
          Auth authModel = Auth.fromJson(response.body);
          PrefService.setValue(PrefService.accessToken, authModel.token ?? '');
          PrefService.setValue(PrefService.email, authModel.user?.email ?? '');
          PrefService.setValue(
              PrefService.mobileNumber, authModel.user?.mobileNumber ?? '');
          PrefService.setValue(PrefService.name, authModel.user?.name ?? '');
          PrefService.setValue(
              PrefService.dateOfBirth,
              authModel.user?.dateOfBirth != null
                  ? DateFormat('dd/MM.yyyy')
                      .format(authModel.user!.dateOfBirth!.toLocal())
                  : '');
          PrefService.setValue(PrefService.userId, authModel.user?.id ?? '');
          PrefService.setValue(
              PrefService.profileUrl, authModel.user?.profilePicture ?? '');
          PrefService.setValue(
              PrefService.userRadius, authModel.user?.userRadius ?? 0);
          PrefService.setValue(PrefService.isLogin, true);
          context.read<OnboardCubit>().init();
          context.read<OnboardCubit>().setNameFiledData();
          context.read<OnboardCubit>().setUserNameFiledData();
          FirebaseEvents.setFirebaseEvent(
              'verify_success_navigate_onboard', {});
          NavigatorRoute.navigateToRemoveUntil(context,
              isNewOnboard ? AppRoutes.newOnboard : AppRoutes.onboardName);
        }
      } else {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      }
      // clearValue();
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('Cache Error ${e.toString()}');
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];
      AppFunctions.showToast(finalError);
    }
  }

  Future verifyPhoneOtp(BuildContext context, String phone) async {
    emit(state.copyWith(isLoading: true));
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    bool isNewOnboard = false;
    isNewOnboard = remoteConfig.getBool(RemoteConfigLabel.isNewOnboard);
    try {
      ResponseModel response = await AuthRepository.verifyPhoneOtp(data: {
        'otp': num.parse(state.otpController!.text),
        'mobileNumber': phone
      });
      log('Verify OTP response === ${response.toJson()}');
      if (response.status == true) {
        // await MapUtils.requestLocationPermission(context);
        Auth authModel = Auth.fromJson(response.body);
        if (authModel.user != null && authModel.token != null) {
          PrefService.setValue(PrefService.accessToken, authModel.token ?? '');
          if (authModel.user?.name != null &&
              authModel.user!.name!.isNotEmpty) {
            PrefService.setValue(
                PrefService.email, authModel.user?.email ?? '');
            PrefService.setValue(
                PrefService.mobileNumber, authModel.user?.mobileNumber ?? '');
            PrefService.setValue(PrefService.name, authModel.user?.name ?? '');
            PrefService.setValue(PrefService.userId, authModel.user?.id ?? '');
            PrefService.setValue(
                PrefService.dateOfBirth,
                authModel.user?.dateOfBirth != null
                    ? DateFormat('dd/MM/yyyy')
                        .format(authModel.user!.dateOfBirth!)
                    : '');
            PrefService.setValue(PrefService.userId, authModel.user?.id ?? '');
            PrefService.setValue(
                PrefService.profileUrl, authModel.user?.profilePicture ?? '');
            PrefService.setValue(
                PrefService.userRadius, authModel.user?.userRadius ?? 0);
            PrefService.setValue(PrefService.isLogin, true);
            PrefService.setValue(PrefService.emailLogin, true);
            NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.home);
          } else {
            context.read<OnboardCubit>().init();
            context.read<OnboardCubit>().setNameFiledData();
            context.read<OnboardCubit>().setUserNameFiledData();
            NavigatorRoute.navigateToRemoveUntil(context,
                isNewOnboard ? AppRoutes.newOnboard : AppRoutes.onboardName);
          }
          AppFunctions.showToast(response.message);
        } else {
          emit(state.copyWith(isLoading: false));
          AppFunctions.showToast("User data not found.");
        }
      } else {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      }
      clearValue();
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

  resendOTPOnEmail(BuildContext context, {required String email}) async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await AuthRepository.resendOTPMail(email: email);
      if (response.status == true) {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      } else {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      }
      clearValue();
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      List<String> error = e.toString().split(': ');
      List<String> splitError = error[4].split(',');
      String finalError = splitError[0];
      AppFunctions.showToast(finalError);
    }
  }

  clearValue() {
    emit(state.copyWith(
        otpController: TextEditingController(),
        isLoading: false,
        enableResend: false,
        resendRemainingSeconds: 60));
  }
}
