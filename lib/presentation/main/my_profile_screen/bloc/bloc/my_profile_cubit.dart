import 'package:bloc/bloc.dart';
import 'package:eagle_eye/data/models/draft_event_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/app_functions.dart';
import '../../../../../core/utils/app_prefrence.dart';
import '../../../../../data/models/my_profile_model.dart';
import '../../../../../data/models/response_model.dart';
import '../../../../../data/repositories/main_repo.dart';

part 'my_profile_cubit.freezed.dart';
part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  MyProfileCubit() : super(const MyProfileState());

  init() async {
    emit(state.copyWith(
        isLoading: false, myProfile: null, currentIndex: 0, draftEvent: null));
    await getProfileData();
    await getProfileDraftData();
  }

  setProfile() {
    emit(state.copyWith(
        profilePic: PrefService.getString(PrefService.profileUrl),
        name: PrefService.getString(PrefService.name)));
  }

  Future<void> getProfileData() async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await MainRepository.getMyProfile();
      if (response.status == true) {
        MyProfile myProfile = MyProfile.fromJson(response.body);
        emit(state.copyWith(userName: myProfile.userName ?? ''));
        PrefService.setValue(PrefService.name, myProfile.name ?? '');
        PrefService.setValue(PrefService.userName, myProfile.userName ?? '');
        PrefService.setValue(
            PrefService.dateOfBirth, myProfile.dateOfBirth ?? '');
        PrefService.setValue(
            PrefService.profileUrl, myProfile.profilePicture ?? '');
        PrefService.setValue(PrefService.userRadius, myProfile.userRadius ?? 0);
        emit(state.copyWith(isLoading: false, myProfile: myProfile));
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

  Future<void> getProfileDraftData() async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await MainRepository.getMyDraftData();
      if (response.status == true) {
        DraftEventModel draftEventModel =
            DraftEventModel.fromJson(response.toJson());
        emit(state.copyWith(isLoading: false, draftEvent: draftEventModel));
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

  Future<void> getSavedPostList() async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await MainRepository.savedPostList();
      if (response.status == true) {
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

  void changeIndex(int value) {
    emit(state.copyWith(currentIndex: value));
  }
}
