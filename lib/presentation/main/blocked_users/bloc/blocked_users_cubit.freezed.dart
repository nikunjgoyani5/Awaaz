// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocked_users_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockedUsersState {
  dynamic get isLoading;
  bool get isSearch;
  List<BlockedUserData> get blockedUserList;
  List<BlockedUserData> get filteredBlockedUserList; // For search results
  String get searchQuery;

  /// Create a copy of BlockedUsersState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BlockedUsersStateCopyWith<BlockedUsersState> get copyWith =>
      _$BlockedUsersStateCopyWithImpl<BlockedUsersState>(
          this as BlockedUsersState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BlockedUsersState &&
            const DeepCollectionEquality().equals(other.isLoading, isLoading) &&
            (identical(other.isSearch, isSearch) ||
                other.isSearch == isSearch) &&
            const DeepCollectionEquality()
                .equals(other.blockedUserList, blockedUserList) &&
            const DeepCollectionEquality().equals(
                other.filteredBlockedUserList, filteredBlockedUserList) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isLoading),
      isSearch,
      const DeepCollectionEquality().hash(blockedUserList),
      const DeepCollectionEquality().hash(filteredBlockedUserList),
      searchQuery);

  @override
  String toString() {
    return 'BlockedUsersState(isLoading: $isLoading, isSearch: $isSearch, blockedUserList: $blockedUserList, filteredBlockedUserList: $filteredBlockedUserList, searchQuery: $searchQuery)';
  }
}

/// @nodoc
abstract mixin class $BlockedUsersStateCopyWith<$Res> {
  factory $BlockedUsersStateCopyWith(
          BlockedUsersState value, $Res Function(BlockedUsersState) _then) =
      _$BlockedUsersStateCopyWithImpl;
  @useResult
  $Res call(
      {dynamic isLoading,
      bool isSearch,
      List<BlockedUserData> blockedUserList,
      List<BlockedUserData> filteredBlockedUserList,
      String searchQuery});
}

/// @nodoc
class _$BlockedUsersStateCopyWithImpl<$Res>
    implements $BlockedUsersStateCopyWith<$Res> {
  _$BlockedUsersStateCopyWithImpl(this._self, this._then);

  final BlockedUsersState _self;
  final $Res Function(BlockedUsersState) _then;

  /// Create a copy of BlockedUsersState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = freezed,
    Object? isSearch = null,
    Object? blockedUserList = null,
    Object? filteredBlockedUserList = null,
    Object? searchQuery = null,
  }) {
    return _then(_self.copyWith(
      isLoading: freezed == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isSearch: null == isSearch
          ? _self.isSearch
          : isSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      blockedUserList: null == blockedUserList
          ? _self.blockedUserList
          : blockedUserList // ignore: cast_nullable_to_non_nullable
              as List<BlockedUserData>,
      filteredBlockedUserList: null == filteredBlockedUserList
          ? _self.filteredBlockedUserList
          : filteredBlockedUserList // ignore: cast_nullable_to_non_nullable
              as List<BlockedUserData>,
      searchQuery: null == searchQuery
          ? _self.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _Initial extends BlockedUsersState {
  const _Initial(
      {this.isLoading = false,
      this.isSearch = false,
      final List<BlockedUserData> blockedUserList = const [],
      final List<BlockedUserData> filteredBlockedUserList = const [],
      this.searchQuery = ''})
      : _blockedUserList = blockedUserList,
        _filteredBlockedUserList = filteredBlockedUserList,
        super._();

  @override
  @JsonKey()
  final dynamic isLoading;
  @override
  @JsonKey()
  final bool isSearch;
  final List<BlockedUserData> _blockedUserList;
  @override
  @JsonKey()
  List<BlockedUserData> get blockedUserList {
    if (_blockedUserList is EqualUnmodifiableListView) return _blockedUserList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_blockedUserList);
  }

  final List<BlockedUserData> _filteredBlockedUserList;
  @override
  @JsonKey()
  List<BlockedUserData> get filteredBlockedUserList {
    if (_filteredBlockedUserList is EqualUnmodifiableListView)
      return _filteredBlockedUserList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredBlockedUserList);
  }

// For search results
  @override
  @JsonKey()
  final String searchQuery;

  /// Create a copy of BlockedUsersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InitialCopyWith<_Initial> get copyWith =>
      __$InitialCopyWithImpl<_Initial>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Initial &&
            const DeepCollectionEquality().equals(other.isLoading, isLoading) &&
            (identical(other.isSearch, isSearch) ||
                other.isSearch == isSearch) &&
            const DeepCollectionEquality()
                .equals(other._blockedUserList, _blockedUserList) &&
            const DeepCollectionEquality().equals(
                other._filteredBlockedUserList, _filteredBlockedUserList) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isLoading),
      isSearch,
      const DeepCollectionEquality().hash(_blockedUserList),
      const DeepCollectionEquality().hash(_filteredBlockedUserList),
      searchQuery);

  @override
  String toString() {
    return 'BlockedUsersState(isLoading: $isLoading, isSearch: $isSearch, blockedUserList: $blockedUserList, filteredBlockedUserList: $filteredBlockedUserList, searchQuery: $searchQuery)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $BlockedUsersStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {dynamic isLoading,
      bool isSearch,
      List<BlockedUserData> blockedUserList,
      List<BlockedUserData> filteredBlockedUserList,
      String searchQuery});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of BlockedUsersState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = freezed,
    Object? isSearch = null,
    Object? blockedUserList = null,
    Object? filteredBlockedUserList = null,
    Object? searchQuery = null,
  }) {
    return _then(_Initial(
      isLoading: freezed == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isSearch: null == isSearch
          ? _self.isSearch
          : isSearch // ignore: cast_nullable_to_non_nullable
              as bool,
      blockedUserList: null == blockedUserList
          ? _self._blockedUserList
          : blockedUserList // ignore: cast_nullable_to_non_nullable
              as List<BlockedUserData>,
      filteredBlockedUserList: null == filteredBlockedUserList
          ? _self._filteredBlockedUserList
          : filteredBlockedUserList // ignore: cast_nullable_to_non_nullable
              as List<BlockedUserData>,
      searchQuery: null == searchQuery
          ? _self.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
