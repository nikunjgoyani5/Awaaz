// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_screen_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthScreenState {
  String get email;
  TextEditingController? get emailController;
  TextEditingController? get forgotPasswordEmailController;
  TextEditingController? get passwordController;
  String get password;
  bool get isLoading;
  bool get isPassShow;
  bool get isPolicyCheck;
  bool get isRemember;
  bool get isLogInWithEmail;
  bool get isRegister; // @Default(false) bool isLogInWithPhone,
// TextEditingController? phoneNumberController,
  String get countryCode;

  /// Create a copy of AuthScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthScreenStateCopyWith<AuthScreenState> get copyWith =>
      _$AuthScreenStateCopyWithImpl<AuthScreenState>(
          this as AuthScreenState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthScreenState &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emailController, emailController) ||
                other.emailController == emailController) &&
            (identical(other.forgotPasswordEmailController,
                    forgotPasswordEmailController) ||
                other.forgotPasswordEmailController ==
                    forgotPasswordEmailController) &&
            (identical(other.passwordController, passwordController) ||
                other.passwordController == passwordController) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isPassShow, isPassShow) ||
                other.isPassShow == isPassShow) &&
            (identical(other.isPolicyCheck, isPolicyCheck) ||
                other.isPolicyCheck == isPolicyCheck) &&
            (identical(other.isRemember, isRemember) ||
                other.isRemember == isRemember) &&
            (identical(other.isLogInWithEmail, isLogInWithEmail) ||
                other.isLogInWithEmail == isLogInWithEmail) &&
            (identical(other.isRegister, isRegister) ||
                other.isRegister == isRegister) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      email,
      emailController,
      forgotPasswordEmailController,
      passwordController,
      password,
      isLoading,
      isPassShow,
      isPolicyCheck,
      isRemember,
      isLogInWithEmail,
      isRegister,
      countryCode);

  @override
  String toString() {
    return 'AuthScreenState(email: $email, emailController: $emailController, forgotPasswordEmailController: $forgotPasswordEmailController, passwordController: $passwordController, password: $password, isLoading: $isLoading, isPassShow: $isPassShow, isPolicyCheck: $isPolicyCheck, isRemember: $isRemember, isLogInWithEmail: $isLogInWithEmail, isRegister: $isRegister, countryCode: $countryCode)';
  }
}

/// @nodoc
abstract mixin class $AuthScreenStateCopyWith<$Res> {
  factory $AuthScreenStateCopyWith(
          AuthScreenState value, $Res Function(AuthScreenState) _then) =
      _$AuthScreenStateCopyWithImpl;
  @useResult
  $Res call(
      {String email,
      TextEditingController? emailController,
      TextEditingController? forgotPasswordEmailController,
      TextEditingController? passwordController,
      String password,
      bool isLoading,
      bool isPassShow,
      bool isPolicyCheck,
      bool isRemember,
      bool isLogInWithEmail,
      bool isRegister,
      String countryCode});
}

/// @nodoc
class _$AuthScreenStateCopyWithImpl<$Res>
    implements $AuthScreenStateCopyWith<$Res> {
  _$AuthScreenStateCopyWithImpl(this._self, this._then);

  final AuthScreenState _self;
  final $Res Function(AuthScreenState) _then;

  /// Create a copy of AuthScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? emailController = freezed,
    Object? forgotPasswordEmailController = freezed,
    Object? passwordController = freezed,
    Object? password = null,
    Object? isLoading = null,
    Object? isPassShow = null,
    Object? isPolicyCheck = null,
    Object? isRemember = null,
    Object? isLogInWithEmail = null,
    Object? isRegister = null,
    Object? countryCode = null,
  }) {
    return _then(_self.copyWith(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailController: freezed == emailController
          ? _self.emailController
          : emailController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      forgotPasswordEmailController: freezed == forgotPasswordEmailController
          ? _self.forgotPasswordEmailController
          : forgotPasswordEmailController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      passwordController: freezed == passwordController
          ? _self.passwordController
          : passwordController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPassShow: null == isPassShow
          ? _self.isPassShow
          : isPassShow // ignore: cast_nullable_to_non_nullable
              as bool,
      isPolicyCheck: null == isPolicyCheck
          ? _self.isPolicyCheck
          : isPolicyCheck // ignore: cast_nullable_to_non_nullable
              as bool,
      isRemember: null == isRemember
          ? _self.isRemember
          : isRemember // ignore: cast_nullable_to_non_nullable
              as bool,
      isLogInWithEmail: null == isLogInWithEmail
          ? _self.isLogInWithEmail
          : isLogInWithEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      isRegister: null == isRegister
          ? _self.isRegister
          : isRegister // ignore: cast_nullable_to_non_nullable
              as bool,
      countryCode: null == countryCode
          ? _self.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _Initial extends AuthScreenState {
  const _Initial(
      {this.email = '',
      this.emailController,
      this.forgotPasswordEmailController,
      this.passwordController,
      this.password = '',
      this.isLoading = false,
      this.isPassShow = false,
      this.isPolicyCheck = true,
      this.isRemember = false,
      this.isLogInWithEmail = true,
      this.isRegister = false,
      this.countryCode = '+91'})
      : super._();

  @override
  @JsonKey()
  final String email;
  @override
  final TextEditingController? emailController;
  @override
  final TextEditingController? forgotPasswordEmailController;
  @override
  final TextEditingController? passwordController;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isPassShow;
  @override
  @JsonKey()
  final bool isPolicyCheck;
  @override
  @JsonKey()
  final bool isRemember;
  @override
  @JsonKey()
  final bool isLogInWithEmail;
  @override
  @JsonKey()
  final bool isRegister;
// @Default(false) bool isLogInWithPhone,
// TextEditingController? phoneNumberController,
  @override
  @JsonKey()
  final String countryCode;

  /// Create a copy of AuthScreenState
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
            (identical(other.email, email) || other.email == email) &&
            (identical(other.emailController, emailController) ||
                other.emailController == emailController) &&
            (identical(other.forgotPasswordEmailController,
                    forgotPasswordEmailController) ||
                other.forgotPasswordEmailController ==
                    forgotPasswordEmailController) &&
            (identical(other.passwordController, passwordController) ||
                other.passwordController == passwordController) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isPassShow, isPassShow) ||
                other.isPassShow == isPassShow) &&
            (identical(other.isPolicyCheck, isPolicyCheck) ||
                other.isPolicyCheck == isPolicyCheck) &&
            (identical(other.isRemember, isRemember) ||
                other.isRemember == isRemember) &&
            (identical(other.isLogInWithEmail, isLogInWithEmail) ||
                other.isLogInWithEmail == isLogInWithEmail) &&
            (identical(other.isRegister, isRegister) ||
                other.isRegister == isRegister) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      email,
      emailController,
      forgotPasswordEmailController,
      passwordController,
      password,
      isLoading,
      isPassShow,
      isPolicyCheck,
      isRemember,
      isLogInWithEmail,
      isRegister,
      countryCode);

  @override
  String toString() {
    return 'AuthScreenState(email: $email, emailController: $emailController, forgotPasswordEmailController: $forgotPasswordEmailController, passwordController: $passwordController, password: $password, isLoading: $isLoading, isPassShow: $isPassShow, isPolicyCheck: $isPolicyCheck, isRemember: $isRemember, isLogInWithEmail: $isLogInWithEmail, isRegister: $isRegister, countryCode: $countryCode)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $AuthScreenStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String email,
      TextEditingController? emailController,
      TextEditingController? forgotPasswordEmailController,
      TextEditingController? passwordController,
      String password,
      bool isLoading,
      bool isPassShow,
      bool isPolicyCheck,
      bool isRemember,
      bool isLogInWithEmail,
      bool isRegister,
      String countryCode});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of AuthScreenState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? email = null,
    Object? emailController = freezed,
    Object? forgotPasswordEmailController = freezed,
    Object? passwordController = freezed,
    Object? password = null,
    Object? isLoading = null,
    Object? isPassShow = null,
    Object? isPolicyCheck = null,
    Object? isRemember = null,
    Object? isLogInWithEmail = null,
    Object? isRegister = null,
    Object? countryCode = null,
  }) {
    return _then(_Initial(
      email: null == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      emailController: freezed == emailController
          ? _self.emailController
          : emailController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      forgotPasswordEmailController: freezed == forgotPasswordEmailController
          ? _self.forgotPasswordEmailController
          : forgotPasswordEmailController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      passwordController: freezed == passwordController
          ? _self.passwordController
          : passwordController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isPassShow: null == isPassShow
          ? _self.isPassShow
          : isPassShow // ignore: cast_nullable_to_non_nullable
              as bool,
      isPolicyCheck: null == isPolicyCheck
          ? _self.isPolicyCheck
          : isPolicyCheck // ignore: cast_nullable_to_non_nullable
              as bool,
      isRemember: null == isRemember
          ? _self.isRemember
          : isRemember // ignore: cast_nullable_to_non_nullable
              as bool,
      isLogInWithEmail: null == isLogInWithEmail
          ? _self.isLogInWithEmail
          : isLogInWithEmail // ignore: cast_nullable_to_non_nullable
              as bool,
      isRegister: null == isRegister
          ? _self.isRegister
          : isRegister // ignore: cast_nullable_to_non_nullable
              as bool,
      countryCode: null == countryCode
          ? _self.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
