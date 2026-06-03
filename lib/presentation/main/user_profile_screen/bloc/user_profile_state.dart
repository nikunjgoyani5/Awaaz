part of 'user_profile_cubit.dart';

@freezed
class UserProfileState with _$UserProfileState {
  const UserProfileState._();
  const factory UserProfileState({
    @Default(false) bool isLoading,
    @Default('') String userId,
    @Default('') String reason,
    OtherUserProfileData? otherUserProfileData,
  }) = _Initial;

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement otherUserProfileData
  OtherUserProfileData? get otherUserProfileData => throw UnimplementedError();

  @override
  // TODO: implement reason
  String get reason => throw UnimplementedError();

  @override
  // TODO: implement userId
  String get userId => throw UnimplementedError();

}