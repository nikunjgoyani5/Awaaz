import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/main_repo.dart';

part 'home_screen_bloc_cubit.freezed.dart';
part 'home_screen_bloc_state.dart';

class HomeScreenBlocCubit extends Cubit<HomeScreenBlocState> {
  HomeScreenBlocCubit() : super(const HomeScreenBlocState());

  changePageIndex(int index) {
    emit(state.copyWith(currentPageIndex: index));
  }

  changeIsBottomHide(bool val) {
    emit(state.copyWith(isBottomHide: val));
  }

  Future<void> updatePushToken() async {
    String token = PrefService.getString(PrefService.oneSignalSubscriptionId);
    try {
      ResponseModel response = await MainRepository.updatePushToken(data: {
        "pushToken": token,
      });
      if (response.status == true) {
        log('Token updated ');
      }
    } catch (e) {
      log('Cache Error ${e.toString()}');
    }
  }
}
