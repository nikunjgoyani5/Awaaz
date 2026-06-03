import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:eagle_eye/core/widget/common_snack_bar.dart';
import 'package:eagle_eye/data/models/response_model.dart';
import 'package:eagle_eye/data/repositories/auth_repo.dart';
import 'package:eagle_eye/routes/app_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_screen_cubit.freezed.dart';
part 'change_password_screen_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(const ChangePasswordState());

  init() {
    emit(
      state.copyWith(
        isLoading: false,
        isShowConfirmPassword: true,
        isShowPassword: true,
        isShowOldPassword: true,
        oldPasswordController: TextEditingController(),
        newPasswordController: TextEditingController(),
        confirmPasswordController: TextEditingController(),
        resetPasswordKey: GlobalKey<FormState>(),
      ),
    );
  }

  onShowOldPassword() {
    if (state.isShowOldPassword) {
      emit(
        state.copyWith(
          isShowOldPassword: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isShowOldPassword: true,
        ),
      );
    }
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

  Future<void> onSubmitChangePassword(BuildContext context) async {
    if (state.oldPasswordController!.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          showCustomSnackBar(message: 'Please enter old password'));
    } else if (state.newPasswordController!.text.isEmpty) {
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
      await changePassword(context);
    }
  }

  changePassword(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await AuthRepository.changePassword(
          newPassword: state.newPasswordController!.text,
          oldPassword: state.oldPasswordController!.text);
      debugPrint('Login Data === ${response.body}');
      if (response.status == true) {
        emit(state.copyWith(isLoading: false));
        AppFunctions.showToast(response.message);
        NavigatorRoute.navigateBack(context);
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
}
