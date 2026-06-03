import 'dart:developer';

// import 'package:bloc/bloc.dart';
import 'package:eagle_eye/presentation/main/news_screen/bloc/news_screen_bloc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/app_functions.dart';
import '../../../../data/models/other_user_profile_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/main_repo.dart';

part 'user_profile_cubit.freezed.dart';
part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(const UserProfileState());

  init() {
    emit(state.copyWith(isLoading: false, reason: ''));
  }

  getUserId(String userId) {
    emit(state.copyWith(userId: userId));
  }

  Future<void> reportUser() async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await MainRepository.report(data: {
        "reportedUserId": state.userId,
        "reason": state.reason,
        "reportType": "user"
      });
      if (response.status == true) {
        emit(state.copyWith(
          isLoading: false,
        ));
        AppFunctions.showToast(response.message);
      } else {
        AppFunctions.showToast(response.message);
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      log('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

  Future<void> blockUser(
      {bool? isFromProfile, String? uid, required BuildContext context}) async {
    // emit(state.copyWith(isLoading: true));

    try {
      ResponseModel response = await MainRepository.blockUser(data: {
        "blockUserId": uid ?? state.userId,
      });
      if (response.status == true) {
        // emit(state.copyWith(
        //   isLoading: false,
        // ));
        AppFunctions.showToast(response.message);
        if (isFromProfile ?? false) {
          getUserInfo();
        }

        context.read<NewsScreenBlocCubit>().getNewsEvents('latest');
      } else {
        AppFunctions.showToast(response.message);
        // emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      // emit(state.copyWith(isLoading: false));
      log('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }

  void getReason(String reasonString) {
    emit(state.copyWith(reason: reasonString));
  }

  Future<void> getUserInfo() async {
    emit(state.copyWith(isLoading: true, otherUserProfileData: null));
    try {
      ResponseModel response =
          await MainRepository.getOtherUserProfile(state.userId);
      if (response.status == true && response.body != null) {
        OtherUserProfileData otherUserProfileData =
            OtherUserProfileData.fromJson(response.body);
        emit(state.copyWith(
          isLoading: false,
          otherUserProfileData: otherUserProfileData,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      log('Cache Error ${e.toString()}');
      AppFunctions.showToast(e.toString());
    }
  }
}
