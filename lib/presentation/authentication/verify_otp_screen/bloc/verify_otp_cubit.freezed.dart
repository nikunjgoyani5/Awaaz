// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_otp_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerifyOtpState {
  int get resendRemainingSeconds;
  TextEditingController? get otpController;
  bool get enableResend;
  bool get isLoading;

  /// Create a copy of VerifyOtpState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VerifyOtpStateCopyWith<VerifyOtpState> get copyWith =>
      _$VerifyOtpStateCopyWithImpl<VerifyOtpState>(
          this as VerifyOtpState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VerifyOtpState &&
            (identical(other.resendRemainingSeconds, resendRemainingSeconds) ||
                other.resendRemainingSeconds == resendRemainingSeconds) &&
            (identical(other.otpController, otpController) ||
                other.otpController == otpController) &&
            (identical(other.enableResend, enableResend) ||
                other.enableResend == enableResend) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, resendRemainingSeconds,
      otpController, enableResend, isLoading);

  @override
  String toString() {
    return 'VerifyOtpState(resendRemainingSeconds: $resendRemainingSeconds, otpController: $otpController, enableResend: $enableResend, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class $VerifyOtpStateCopyWith<$Res> {
  factory $VerifyOtpStateCopyWith(
          VerifyOtpState value, $Res Function(VerifyOtpState) _then) =
      _$VerifyOtpStateCopyWithImpl;
  @useResult
  $Res call(
      {int resendRemainingSeconds,
      TextEditingController? otpController,
      bool enableResend,
      bool isLoading});
}

/// @nodoc
class _$VerifyOtpStateCopyWithImpl<$Res>
    implements $VerifyOtpStateCopyWith<$Res> {
  _$VerifyOtpStateCopyWithImpl(this._self, this._then);

  final VerifyOtpState _self;
  final $Res Function(VerifyOtpState) _then;

  /// Create a copy of VerifyOtpState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? resendRemainingSeconds = null,
    Object? otpController = freezed,
    Object? enableResend = null,
    Object? isLoading = null,
  }) {
    return _then(_self.copyWith(
      resendRemainingSeconds: null == resendRemainingSeconds
          ? _self.resendRemainingSeconds
          : resendRemainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      otpController: freezed == otpController
          ? _self.otpController
          : otpController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      enableResend: null == enableResend
          ? _self.enableResend
          : enableResend // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _Initial extends VerifyOtpState {
  const _Initial(
      {this.resendRemainingSeconds = 0,
      this.otpController,
      this.enableResend = false,
      this.isLoading = false})
      : super._();

  @override
  @JsonKey()
  final int resendRemainingSeconds;
  @override
  final TextEditingController? otpController;
  @override
  @JsonKey()
  final bool enableResend;
  @override
  @JsonKey()
  final bool isLoading;

  /// Create a copy of VerifyOtpState
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
            (identical(other.resendRemainingSeconds, resendRemainingSeconds) ||
                other.resendRemainingSeconds == resendRemainingSeconds) &&
            (identical(other.otpController, otpController) ||
                other.otpController == otpController) &&
            (identical(other.enableResend, enableResend) ||
                other.enableResend == enableResend) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, resendRemainingSeconds,
      otpController, enableResend, isLoading);

  @override
  String toString() {
    return 'VerifyOtpState.initial(resendRemainingSeconds: $resendRemainingSeconds, otpController: $otpController, enableResend: $enableResend, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $VerifyOtpStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int resendRemainingSeconds,
      TextEditingController? otpController,
      bool enableResend,
      bool isLoading});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of VerifyOtpState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? resendRemainingSeconds = null,
    Object? otpController = freezed,
    Object? enableResend = null,
    Object? isLoading = null,
  }) {
    return _then(_Initial(
      resendRemainingSeconds: null == resendRemainingSeconds
          ? _self.resendRemainingSeconds
          : resendRemainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      otpController: freezed == otpController
          ? _self.otpController
          : otpController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      enableResend: null == enableResend
          ? _self.enableResend
          : enableResend // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
