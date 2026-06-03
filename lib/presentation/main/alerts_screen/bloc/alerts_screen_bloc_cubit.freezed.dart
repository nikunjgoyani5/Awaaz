// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'alerts_screen_bloc_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlertsScreenBlocState {
  bool get isLoading;
  bool get isBottomLoading;
  List<NotificationData>? get notificationList;
  int get currentPage;
  int get totalPages;

  /// Create a copy of AlertsScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AlertsScreenBlocStateCopyWith<AlertsScreenBlocState> get copyWith =>
      _$AlertsScreenBlocStateCopyWithImpl<AlertsScreenBlocState>(
          this as AlertsScreenBlocState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AlertsScreenBlocState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isBottomLoading, isBottomLoading) ||
                other.isBottomLoading == isBottomLoading) &&
            const DeepCollectionEquality()
                .equals(other.notificationList, notificationList) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isBottomLoading,
      const DeepCollectionEquality().hash(notificationList),
      currentPage,
      totalPages);

  @override
  String toString() {
    return 'AlertsScreenBlocState(isLoading: $isLoading, isBottomLoading: $isBottomLoading, notificationList: $notificationList, currentPage: $currentPage, totalPages: $totalPages)';
  }
}

/// @nodoc
abstract mixin class $AlertsScreenBlocStateCopyWith<$Res> {
  factory $AlertsScreenBlocStateCopyWith(AlertsScreenBlocState value,
          $Res Function(AlertsScreenBlocState) _then) =
      _$AlertsScreenBlocStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      bool isBottomLoading,
      List<NotificationData>? notificationList,
      int currentPage,
      int totalPages});
}

/// @nodoc
class _$AlertsScreenBlocStateCopyWithImpl<$Res>
    implements $AlertsScreenBlocStateCopyWith<$Res> {
  _$AlertsScreenBlocStateCopyWithImpl(this._self, this._then);

  final AlertsScreenBlocState _self;
  final $Res Function(AlertsScreenBlocState) _then;

  /// Create a copy of AlertsScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isBottomLoading = null,
    Object? notificationList = freezed,
    Object? currentPage = null,
    Object? totalPages = null,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isBottomLoading: null == isBottomLoading
          ? _self.isBottomLoading
          : isBottomLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationList: freezed == notificationList
          ? _self.notificationList
          : notificationList // ignore: cast_nullable_to_non_nullable
              as List<NotificationData>?,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _Initial extends AlertsScreenBlocState {
  const _Initial(
      {this.isLoading = false,
      this.isBottomLoading = false,
      final List<NotificationData>? notificationList,
      this.currentPage = 0,
      this.totalPages = 0})
      : _notificationList = notificationList,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isBottomLoading;
  final List<NotificationData>? _notificationList;
  @override
  List<NotificationData>? get notificationList {
    final value = _notificationList;
    if (value == null) return null;
    if (_notificationList is EqualUnmodifiableListView)
      return _notificationList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final int totalPages;

  /// Create a copy of AlertsScreenBlocState
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
            (identical(other.isBottomLoading, isBottomLoading) ||
                other.isBottomLoading == isBottomLoading) &&
            const DeepCollectionEquality()
                .equals(other._notificationList, _notificationList) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      isBottomLoading,
      const DeepCollectionEquality().hash(_notificationList),
      currentPage,
      totalPages);

  @override
  String toString() {
    return 'AlertsScreenBlocState(isLoading: $isLoading, isBottomLoading: $isBottomLoading, notificationList: $notificationList, currentPage: $currentPage, totalPages: $totalPages)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $AlertsScreenBlocStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool isBottomLoading,
      List<NotificationData>? notificationList,
      int currentPage,
      int totalPages});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of AlertsScreenBlocState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? isBottomLoading = null,
    Object? notificationList = freezed,
    Object? currentPage = null,
    Object? totalPages = null,
  }) {
    return _then(_Initial(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isBottomLoading: null == isBottomLoading
          ? _self.isBottomLoading
          : isBottomLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationList: freezed == notificationList
          ? _self._notificationList
          : notificationList // ignore: cast_nullable_to_non_nullable
              as List<NotificationData>?,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _self.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
