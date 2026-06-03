part of 'blocked_users_cubit.dart';

@freezed
class BlockedUsersState with _$BlockedUsersState {
  const BlockedUsersState._();
  const factory BlockedUsersState({
    @Default(false) isLoading,
    @Default(false) bool isSearch,
    @Default([]) List<BlockedUserData> blockedUserList,
    @Default([])
    List<BlockedUserData> filteredBlockedUserList, // For search results
    @Default('') String searchQuery,
  }) = _Initial;

  @override
  // TODO: implement blockedUserList
  List<BlockedUserData> get blockedUserList => throw UnimplementedError();

  @override
  // TODO: implement filteredBlockedUserList
  List<BlockedUserData> get filteredBlockedUserList =>
      throw UnimplementedError();

  @override
  // TODO: implement isLoading
  get isLoading => throw UnimplementedError();

  @override
  // TODO: implement isSearch
  bool get isSearch => throw UnimplementedError();

  @override
  // TODO: implement searchQuery
  String get searchQuery => throw UnimplementedError();

}
