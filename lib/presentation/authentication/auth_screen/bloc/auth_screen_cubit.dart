import 'dart:developer';

import 'package:eagle_eye/presentation/main/home/bloc/home_screen_bloc_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/utils/app_functions.dart';
import '../../../../core/utils/app_prefrence.dart';
import '../../../../core/widget/common_snack_bar.dart';
import '../../../../data/models/login_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/auth_repo.dart';
import '../../../../routes/app_navigation.dart';
import '../../../../routes/app_routes.dart';
import '../../../../services/connectivity_check/connectivity.dart';
import '../../../../services/firebase_analytics_service.dart';
import '../../../../services/remote_config_service/remote_config_label.dart';
import '../../../main/news_screen/bloc/news_screen_bloc_cubit.dart';
import '../../../onboard/onboard_screen/bloc/onboard_cubit.dart';
import '../../verify_otp_screen/bloc/verify_otp_cubit.dart';
import '../../verify_otp_screen/verify_otp_screen.dart';

part 'auth_screen_cubit.freezed.dart';
part 'auth_screen_state.dart';

class AuthScreenCubit extends Cubit<AuthScreenState> {
  AuthScreenCubit() : super(const AuthScreenState());

  ///////////////////////////////////////////////////////// general function
  Future init() async {
    emit(state.copyWith(
        isLoading: false,
        isPassShow: false,
        isRemember: false,
        /*isLogInWithPhone: true,
        phoneNumberController: TextEditingController(),*/
        emailController: TextEditingController(),
        passwordController: TextEditingController(),
        isPolicyCheck: true));
  }

  initForgotPassword() {
    emit(state.copyWith(
      isLoading: false,
      forgotPasswordEmailController: TextEditingController(),
    ));
  }

  void updateEmailNumber(String email) {
    emit(state.copyWith(email: email));
  }

  void clearEmail() {
    emit(state.copyWith(email: ''));
  }

  // Method to update the password field
  void updatePassword(String value) {
    emit(state.copyWith(password: value));
  }

  void setPolicyCheckbox(bool value) {
    bool updated = state.isPolicyCheck;
    updated = value;
    emit(state.copyWith(isPolicyCheck: updated));
  }

  void setRememberCheckbox(bool value) {
    bool updated = state.isRemember;
    updated = value;
    emit(state.copyWith(isRemember: updated));
  }

  clearValue() {
    emit(
      state.copyWith(
        isLoading: false,
        isPolicyCheck: true,
        isPassShow: false,
        isRemember: false,
        // isLogInWithPhone: false,
        isLogInWithEmail: true,
        isRegister: false,
        emailController: TextEditingController(),
        forgotPasswordEmailController: TextEditingController(),
        passwordController: TextEditingController(),
        // phoneNumberController: TextEditingController(),
      ),
    );
  }

  showLogInWithMobile({bool? isRemember, String? email, String? password}) {
    emit(state.copyWith(
      // isLogInWithPhone: true,
      isLogInWithEmail: true,
      isRegister: false,
      isRemember: isRemember ?? false,
      emailController: TextEditingController(text: email ?? ''),
      forgotPasswordEmailController: TextEditingController(),
      passwordController: TextEditingController(text: password ?? ''),
    ));
  }

  showLogInWithEmail() {
    emit(state.copyWith(
      // isLogInWithPhone: false,
      isLogInWithEmail: true,
      isRegister: false,
      emailController: TextEditingController(),
      forgotPasswordEmailController: TextEditingController(),
      passwordController: TextEditingController(),
    ));
  }

  showRegister() {
    emit(state.copyWith(
      // isLogInWithPhone: false,
      isLogInWithEmail: false,
      isRegister: true,
      emailController: TextEditingController(),
      forgotPasswordEmailController: TextEditingController(),
      passwordController: TextEditingController(),
    ));
  }

  showPassword(bool value) {
    emit(state.copyWith(isPassShow: value));
  }

  ///////////////////////////////////////////////////////////////// Log in with email
  Future<void> onSubmitLogInEmail(BuildContext context) async {
    if (state.emailController!.text.isEmpty) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(showCustomSnackBar(message: 'Please enter a email'));
      AppFunctions.showCustomToast(
          context: context,
          title: "Login",
          description: "Please enter a email");
    } else if (!AppFunctions.checkEmailValidation(
        state.emailController!.text)) {
      AppFunctions.showCustomToast(
          context: context,
          title: "Login",
          description: "Please enter valid email");
      // ScaffoldMessenger.of(context).showSnackBar(
      //     showCustomSnackBar(message: 'Please enter valid email'));
    } else if (state.passwordController!.text.isEmpty) {
      AppFunctions.showCustomToast(
          context: context,
          title: "Login",
          description: 'Please enter a password');
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(showCustomSnackBar(message: 'Please enter a password'));
    }
    // else if (state.isPolicyCheck == false) {
    //   ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
    //       message: 'Please accept privacy policy & Terms of Use'));
    // }
    else {
      await loginWithEmailNPassword(context);
    }
  }

  Future<void> loginWithEmailNPassword(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await AuthRepository.loginWithEmail(data: {
        "email": state.emailController?.text.trim() ?? '',
        "password": state.passwordController?.text ?? '',
      });
      debugPrint('Login Data === ${response.body}');
      if (response.status == true) {
        // await MapUtils.requestLocationPermission(context);
        // await OneSignalNotificationService.requestNotificationPermission();
        Auth logInModel = Auth.fromJson(response.body);
        await PrefService.setValue(
            PrefService.accessToken, logInModel.token ?? '');
        await PrefService.setValue(
            PrefService.email, logInModel.user?.email ?? '');
        await PrefService.setValue(
            PrefService.password, state.passwordController?.text ?? '');
        await PrefService.setValue(PrefService.remember, state.isRemember);
        await PrefService.setValue(
            PrefService.mobileNumber, logInModel.user?.mobileNumber ?? '');
        await PrefService.setValue(
            PrefService.name, logInModel.user?.name ?? '');
        await PrefService.setValue(
            PrefService.userName, logInModel.user?.username ?? '');
        await PrefService.setValue(
            PrefService.dateOfBirth,
            logInModel.user?.dateOfBirth != null
                ? DateFormat('dd/MM/yyyy')
                    .format(logInModel.user!.dateOfBirth!.toLocal())
                : '');
        await PrefService.setValue(
            PrefService.userId, logInModel.user?.id ?? '');
        await PrefService.setValue(
            PrefService.profileUrl, logInModel.user?.profilePicture ?? '');
        await PrefService.setValue(
            PrefService.userRadius, logInModel.user?.userRadius ?? 0);
        await PrefService.setValue(PrefService.isLogin, true);
        await PrefService.setValue(PrefService.emailLogin, true);
        emit(state.copyWith(isLoading: false));
        clearValue();
        await AppFunctions.showToast(response.message);
        context.read<NewsScreenBlocCubit>().init();
        context.read<NewsScreenBlocCubit>().getNewsEvents('latest');
        context.read<HomeScreenBlocCubit>().changePageIndex(0);
        NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.home);
      } else {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

//////////////////////////////////////////////////////////////////////// Phone Number
/*  void onSubmitLogInPhone(BuildContext context) async {
    if (state.phoneNumberController!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          showCustomSnackBar(message: 'Please enter a mobile number'));
    } else if (state.phoneNumberController!.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
          showCustomSnackBar(message: 'Please enter valid mobile number'));
    } else if (state.isPolicyCheck == false) {
      ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          message: 'Please accept privacy policy & Terms of Use'));
    } else {
      await loginWithMobile(context);
    }
  }*/

  void getPhoneCode(String code) {
    emit(state.copyWith(countryCode: code));
  }

  void setCheckbox(bool value) {
    bool updated = state.isPolicyCheck;
    updated = value;
    emit(state.copyWith(isPolicyCheck: updated));
  }

  /*Future<void> loginWithMobile(BuildContext context) async {
    emit(state.copyWith(isLoading: true));

    try {
      ResponseModel response = await AuthRepository.loginWithPhone(data: {
        "mobileNumber":
            "${state.countryCode}${state.phoneNumberController?.text ?? ''}",
      });
      String phone =
          "${state.countryCode}${state.phoneNumberController?.text ?? ''}";
      debugPrint('Login Data === ${response.body}');
      if (response.status == true) {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return VerifyOtpScreen(
              phone: phone,
              isPhone: true,
            );
          },
        ));
        context.read<VerifyOtpCubit>().clearValue();
        clearValue();
      } else {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }*/

  // Register
  Future<void> onSubmitRegister(BuildContext context) async {
    if (state.emailController!.text.isEmpty) {
      AppFunctions.showCustomToast(
          context: context,
          title: "Register",
          description: "Please enter a email");
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(showCustomSnackBar(message: 'Please enter a email'));
    } else if (!AppFunctions.checkEmailValidation(
        state.emailController!.text.trim())) {
      AppFunctions.showCustomToast(
          context: context,
          title: "Register",
          description: "Please enter valid email");
      // ScaffoldMessenger.of(context).showSnackBar(
      //     showCustomSnackBar(message: 'Please enter valid email'));
    } else if (state.passwordController!.text.isEmpty) {
      AppFunctions.showCustomToast(
          context: context,
          title: "Register",
          description: "Please enter a password");
      ScaffoldMessenger.of(context)
          .showSnackBar(showCustomSnackBar(message: 'Please enter a password'));
    } else if (state.isPolicyCheck == false) {
      ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          message: 'Please accept Terms of Use & Privacy Policy'));
    } else {
      await registerWithEmail(context);
    }
  }

  Future<void> registerWithEmail(BuildContext context) async {
    emit(state.copyWith(isLoading: true));

    try {
      ResponseModel response = await AuthRepository.registerWithEmail(data: {
        "email": state.emailController?.text ?? '',
        "password": state.passwordController?.text ?? '',
      });
      String email = state.emailController?.text ?? '';
      debugPrint('register Response === ${response.toJson()}');
      if (response.status == true) {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return VerifyOtpScreen(email: email);
          },
        ));
        context.read<VerifyOtpCubit>().clearValue();
        context.read<VerifyOtpCubit>().startTimer();
        clearValue();
      } else {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      debugPrint('Cache Error ${e.toString()}');
      String errorMessage = getCatchFinalErrorMsg(e);
      AppFunctions.showToast(errorMessage);
    }
  }

  // Forgot password
  // Register
  Future<void> onSubmitForgotPassword(
      BuildContext context, String email) async {
    log("Email :- ${state.forgotPasswordEmailController!.text.trim()}");
    if (!networkConnectionServices.isNetworkConnected) {
      AppFunctions.showToast('Please check internet connection');
    } else {
      if (state.forgotPasswordEmailController!.text.isEmpty) {
        AppFunctions.showToast('Please enter a email');
        ScaffoldMessenger.of(context)
            .showSnackBar(showCustomSnackBar(message: 'Please enter a email'));
      } else if (!AppFunctions.checkEmailValidation(
          state.forgotPasswordEmailController!.text.trim())) {
        AppFunctions.showToast('Please enter valid email');
      } else {
        await forgotPassword(
            context, state.forgotPasswordEmailController?.text ?? '');
      }
    }
  }

  Future<void> forgotPassword(BuildContext context, String email) async {
    emit(state.copyWith(isLoading: true));
    log("Email :-- $email");
    try {
      ResponseModel response = await AuthRepository.forgotPassword(data: {
        "email": state.forgotPasswordEmailController?.text ?? '',
      });
      debugPrint('forgot password Response === ${response.toJson()}');
      if (response.status == true) {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
        context.read<VerifyOtpCubit>().startTimer();
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return VerifyOtpScreen(
              email: email,
              screen: "Forgot Password",
            );
          },
        ));
        context.read<VerifyOtpCubit>().clearValue();
        // clearValue();
      } else {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      String errorMessage = getCatchFinalErrorMsg(e);
      AppFunctions.showToast(errorMessage);
    }
  }

  // Google Login
  Future<void> onClickGoogleLogin(BuildContext context) async {
    if (state.isPolicyCheck == false) {
      ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          message: 'Please accept Terms of Use & Privacy policy'));
    } else {
      await onGoogleClicked(context);
    }
  }

  // Apple Login
  Future<void> onClickAppleLogin(BuildContext context) async {
    if (state.isPolicyCheck == false) {
      ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
          message: 'Please accept Terms of Use & Privacy policy'));
    } else {
      await onAppleSignInClicked(context);
    }
  }

  ///////////////////////// Google sing in
  Future<void> onGoogleClicked(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    bool isNewOnboard = false;
    isNewOnboard = remoteConfig.getBool(RemoteConfigLabel.isNewOnboard);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: [
        'https://www.googleapis.com/auth/userinfo.profile',
        'https://www.googleapis.com/auth/userinfo.email'
      ]).signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      log('userCredential :- ${userCredential.credential}');
      log('email :- ${userCredential.user?.email ?? ""}');
      log('name :- ${userCredential.user?.displayName ?? ""}');
      try {
        ResponseModel response = await AuthRepository.googleSinIn(data: {
          "idToken": userCredential.credential?.accessToken ?? '',
          "email": userCredential.user?.email ?? "",
          "name": userCredential.user?.displayName ?? "",
          "profilePicture": userCredential.user?.photoURL ?? '',
        });
        if (response.status == true) {
          // await MapUtils.requestLocationPermission(context);
          // await OneSignalNotificationService.requestNotificationPermission();
          Auth logInModel = Auth.fromJson(response.body);
          PrefService.setValue(PrefService.accessToken, logInModel.token ?? '');
          PrefService.setValue(
              PrefService.email, userCredential.user?.email ?? '');
          PrefService.setValue(PrefService.password, state.password);
          PrefService.setValue(PrefService.remember, state.isRemember);
          PrefService.setValue(
              PrefService.mobileNumber, logInModel.user?.mobileNumber ?? '');
          PrefService.setValue(
              PrefService.name, userCredential.user?.displayName ?? '');
          await PrefService.setValue(
              PrefService.userName, logInModel.user?.username ?? '');
          PrefService.setValue(
              PrefService.dateOfBirth,
              logInModel.user?.dateOfBirth != null
                  ? DateFormat('dd/MM/yyyy')
                      .format(logInModel.user!.dateOfBirth!)
                  : '');
          PrefService.setValue(PrefService.userId, logInModel.user?.id ?? '');
          PrefService.setValue(
              PrefService.profileUrl, logInModel.user?.profilePicture ?? '');
          PrefService.setValue(PrefService.isLogin, true);
          PrefService.setValue(PrefService.googleLogin, true);
          AppFunctions.showToast(response.message);
          emit(state.copyWith(isLoading: false));
          if (logInModel.user?.isNewUser ?? false) {
            FirebaseEvents.setFirebaseEvent(
                'google_login_success_navigate_obboarding', {});
            context.read<OnboardCubit>().init();
            context.read<OnboardCubit>().setNameFiledData();
            context.read<OnboardCubit>().setUserNameFiledData();
            NavigatorRoute.navigateToRemoveUntil(context,
                isNewOnboard ? AppRoutes.newOnboard : AppRoutes.onboardName);
          } else {
            FirebaseEvents.setFirebaseEvent(
                'google_login_success_navigate_home', {});
            context.read<NewsScreenBlocCubit>().init();
            context.read<NewsScreenBlocCubit>().getNewsEvents('latest');
            NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.home);
          }
          clearValue();
        } else {
          FirebaseEvents.setFirebaseEvent('google_login_failed', {});
          emit(state.copyWith(isLoading: false));
          AppFunctions.showToast(response.message);
        }
      } catch (e) {
        FirebaseEvents.setFirebaseEvent('google_login_failed', {});
        emit(state.copyWith(isLoading: false));
        debugPrint('Cache Error ${e.toString()}');
        AppFunctions.showToast(e.toString());
      }
    } catch (e) {
      FirebaseEvents.setFirebaseEvent('google_login_failed', {});
      emit(state.copyWith(isLoading: false));
      log('exception->$e');
      AppFunctions.showToast('Sign In Failed');
    }
  }

  ///////////////////////// Apple sing in
  Future<void> onAppleSignInClicked(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    bool isNewOnboard = false;
    isNewOnboard = remoteConfig.getBool(RemoteConfigLabel.isNewOnboard);

    try {
      final appleCred = await SignInWithApple.getAppleIDCredential(scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ]);

      final oauthCredential = OAuthProvider('apple.com').credential(
          accessToken: appleCred.authorizationCode,
          idToken: appleCred.identityToken);

      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      log('userCredential :- ${userCredential.credential}');
      log('email :- ${userCredential.user?.email ?? ""}');
      log('name :- ${userCredential.user?.displayName ?? ""}');
      try {
        ResponseModel response = await AuthRepository.appleSinIn(data: {
          "idToken": userCredential.credential?.accessToken ?? '',
          "email": userCredential.user?.email ?? "",
          "name": userCredential.user?.displayName ?? "",
          "profilePicture": userCredential.user?.photoURL ?? '',
        });
        if (response.status == true) {
          // await MapUtils.requestLocationPermission(context);
          // await OneSignalNotificationService.requestNotificationPermission();
          Auth logInModel = Auth.fromJson(response.body);
          PrefService.setValue(PrefService.accessToken, logInModel.token ?? '');
          PrefService.setValue(
              PrefService.email, userCredential.user?.email ?? '');
          PrefService.setValue(PrefService.password, state.password);
          PrefService.setValue(PrefService.remember, state.isRemember);
          await PrefService.setValue(
              PrefService.userName, logInModel.user?.username ?? '');
          PrefService.setValue(
              PrefService.mobileNumber, logInModel.user?.mobileNumber ?? '');
          PrefService.setValue(
              PrefService.name, userCredential.user?.displayName ?? '');
          PrefService.setValue(
              PrefService.dateOfBirth,
              logInModel.user?.dateOfBirth != null
                  ? DateFormat('dd/MM/yyyy')
                      .format(logInModel.user!.dateOfBirth!)
                  : '');
          PrefService.setValue(PrefService.userId, logInModel.user?.id ?? '');
          PrefService.setValue(
              PrefService.profileUrl, logInModel.user?.profilePicture ?? '');
          PrefService.setValue(PrefService.isLogin, true);
          PrefService.setValue(PrefService.appleLogin, true);
          AppFunctions.showToast(response.message);
          emit(state.copyWith(isLoading: false));
          if (logInModel.user?.isNewUser ?? false) {
            FirebaseEvents.setFirebaseEvent(
                'apple_login_success_navigate_obboarding', {});
            context.read<OnboardCubit>().init();
            context.read<OnboardCubit>().setNameFiledData();
            context.read<OnboardCubit>().setUserNameFiledData();
            NavigatorRoute.navigateToRemoveUntil(context,
                isNewOnboard ? AppRoutes.newOnboard : AppRoutes.onboardName);
          } else {
            FirebaseEvents.setFirebaseEvent(
                'apple_login_success_navigate_home', {});
            context.read<NewsScreenBlocCubit>().init();
            context.read<NewsScreenBlocCubit>().getNewsEvents('latest');
            NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.home);
          }
          clearValue();
        } else {
          FirebaseEvents.setFirebaseEvent('apple_login_failed', {});
          emit(state.copyWith(isLoading: false));
          AppFunctions.showToast(response.message);
        }
      } catch (e) {
        FirebaseEvents.setFirebaseEvent('apple_login_failed', {});
        emit(state.copyWith(isLoading: false));
        debugPrint('Cache Error ${e.toString()}');
        AppFunctions.showToast(e.toString());
      }
    } catch (e) {
      FirebaseEvents.setFirebaseEvent('apple_login_failed', {});
      emit(state.copyWith(isLoading: false));
      log('exception->$e');
      AppFunctions.showToast('Sign In Failed');
    }
  }
}
