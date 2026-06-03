// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfileState {
  bool get isLoading;
  String get userId;
  String get reason;
  OtherUserProfileData? get otherUserProfileData;

  /// Create a copy of UserProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserProfileStateCopyWith<UserProfileState> get copyWith =>
      _$UserProfileStateCopyWithImpl<UserProfileState>(
          this as UserProfileState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserProfileState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.otherUserProfileData, otherUserProfileData) ||
                other.otherUserProfileData == otherUserProfileData));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, userId, reason, otherUserProfileData);

  @override
  String toString() {
    return 'UserProfileState(isLoading: $isLoading, userId: $userId, reason: $reason, otherUserProfileData: $otherUserProfileData)';
  }
}

/// @nodoc
abstract mixin class $UserProfileStateCopyWith<$Res> {
  factory $UserProfileStateCopyWith(
          UserProfileState value, $Res Function(UserProfileState) _then) =
      _$UserProfileStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      String userId,
      String reason,
      OtherUserProfileData? otherUserProfileData});
}

/// @nodoc
class _$UserProfileStateCopyWithImpl<$Res>
    implements $UserProfileStateCopyWith<$Res> {
  _$UserProfileStateCopyWithImpl(this._self, this._then);

  final UserProfileState _self;
  final $Res Function(UserProfileState) _then;

  /// Create a copy of UserProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? userId = null,
    Object? reason = null,
    Object? otherUserProfileData = freezed,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserProfileData: freezed == otherUserProfileData
          ? _self.otherUserProfileData
          : otherUserProfileData // ignore: cast_nullable_to_non_nullable
              as OtherUserProfileData?,
    ));
  }
}

/// @nodoc

class _Initial extends UserProfileState {
  const _Initial(
      {this.isLoading = false,
      this.userId = '',
      this.reason = '',
      this.otherUserProfileData})
      : super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String userId;
  @override
  @JsonKey()
  final String reason;
  @override
  final OtherUserProfileData? otherUserProfileData;

  /// Create a copy of UserProfileState
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
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.otherUserProfileData, otherUserProfileData) ||
                other.otherUserProfileData == otherUserProfileData));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isLoading, userId, reason, otherUserProfileData);

  @override
  String toString() {
    return 'UserProfileState(isLoading: $isLoading, userId: $userId, reason: $reason, otherUserProfileData: $otherUserProfileData)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $UserProfileStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      String userId,
      String reason,
      OtherUserProfileData? otherUserProfileData});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of UserProfileState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? userId = null,
    Object? reason = null,
    Object? otherUserProfileData = freezed,
  }) {
    return _then(_Initial(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _self.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      otherUserProfileData: freezed == otherUserProfileData
          ? _self.otherUserProfileData
          : otherUserProfileData // ignore: cast_nullable_to_non_nullable
              as OtherUserProfileData?,
    ));
  }
}

// dart format on
