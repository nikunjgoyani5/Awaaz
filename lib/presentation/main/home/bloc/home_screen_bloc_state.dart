part of 'home_screen_bloc_cubit.dart';

@freezed
class HomeScreenBlocState with _$HomeScreenBlocState {
  const HomeScreenBlocState._();
  const factory HomeScreenBlocState({
    @Default(0) int currentPageIndex,
    @Default(false) bool isBottomHide,
  }) = _Initial;

  @override
  // TODO: implement currentPageIndex
  int get currentPageIndex => throw UnimplementedError();

  @override
  // TODO: implement isBottomHide
  bool get isBottomHide => throw UnimplementedError();
}
