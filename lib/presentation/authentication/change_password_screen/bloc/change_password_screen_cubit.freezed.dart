// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'change_password_screen_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChangePasswordState {
  TextEditingController? get oldPasswordController;
  TextEditingController? get newPasswordController;
  TextEditingController? get confirmPasswordController;
  bool get isLoading;
  bool get isShowOldPassword;
  bool get isShowPassword;
  bool get isShowConfirmPassword;
  GlobalKey<FormState>? get resetPasswordKey;

  /// Create a copy of ChangePasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChangePasswordStateCopyWith<ChangePasswordState> get copyWith =>
      _$ChangePasswordStateCopyWithImpl<ChangePasswordState>(
          this as ChangePasswordState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChangePasswordState &&
            (identical(other.oldPasswordController, oldPasswordController) ||
                other.oldPasswordController == oldPasswordController) &&
            (identical(other.newPasswordController, newPasswordController) ||
                other.newPasswordController == newPasswordController) &&
            (identical(other.confirmPasswordController,
                    confirmPasswordController) ||
                other.confirmPasswordController == confirmPasswordController) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isShowOldPassword, isShowOldPassword) ||
                other.isShowOldPassword == isShowOldPassword) &&
            (identical(other.isShowPassword, isShowPassword) ||
                other.isShowPassword == isShowPassword) &&
            (identical(other.isShowConfirmPassword, isShowConfirmPassword) ||
                other.isShowConfirmPassword == isShowConfirmPassword) &&
            (identical(other.resetPasswordKey, resetPasswordKey) ||
                other.resetPasswordKey == resetPasswordKey));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      oldPasswordController,
      newPasswordController,
      confirmPasswordController,
      isLoading,
      isShowOldPassword,
      isShowPassword,
      isShowConfirmPassword,
      resetPasswordKey);

  @override
  String toString() {
    return 'ChangePasswordState(oldPasswordController: $oldPasswordController, newPasswordController: $newPasswordController, confirmPasswordController: $confirmPasswordController, isLoading: $isLoading, isShowOldPassword: $isShowOldPassword, isShowPassword: $isShowPassword, isShowConfirmPassword: $isShowConfirmPassword, resetPasswordKey: $resetPasswordKey)';
  }
}

/// @nodoc
abstract mixin class $ChangePasswordStateCopyWith<$Res> {
  factory $ChangePasswordStateCopyWith(
          ChangePasswordState value, $Res Function(ChangePasswordState) _then) =
      _$ChangePasswordStateCopyWithImpl;
  @useResult
  $Res call(
      {TextEditingController? oldPasswordController,
      TextEditingController? newPasswordController,
      TextEditingController? confirmPasswordController,
      bool isLoading,
      bool isShowOldPassword,
      bool isShowPassword,
      bool isShowConfirmPassword,
      GlobalKey<FormState>? resetPasswordKey});
}

/// @nodoc
class _$ChangePasswordStateCopyWithImpl<$Res>
    implements $ChangePasswordStateCopyWith<$Res> {
  _$ChangePasswordStateCopyWithImpl(this._self, this._then);

  final ChangePasswordState _self;
  final $Res Function(ChangePasswordState) _then;

  /// Create a copy of ChangePasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? oldPasswordController = freezed,
    Object? newPasswordController = freezed,
    Object? confirmPasswordController = freezed,
    Object? isLoading = null,
    Object? isShowOldPassword = null,
    Object? isShowPassword = null,
    Object? isShowConfirmPassword = null,
    Object? resetPasswordKey = freezed,
  }) {
    return _then(_self.copyWith(
      oldPasswordController: freezed == oldPasswordController
          ? _self.oldPasswordController
          : oldPasswordController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      newPasswordController: freezed == newPasswordController
          ? _self.newPasswordController
          : newPasswordController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      confirmPasswordController: freezed == confirmPasswordController
          ? _self.confirmPasswordController
          : confirmPasswordController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isShowOldPassword: null == isShowOldPassword
          ? _self.isShowOldPassword
          : isShowOldPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      isShowPassword: null == isShowPassword
          ? _self.isShowPassword
          : isShowPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      isShowConfirmPassword: null == isShowConfirmPassword
          ? _self.isShowConfirmPassword
          : isShowConfirmPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      resetPasswordKey: freezed == resetPasswordKey
          ? _self.resetPasswordKey
          : resetPasswordKey // ignore: cast_nullable_to_non_nullable
              as GlobalKey<FormState>?,
    ));
  }
}

/// @nodoc

class _Initial extends ChangePasswordState {
  const _Initial(
      {this.oldPasswordController,
      this.newPasswordController,
      this.confirmPasswordController,
      this.isLoading = false,
      this.isShowOldPassword = true,
      this.isShowPassword = true,
      this.isShowConfirmPassword = true,
      this.resetPasswordKey})
      : super._();

  @override
  final TextEditingController? oldPasswordController;
  @override
  final TextEditingController? newPasswordController;
  @override
  final TextEditingController? confirmPasswordController;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isShowOldPassword;
  @override
  @JsonKey()
  final bool isShowPassword;
  @override
  @JsonKey()
  final bool isShowConfirmPassword;
  @override
  final GlobalKey<FormState>? resetPasswordKey;

  /// Create a copy of ChangePasswordState
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
            (identical(other.oldPasswordController, oldPasswordController) ||
                other.oldPasswordController == oldPasswordController) &&
            (identical(other.newPasswordController, newPasswordController) ||
                other.newPasswordController == newPasswordController) &&
            (identical(other.confirmPasswordController,
                    confirmPasswordController) ||
                other.confirmPasswordController == confirmPasswordController) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isShowOldPassword, isShowOldPassword) ||
                other.isShowOldPassword == isShowOldPassword) &&
            (identical(other.isShowPassword, isShowPassword) ||
                other.isShowPassword == isShowPassword) &&
            (identical(other.isShowConfirmPassword, isShowConfirmPassword) ||
                other.isShowConfirmPassword == isShowConfirmPassword) &&
            (identical(other.resetPasswordKey, resetPasswordKey) ||
                other.resetPasswordKey == resetPasswordKey));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      oldPasswordController,
      newPasswordController,
      confirmPasswordController,
      isLoading,
      isShowOldPassword,
      isShowPassword,
      isShowConfirmPassword,
      resetPasswordKey);

  @override
  String toString() {
    return 'ChangePasswordState(oldPasswordController: $oldPasswordController, newPasswordController: $newPasswordController, confirmPasswordController: $confirmPasswordController, isLoading: $isLoading, isShowOldPassword: $isShowOldPassword, isShowPassword: $isShowPassword, isShowConfirmPassword: $isShowConfirmPassword, resetPasswordKey: $resetPasswordKey)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $ChangePasswordStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {TextEditingController? oldPasswordController,
      TextEditingController? newPasswordController,
      TextEditingController? confirmPasswordController,
      bool isLoading,
      bool isShowOldPassword,
      bool isShowPassword,
      bool isShowConfirmPassword,
      GlobalKey<FormState>? resetPasswordKey});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of ChangePasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? oldPasswordController = freezed,
    Object? newPasswordController = freezed,
    Object? confirmPasswordController = freezed,
    Object? isLoading = null,
    Object? isShowOldPassword = null,
    Object? isShowPassword = null,
    Object? isShowConfirmPassword = null,
    Object? resetPasswordKey = freezed,
  }) {
    return _then(_Initial(
      oldPasswordController: freezed == oldPasswordController
          ? _self.oldPasswordController
          : oldPasswordController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      newPasswordController: freezed == newPasswordController
          ? _self.newPasswordController
          : newPasswordController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      confirmPasswordController: freezed == confirmPasswordController
          ? _self.confirmPasswordController
          : confirmPasswordController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isShowOldPassword: null == isShowOldPassword
          ? _self.isShowOldPassword
          : isShowOldPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      isShowPassword: null == isShowPassword
          ? _self.isShowPassword
          : isShowPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      isShowConfirmPassword: null == isShowConfirmPassword
          ? _self.isShowConfirmPassword
          : isShowConfirmPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      resetPasswordKey: freezed == resetPasswordKey
          ? _self.resetPasswordKey
          : resetPasswordKey // ignore: cast_nullable_to_non_nullable
              as GlobalKey<FormState>?,
    ));
  }
}

// dart format on
