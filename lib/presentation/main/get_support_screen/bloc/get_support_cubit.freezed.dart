// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_support_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetSupportState {
  int get selectedSupportIndex;
  bool get isLoading;
  List<SupportData>? get supportDataList;
  TextEditingController? get emailController;
  TextEditingController? get subjectController;
  TextEditingController? get descriptionController;
  File? get file;

  /// Create a copy of GetSupportState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetSupportStateCopyWith<GetSupportState> get copyWith =>
      _$GetSupportStateCopyWithImpl<GetSupportState>(
          this as GetSupportState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetSupportState &&
            (identical(other.selectedSupportIndex, selectedSupportIndex) ||
                other.selectedSupportIndex == selectedSupportIndex) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other.supportDataList, supportDataList) &&
            (identical(other.emailController, emailController) ||
                other.emailController == emailController) &&
            (identical(other.subjectController, subjectController) ||
                other.subjectController == subjectController) &&
            (identical(other.descriptionController, descriptionController) ||
                other.descriptionController == descriptionController) &&
            (identical(other.file, file) || other.file == file));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedSupportIndex,
      isLoading,
      const DeepCollectionEquality().hash(supportDataList),
      emailController,
      subjectController,
      descriptionController,
      file);

  @override
  String toString() {
    return 'GetSupportState(selectedSupportIndex: $selectedSupportIndex, isLoading: $isLoading, supportDataList: $supportDataList, emailController: $emailController, subjectController: $subjectController, descriptionController: $descriptionController, file: $file)';
  }
}

/// @nodoc
abstract mixin class $GetSupportStateCopyWith<$Res> {
  factory $GetSupportStateCopyWith(
          GetSupportState value, $Res Function(GetSupportState) _then) =
      _$GetSupportStateCopyWithImpl;
  @useResult
  $Res call(
      {int selectedSupportIndex,
      bool isLoading,
      List<SupportData>? supportDataList,
      TextEditingController? emailController,
      TextEditingController? subjectController,
      TextEditingController? descriptionController,
      File? file});
}

/// @nodoc
class _$GetSupportStateCopyWithImpl<$Res>
    implements $GetSupportStateCopyWith<$Res> {
  _$GetSupportStateCopyWithImpl(this._self, this._then);

  final GetSupportState _self;
  final $Res Function(GetSupportState) _then;

  /// Create a copy of GetSupportState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedSupportIndex = null,
    Object? isLoading = null,
    Object? supportDataList = freezed,
    Object? emailController = freezed,
    Object? subjectController = freezed,
    Object? descriptionController = freezed,
    Object? file = freezed,
  }) {
    return _then(_self.copyWith(
      selectedSupportIndex: null == selectedSupportIndex
          ? _self.selectedSupportIndex
          : selectedSupportIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      supportDataList: freezed == supportDataList
          ? _self.supportDataList
          : supportDataList // ignore: cast_nullable_to_non_nullable
              as List<SupportData>?,
      emailController: freezed == emailController
          ? _self.emailController
          : emailController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      subjectController: freezed == subjectController
          ? _self.subjectController
          : subjectController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      descriptionController: freezed == descriptionController
          ? _self.descriptionController
          : descriptionController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      file: freezed == file
          ? _self.file
          : file // ignore: cast_nullable_to_non_nullable
              as File?,
    ));
  }
}

/// @nodoc

class _Initial extends GetSupportState {
  const _Initial(
      {this.selectedSupportIndex = 0,
      this.isLoading = false,
      final List<SupportData>? supportDataList,
      this.emailController,
      this.subjectController,
      this.descriptionController,
      this.file})
      : _supportDataList = supportDataList,
        super._();

  @override
  @JsonKey()
  final int selectedSupportIndex;
  @override
  @JsonKey()
  final bool isLoading;
  final List<SupportData>? _supportDataList;
  @override
  List<SupportData>? get supportDataList {
    final value = _supportDataList;
    if (value == null) return null;
    if (_supportDataList is EqualUnmodifiableListView) return _supportDataList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final TextEditingController? emailController;
  @override
  final TextEditingController? subjectController;
  @override
  final TextEditingController? descriptionController;
  @override
  final File? file;

  /// Create a copy of GetSupportState
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
            (identical(other.selectedSupportIndex, selectedSupportIndex) ||
                other.selectedSupportIndex == selectedSupportIndex) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._supportDataList, _supportDataList) &&
            (identical(other.emailController, emailController) ||
                other.emailController == emailController) &&
            (identical(other.subjectController, subjectController) ||
                other.subjectController == subjectController) &&
            (identical(other.descriptionController, descriptionController) ||
                other.descriptionController == descriptionController) &&
            (identical(other.file, file) || other.file == file));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      selectedSupportIndex,
      isLoading,
      const DeepCollectionEquality().hash(_supportDataList),
      emailController,
      subjectController,
      descriptionController,
      file);

  @override
  String toString() {
    return 'GetSupportState(selectedSupportIndex: $selectedSupportIndex, isLoading: $isLoading, supportDataList: $supportDataList, emailController: $emailController, subjectController: $subjectController, descriptionController: $descriptionController, file: $file)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $GetSupportStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int selectedSupportIndex,
      bool isLoading,
      List<SupportData>? supportDataList,
      TextEditingController? emailController,
      TextEditingController? subjectController,
      TextEditingController? descriptionController,
      File? file});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of GetSupportState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selectedSupportIndex = null,
    Object? isLoading = null,
    Object? supportDataList = freezed,
    Object? emailController = freezed,
    Object? subjectController = freezed,
    Object? descriptionController = freezed,
    Object? file = freezed,
  }) {
    return _then(_Initial(
      selectedSupportIndex: null == selectedSupportIndex
          ? _self.selectedSupportIndex
          : selectedSupportIndex // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      supportDataList: freezed == supportDataList
          ? _self._supportDataList
          : supportDataList // ignore: cast_nullable_to_non_nullable
              as List<SupportData>?,
      emailController: freezed == emailController
          ? _self.emailController
          : emailController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      subjectController: freezed == subjectController
          ? _self.subjectController
          : subjectController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      descriptionController: freezed == descriptionController
          ? _self.descriptionController
          : descriptionController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      file: freezed == file
          ? _self.file
          : file // ignore: cast_nullable_to_non_nullable
              as File?,
    ));
  }
}

// dart format on
