// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_screen_bloc_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeScreenBlocState {
  int get currentPageIndex;
  bool get isBottomHide;

  /// Create a copy of HomeScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeScreenBlocStateCopyWith<HomeScreenBlocState> get copyWith =>
      _$HomeScreenBlocStateCopyWithImpl<HomeScreenBlocState>(
          this as HomeScreenBlocState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeScreenBlocState &&
            (identical(other.currentPageIndex, currentPageIndex) ||
                other.currentPageIndex == currentPageIndex) &&
            (identical(other.isBottomHide, isBottomHide) ||
                other.isBottomHide == isBottomHide));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentPageIndex, isBottomHide);

  @override
  String toString() {
    return 'HomeScreenBlocState(currentPageIndex: $currentPageIndex, isBottomHide: $isBottomHide)';
  }
}

/// @nodoc
abstract mixin class $HomeScreenBlocStateCopyWith<$Res> {
  factory $HomeScreenBlocStateCopyWith(
          HomeScreenBlocState value, $Res Function(HomeScreenBlocState) _then) =
      _$HomeScreenBlocStateCopyWithImpl;
  @useResult
  $Res call({int currentPageIndex, bool isBottomHide});
}

/// @nodoc
class _$HomeScreenBlocStateCopyWithImpl<$Res>
    implements $HomeScreenBlocStateCopyWith<$Res> {
  _$HomeScreenBlocStateCopyWithImpl(this._self, this._then);

  final HomeScreenBlocState _self;
  final $Res Function(HomeScreenBlocState) _then;

  /// Create a copy of HomeScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentPageIndex = null,
    Object? isBottomHide = null,
  }) {
    return _then(_self.copyWith(
      currentPageIndex: null == currentPageIndex
          ? _self.currentPageIndex
          : currentPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isBottomHide: null == isBottomHide
          ? _self.isBottomHide
          : isBottomHide // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _Initial extends HomeScreenBlocState {
  const _Initial({this.currentPageIndex = 0, this.isBottomHide = false})
      : super._();

  @override
  @JsonKey()
  final int currentPageIndex;
  @override
  @JsonKey()
  final bool isBottomHide;

  /// Create a copy of HomeScreenBlocState
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
            (identical(other.currentPageIndex, currentPageIndex) ||
                other.currentPageIndex == currentPageIndex) &&
            (identical(other.isBottomHide, isBottomHide) ||
                other.isBottomHide == isBottomHide));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentPageIndex, isBottomHide);

  @override
  String toString() {
    return 'HomeScreenBlocState(currentPageIndex: $currentPageIndex, isBottomHide: $isBottomHide)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $HomeScreenBlocStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call({int currentPageIndex, bool isBottomHide});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of HomeScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? currentPageIndex = null,
    Object? isBottomHide = null,
  }) {
    return _then(_Initial(
      currentPageIndex: null == currentPageIndex
          ? _self.currentPageIndex
          : currentPageIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isBottomHide: null == isBottomHide
          ? _self.isBottomHide
          : isBottomHide // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
