import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/widget/common_snack_bar.dart';
import 'package:eagle_eye/data/models/response_model.dart';
import 'package:eagle_eye/data/repositories/auth_repo.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:eagle_eye/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_screen_cubit.freezed.dart';
part 'reset_password_screen_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(const ResetPasswordState());

  init() {
    emit(
      state.copyWith(
        isLoading: false,
        isShowConfirmPassword: true,
        isShowPassword: true,
        newPasswordController: TextEditingController(),
        confirmPasswordController: TextEditingController(),
        resetPasswordKey: GlobalKey<FormState>(),
      ),
    );
  }

  onShowNewPassword() {
    if (state.isShowPassword) {
      emit(
        state.copyWith(
          isShowPassword: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isShowPassword: true,
        ),
      );
    }
  }

  onShowConfirmNewPassword() {
    if (state.isShowConfirmPassword) {
      emit(
        state.copyWith(
          isShowConfirmPassword: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isShowConfirmPassword: true,
        ),
      );
    }
  }

  Future<void> onSubmitResetPassword(BuildContext context, String email) async {
    if (state.newPasswordController!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          showCustomSnackBar(message: 'Please enter new password'));
    } else if (state.confirmPasswordController!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          showCustomSnackBar(message: 'Please enter confirm password'));
    } else if (state.confirmPasswordController!.text !=
        state.newPasswordController!.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          showCustomSnackBar(message: 'Confirm new password is not matches'));
    } else {
      await resetPassword(context, email);
    }
  }

  resetPassword(BuildContext context, String email) async {
    emit(state.copyWith(isLoading: true));
    ResponseModel response = await AuthRepository.resetPassword(
        password: state.newPasswordController?.text ?? '', email: email);
    try {
      if (response.status == true) {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
        NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.authScreen);
      } else {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      AppFunctions.showToast(e.toString());
    }
  }
}
