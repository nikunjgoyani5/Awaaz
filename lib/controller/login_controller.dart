import 'dart:developer';

import 'package:eagle_eye_admin/api/repository/auth_repository.dart';
import 'package:eagle_eye_admin/controller/event_controller.dart';
import 'package:eagle_eye_admin/model/user_model.dart';
import 'package:eagle_eye_admin/route/app_route.dart';
import 'package:eagle_eye_admin/route/navigator_route.dart';
import 'package:eagle_eye_admin/service/storage/storage_service.dart';
import 'package:eagle_eye_admin/theme/colors.dart';
import 'package:eagle_eye_admin/theme/progress_loader.dart';
import 'package:eagle_eye_admin/widget/dailoges.dart';
import 'package:eagle_eye_admin/widget/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/response_model.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isPasswordSecure = true;
  bool keepMeLogin = false;
  final formKey = GlobalKey<FormState>();

  Future<void> loginWithEmailNPasssword(
      BuildContext context, ProgressLoader pl) async {
    if (formKey.currentState?.validate() == true) {
      try {
        await pl.show();
        ResponseModel response =
            await AuthRepository.loginWithEmail(context: context, data: {
          "email": emailController.text,
          "password": passwordController.text,
        });
        debugPrint('Login Data === ${response.body}');
        if (response.status == true && response.body != null) {
          Body logInModel = Body.fromJson(response.body);
          StorageService.storeToken(logInModel.token ?? '');
          StorageService.saveEmail(logInModel.user?.email ?? '');
          StorageService.saveName(logInModel.user?.name ?? '');
          StorageService.saveProfilePic(logInModel.user?.profilePicture ?? '');
          StorageService.savePass(passwordController.text);
          StorageService.saveCredentials(keepMeLogin);
          StorageService.saveSelectedTab(0);
          if (Get.isRegistered<EventController>()) {
            EventController controller = Get.find();
            controller.selectedSubTab = 1.1;
          }

          log("Previous Route :- ${Get.previousRoute}");

          Future.delayed(const Duration(milliseconds: 200)).then(
            (value) {
              if (logInModel.user?.role == 'owner') {
                StorageService.saveIsSuperAdmin(true);
                // NavigatorRoute.navigateToRemoveUntil(AppRoutes.superAdminDashboard);
                NavigatorRoute.navigateToRemoveUntil(AppRoutes.event, context);
              } else {
                StorageService.saveIsSuperAdmin(false);
                NavigatorRoute.navigateToRemoveUntil(AppRoutes.event, context);
              }
            },
          );
          emailController.clear();
          passwordController.clear();
          keepMeLogin = false;
        } else {
          showToast(
              context: context,
              title: 'Login',
              message: response.message,
              bgColor: AppColors.red);
        }
        await pl.hide();
      } catch (e) {
        showToast(
            context: context,
            title: 'Login',
            message: 'Something went wrong',
            bgColor: AppColors.red);

        await pl.hide();
        debugPrint('Cache Error ${e.toString()}');
      }
      await pl.hide();
    }
  }

  openRegistrationSuccessDialog(String message, BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return RegistrationSuccessDailoge(
          message: message,
        );
      },
    );

    NavigatorRoute.navigateToRemoveUntil(AppRoutes.login, context);
  }

  Future<void> onGoogleClicked(BuildContext context, ProgressLoader pl) async {
    await pl.show();
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: [
          'https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/userinfo.email'
        ],
        clientId:
            "1086312563652-peu6sr39o54kor55b99h3bl220g1lj2q.apps.googleusercontent.com",
      ).signIn();

      if (googleUser == null) {
        await pl.hide();
        showToast(
            context: context,
            title: 'Google Sign In!',
            message: 'Sign in aborted by user',
            bgColor: AppColors.red);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      log('userCredential :- ${userCredential.credential}');
      log('email :- ${userCredential.user?.email ?? ""}');
      log('name :- ${userCredential.user?.displayName ?? ""}');
      ResponseModel response = await AuthRepository.loginWithGoogle(
        context: context,
        email: userCredential.user?.email ?? '',
      );
      debugPrint('Login Data === ${response.body}');
      try {
        if (response.status == true) {
          if (response.message.toLowerCase() ==
              "Please wait for approval. You will receive an email once approved."
                  .toLowerCase()) {
            await pl.hide();
            await openRegistrationSuccessDialog(response.message, context);
          } else if (response.message.toLowerCase() ==
              "Please wait for approval.".toLowerCase()) {
            await pl.hide();
            showToast(
              context: context,
              title: 'Google Sign In!',
              message: response.message.toString(),
            );
          } else {
            await pl.hide();
            Body userData = Body.fromJson(response.body);
            StorageService.storeToken(userData.token ?? '');
            StorageService.saveEmail(userData.user?.email ?? '');
            log("Previous Route :- ${Get.previousRoute}");
            Future.delayed(const Duration(milliseconds: 200)).then(
              (value) {
                NavigatorRoute.navigateToRemoveUntil(AppRoutes.event, context);
              },
            );
          }
        } else {
          showToast(
              context: context,
              title: 'Google Sign In!',
              message: response.message.toString(),
              bgColor: AppColors.red);
        }
        await pl.hide();
      } catch (e) {
        await pl.hide();
        log('exception->$e');
        showToast(
            context: context,
            title: 'Google Sign In!',
            message: e.toString(),
            bgColor: AppColors.red);
      }
    } catch (e) {
      await pl.hide();
      log('exception->$e');
      showToast(
          context: context,
          title: 'Register!',
          message: 'Google Sign In Failed',
          bgColor: AppColors.red);
    }
  }

  getLoginData() {
    bool isSavedCredentials = StorageService.getIsSaveCredentials() ?? false;

    if (isSavedCredentials) {
      emailController.text = StorageService.getEmail() ?? '';
      passwordController.text = StorageService.getPass() ?? '';
      update();
    }
  }
}
