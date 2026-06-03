part of 'alerts_screen_bloc_cubit.dart';

@freezed
class AlertsScreenBlocState with _$AlertsScreenBlocState {
  const AlertsScreenBlocState._();
  const factory AlertsScreenBlocState({
    @Default(false) bool isLoading,
    @Default(false) bool isBottomLoading,
    List<NotificationData>? notificationList,
    @Default(0) int currentPage,
    @Default(0) int totalPages,
  }) = _Initial;

  @override
  // TODO: implement currentPage
  int get currentPage => throw UnimplementedError();

  @override
  // TODO: implement isBottomLoading
  bool get isBottomLoading => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement notificationList
  List<NotificationData>? get notificationList => throw UnimplementedError();

  @override
  // TODO: implement totalPages
  int get totalPages => throw UnimplementedError();

}
