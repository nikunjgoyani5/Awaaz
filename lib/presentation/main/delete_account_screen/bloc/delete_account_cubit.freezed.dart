// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_account_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteAccountState {
  List<Map<String, dynamic>> get reasonList;
  bool get isLoading;

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteAccountStateCopyWith<DeleteAccountState> get copyWith =>
      _$DeleteAccountStateCopyWithImpl<DeleteAccountState>(
          this as DeleteAccountState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteAccountState &&
            const DeepCollectionEquality()
                .equals(other.reasonList, reasonList) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(reasonList), isLoading);

  @override
  String toString() {
    return 'DeleteAccountState(reasonList: $reasonList, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class $DeleteAccountStateCopyWith<$Res> {
  factory $DeleteAccountStateCopyWith(
          DeleteAccountState value, $Res Function(DeleteAccountState) _then) =
      _$DeleteAccountStateCopyWithImpl;
  @useResult
  $Res call({List<Map<String, dynamic>> reasonList, bool isLoading});
}

/// @nodoc
class _$DeleteAccountStateCopyWithImpl<$Res>
    implements $DeleteAccountStateCopyWith<$Res> {
  _$DeleteAccountStateCopyWithImpl(this._self, this._then);

  final DeleteAccountState _self;
  final $Res Function(DeleteAccountState) _then;

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reasonList = null,
    Object? isLoading = null,
  }) {
    return _then(_self.copyWith(
      reasonList: null == reasonList
          ? _self.reasonList
          : reasonList // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _Initial extends DeleteAccountState {
  const _Initial(
      {final List<Map<String, dynamic>> reasonList = const [
        {'reason': 'I’m not using the app.', 'isSelected': false},
        {'reason': 'I found a better alternative.', 'isSelected': false},
        {
          'reason': 'The App Contains Feature that is Non of My Use.',
          'isSelected': false
        },
        {
          'reason':
              'The app didn’t have the features of functionality I were looking for.',
          'isSelected': false
        },
        {
          'reason': 'l’m not satisfied with the quality of content.',
          'isSelected': false
        },
        {'reason': 'The app was difficult to navigate.', 'isSelected': false},
        {'reason': 'Other.', 'isSelected': false}
      ],
      this.isLoading = false})
      : _reasonList = reasonList,
        super._();

  final List<Map<String, dynamic>> _reasonList;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get reasonList {
    if (_reasonList is EqualUnmodifiableListView) return _reasonList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reasonList);
  }

  @override
  @JsonKey()
  final bool isLoading;

  /// Create a copy of DeleteAccountState
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
            const DeepCollectionEquality()
                .equals(other._reasonList, _reasonList) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_reasonList), isLoading);

  @override
  String toString() {
    return 'DeleteAccountState.initial(reasonList: $reasonList, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $DeleteAccountStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call({List<Map<String, dynamic>> reasonList, bool isLoading});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of DeleteAccountState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? reasonList = null,
    Object? isLoading = null,
  }) {
    return _then(_Initial(
      reasonList: null == reasonList
          ? _self._reasonList
          : reasonList // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
