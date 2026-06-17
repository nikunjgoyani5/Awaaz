import 'dart:developer';


import 'package:eagle_eye_admin/api/repository/auth_repository.dart';
import 'package:eagle_eye_admin/model/response_model.dart';
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
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegisterController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool isPasswordSecure = true;
  final formKey = GlobalKey<FormState>();

  Future<void> registerWithEmail(
      BuildContext context, ProgressLoader pl)
  async {
    if (formKey.currentState!.validate() == true) {

      // try {
      //   var res = await AuthRepository.registerWithEmail(
      //       email: emailController.text,
      //       password: passwordController.text,
      //       context: context);
      //   await openRegistrationSuccessDialog(res?.data['message'] ?? "");
      //   emailController.clear();
      //   passwordController.clear();
      //   await pl.hide();
      // } on DioException catch (e) {
      //   await pl.hide();
      //   showToast(
      //       context: context,
      //       title: 'Register',
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
        ResponseModel response = await AuthRepository.registerWithEmail(
          context: context,

          email:
           emailController.text,
       password:  passwordController.text,
name: nameController.text
        );

        if ( response.status == true ) {
          await pl.hide();
          showDialog(
            context: context,

            builder: (context) {
              return RegistrationSuccessDailoge(
                message: response.message,
              );
            },
          );


            emailController.clear();
            passwordController.clear();

        }
        else {
            showToast(
                context: context,
                title: 'Register',
                message:
                    response.message ,

                bgColor: AppColors.red);
        }
        await pl.hide();
      } catch (e) {

        await pl.hide();
        debugPrint('Cache Error ${e.toString()}');
      }
    }
  }




  openRegistrationSuccessDialog(String message, BuildContext context) async {




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
      ResponseModel response = await AuthRepository.loginWithGoogle(
        context: context,
        email: userCredential.user?.email ?? '',

      );
      debugPrint('Login Data === ${response.body}');
      try {
  if(response.status== true){
    if (response.message.toLowerCase() ==
        "Please wait for approval. You will receive an email once approved."
            .toLowerCase()) {
      await pl.hide();
      await openRegistrationSuccessDialog(response.message ,context);
    } else if (response.message.toLowerCase() ==
        "Please wait for approval.".toLowerCase()) {
      await pl.hide();
      showToast(
        context: context,
        title: 'Google Sign In!',
        message: response.message.toString()
        ,
      );
    } else {
      await pl.hide();
      Body userData = Body.fromJson(response.body);
      StorageService.storeToken(userData.token ?? '');
      StorageService.saveEmail(userData.user?.email ?? '');
      log("Previous Route :- ${Get.previousRoute}");
      Future.delayed(const Duration(milliseconds: 200)).then(
            (value) {
          NavigatorRoute.navigateToRemoveUntil(AppRoutes.event,context);
        },
      );
    }
  }
  else {
    await pl.hide();

    showToast(
        context: context,
        title: 'Google Sign In!',
        message: response.message.toString(),
        bgColor: AppColors.red);
  }
      }
      catch (e) {
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
}
