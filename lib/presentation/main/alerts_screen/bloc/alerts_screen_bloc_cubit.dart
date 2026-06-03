import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/models/notification_alert_list_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/repositories/main_repo.dart';

part 'alerts_screen_bloc_cubit.freezed.dart';
part 'alerts_screen_bloc_state.dart';

class AlertsScreenBlocCubit extends Cubit<AlertsScreenBlocState> {
  AlertsScreenBlocCubit() : super(const AlertsScreenBlocState());

  void init() {
    emit(state.copyWith(
      notificationList: [],
      currentPage: 1,
      isBottomLoading: false,
      isLoading: false,
    ));
  }

  Future<void> getNotificationAlerts({int page = 1}) async {
    emit(state.copyWith(isLoading: page == 1, isBottomLoading: page > 1));
    try {
      // Fetch data from API with the current page number
      ResponseModel response =
          await MainRepository.getNotificationAlertList(page);

      if (response.status == true && response.body != null) {
        NotificationAlertList alertModel =
            NotificationAlertList.fromJson(response.toJson());

        List<NotificationData> newNotifications =
            alertModel.body?.notifications ?? [];
        int currentPage = alertModel.body?.page ?? 1;
        int totalPage = alertModel.body?.totalPages ?? 1;

        if (currentPage == 1) {
          emit(state.copyWith(
            notificationList: newNotifications,
            isLoading: false,
            isBottomLoading: false,
            currentPage: currentPage,
            totalPages: totalPage,
          ));
          return;
        } else {
          // Check if it's the first page or if we are appending data
          List<NotificationData> updatedList = List.from(state.notificationList!)
            ..addAll(newNotifications);
          emit(state.copyWith(
            notificationList: updatedList,
            isLoading: false,
            isBottomLoading: false,
            currentPage: currentPage,
            totalPages: totalPage,
          ));
          return;
        }
      } else {
        emit(state.copyWith(
          isLoading: false,
          isBottomLoading: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isBottomLoading: false,
      ));
      log('Error fetching notifications: ${e.toString()}');
    }
  }

  // Function to load more data when user scrolls
  Future<void> loadMoreNotifications() async {
    if (state.currentPage < state.totalPages) {
      // Fetch the next page
      await getNotificationAlerts(page: state.currentPage + 1);
    }
  }
}
