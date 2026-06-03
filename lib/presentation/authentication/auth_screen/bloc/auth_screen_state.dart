part of 'auth_screen_cubit.dart';

@freezed
class AuthScreenState with _$AuthScreenState {
  const AuthScreenState._();

  const factory AuthScreenState({
    @Default('') String email,
    TextEditingController? emailController,
    TextEditingController? forgotPasswordEmailController,
    TextEditingController? passwordController,
    @Default('') String password,
    @Default(false) bool isLoading,
    @Default(false) bool isPassShow,
    @Default(true) bool isPolicyCheck,
    @Default(false) bool isRemember,
    @Default(true) bool isLogInWithEmail,
    @Default(false) bool isRegister,
    // @Default(false) bool isLogInWithPhone,
    // TextEditingController? phoneNumberController,
    @Default('+91') String countryCode,
  }) = _Initial;

  @override
  // TODO: implement countryCode
  String get countryCode => throw UnimplementedError();

  @override
  // TODO: implement email
  String get email => throw UnimplementedError();

  @override
  // TODO: implement emailController
  TextEditingController? get emailController => throw UnimplementedError();

  @override
  // TODO: implement forgotPasswordEmailController
  TextEditingController? get forgotPasswordEmailController =>
      throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement isLogInWithEmail
  bool get isLogInWithEmail => throw UnimplementedError();

  @override
  // TODO: implement isPassShow
  bool get isPassShow => throw UnimplementedError();

  @override
  // TODO: implement isPolicyCheck
  bool get isPolicyCheck => throw UnimplementedError();

  @override
  // TODO: implement isRegister
  bool get isRegister => throw UnimplementedError();

  @override
  // TODO: implement isRemember
  bool get isRemember => throw UnimplementedError();

  @override
  // TODO: implement password
  String get password => throw UnimplementedError();

  @override
  // TODO: implement passwordController
  TextEditingController? get passwordController => throw UnimplementedError();
}
