part of 'my_profile_cubit.dart';

@freezed
class MyProfileState with _$MyProfileState {
  const MyProfileState._();
  const factory MyProfileState({
    @Default(false) bool isLoading,
    MyProfile? myProfile,
    @Default(0) int currentIndex,
    @Default('') String profilePic,
    @Default('User') String name,
    @Default('username') String userName,
    DraftEventModel? draftEvent,
  }) = _Initial;

  @override
  // TODO: implement currentIndex
  int get currentIndex => throw UnimplementedError();

  @override
  // TODO: implement draftEvent
  DraftEventModel? get draftEvent => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement myProfile
  MyProfile? get myProfile => throw UnimplementedError();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  // TODO: implement profilePic
  String get profilePic => throw UnimplementedError();

  @override
  // TODO: implement userName
  String get userName => throw UnimplementedError();

}