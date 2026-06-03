import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eagle_eye/data/models/blocked_user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/main_repo.dart';

part 'blocked_users_cubit.freezed.dart';
part 'blocked_users_state.dart';

class BlockedUsersCubit extends Cubit<BlockedUsersState> {
  BlockedUsersCubit() : super(const BlockedUsersState());

  init() {
    emit(state.copyWith(isLoading: false, blockedUserList: []));
  }

  Future<void> getBlockedUserList({bool? isLoading}) async {
    if (isLoading ?? false) {
      emit(state.copyWith(isLoading: true));
    }
    try {
      ResponseModel response = await MainRepository.blockedUserList();
      if (response.status == true && response.body != null) {
        BlockedUserModel inThisAreaResponseModel =
            BlockedUserModel.fromJson(response.toJson());
        List<BlockedUserData> tempList = inThisAreaResponseModel.body ?? [];
        emit(state.copyWith(isLoading: false, blockedUserList: tempList));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
      ));
      log('Cache Error ${e.toString()}');
    }
  }

  void toggleSearch() {
    emit(state.copyWith(isSearch: !state.isSearch));
  }

  void searchBlockedUsers(String query) {
    final filteredList = state.blockedUserList
        .where((user) => user.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(state.copyWith(
        searchQuery: query, filteredBlockedUserList: filteredList));
  }
}
