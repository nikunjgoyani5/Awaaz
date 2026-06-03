// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'my_profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyProfileState {
  bool get isLoading;
  MyProfile? get myProfile;
  int get currentIndex;
  String get profilePic;
  String get name;
  String get userName;
  DraftEventModel? get draftEvent;

  /// Create a copy of MyProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MyProfileStateCopyWith<MyProfileState> get copyWith =>
      _$MyProfileStateCopyWithImpl<MyProfileState>(
          this as MyProfileState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MyProfileState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.myProfile, myProfile) ||
                other.myProfile == myProfile) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.profilePic, profilePic) ||
                other.profilePic == profilePic) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.draftEvent, draftEvent) ||
                other.draftEvent == draftEvent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, myProfile,
      currentIndex, profilePic, name, userName, draftEvent);

  @override
  String toString() {
    return 'MyProfileState(isLoading: $isLoading, myProfile: $myProfile, currentIndex: $currentIndex, profilePic: $profilePic, name: $name, userName: $userName, draftEvent: $draftEvent)';
  }
}

/// @nodoc
abstract mixin class $MyProfileStateCopyWith<$Res> {
  factory $MyProfileStateCopyWith(
          MyProfileState value, $Res Function(MyProfileState) _then) =
      _$MyProfileStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      MyProfile? myProfile,
      int currentIndex,
      String profilePic,
      String name,
      String userName,
      DraftEventModel? draftEvent});
}

/// @nodoc
class _$MyProfileStateCopyWithImpl<$Res>
    implements $MyProfileStateCopyWith<$Res> {
  _$MyProfileStateCopyWithImpl(this._self, this._then);

  final MyProfileState _self;
  final $Res Function(MyProfileState) _then;

  /// Create a copy of MyProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? myProfile = freezed,
    Object? currentIndex = null,
    Object? profilePic = null,
    Object? name = null,
    Object? userName = null,
    Object? draftEvent = freezed,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      myProfile: freezed == myProfile
          ? _self.myProfile
          : myProfile // ignore: cast_nullable_to_non_nullable
              as MyProfile?,
      currentIndex: null == currentIndex
          ? _self.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      profilePic: null == profilePic
          ? _self.profilePic
          : profilePic // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _self.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      draftEvent: freezed == draftEvent
          ? _self.draftEvent
          : draftEvent // ignore: cast_nullable_to_non_nullable
              as DraftEventModel?,
    ));
  }
}

/// @nodoc

class _Initial extends MyProfileState {
  const _Initial(
      {this.isLoading = false,
      this.myProfile,
      this.currentIndex = 0,
      this.profilePic = '',
      this.name = 'User',
      this.userName = 'username',
      this.draftEvent})
      : super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final MyProfile? myProfile;
  @override
  @JsonKey()
  final int currentIndex;
  @override
  @JsonKey()
  final String profilePic;
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String userName;
  @override
  final DraftEventModel? draftEvent;

  /// Create a copy of MyProfileState
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
            (identical(other.myProfile, myProfile) ||
                other.myProfile == myProfile) &&
            (identical(other.currentIndex, currentIndex) ||
                other.currentIndex == currentIndex) &&
            (identical(other.profilePic, profilePic) ||
                other.profilePic == profilePic) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.draftEvent, draftEvent) ||
                other.draftEvent == draftEvent));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, myProfile,
      currentIndex, profilePic, name, userName, draftEvent);

  @override
  String toString() {
    return 'MyProfileState(isLoading: $isLoading, myProfile: $myProfile, currentIndex: $currentIndex, profilePic: $profilePic, name: $name, userName: $userName, draftEvent: $draftEvent)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $MyProfileStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      MyProfile? myProfile,
      int currentIndex,
      String profilePic,
      String name,
      String userName,
      DraftEventModel? draftEvent});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of MyProfileState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? myProfile = freezed,
    Object? currentIndex = null,
    Object? profilePic = null,
    Object? name = null,
    Object? userName = null,
    Object? draftEvent = freezed,
  }) {
    return _then(_Initial(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      myProfile: freezed == myProfile
          ? _self.myProfile
          : myProfile // ignore: cast_nullable_to_non_nullable
              as MyProfile?,
      currentIndex: null == currentIndex
          ? _self.currentIndex
          : currentIndex // ignore: cast_nullable_to_non_nullable
              as int,
      profilePic: null == profilePic
          ? _self.profilePic
          : profilePic // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _self.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      draftEvent: freezed == draftEvent
          ? _self.draftEvent
          : draftEvent // ignore: cast_nullable_to_non_nullable
              as DraftEventModel?,
    ));
  }
}

// dart format on
