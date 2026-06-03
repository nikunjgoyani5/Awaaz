import 'dart:developer';

import 'package:eagle_eye/core/utils/app_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/app_prefrence.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/main_repo.dart';
import '../../../../routes/app_navigation.dart';
import '../../../../routes/app_routes.dart';
import '../../home/bloc/home_screen_bloc_cubit.dart';

part 'delete_account_cubit.freezed.dart';
part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(const DeleteAccountState.initial());

  Future<void> deleteUserAccount(BuildContext context) async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await MainRepository.deleteUserAccount();
      if (response.status == true) {
        AppFunctions.showToast('Delete Account Success');
        context.read<HomeScreenBlocCubit>().changePageIndex(0);
        NavigatorRoute.navigateToRemoveUntil(context, AppRoutes.accountRemove);
        PrefService.clear();
        await AppFunctions.googleSignOut();
        emit(state.copyWith(isLoading: false));
      } else {
        AppFunctions.showToast('Delete Account Failed');
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      log('Cache Error ${e.toString()}');
      emit(state.copyWith(isLoading: false));
    }
  }
}
