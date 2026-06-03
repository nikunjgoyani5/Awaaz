part of 'change_password_screen_cubit.dart';

@freezed
class ChangePasswordState with _$ChangePasswordState {
  const ChangePasswordState._();
  const factory ChangePasswordState({
    TextEditingController? oldPasswordController,
    TextEditingController? newPasswordController,
    TextEditingController? confirmPasswordController,
    @Default(false) bool isLoading,
    @Default(true) bool isShowOldPassword,
    @Default(true) bool isShowPassword,
    @Default(true) bool isShowConfirmPassword,
    GlobalKey<FormState>? resetPasswordKey,
  }) = _Initial;

  @override
  // TODO: implement confirmPasswordController
  TextEditingController? get confirmPasswordController => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement isShowConfirmPassword
  bool get isShowConfirmPassword => throw UnimplementedError();

  @override
  // TODO: implement isShowOldPassword
  bool get isShowOldPassword => throw UnimplementedError();

  @override
  // TODO: implement isShowPassword
  bool get isShowPassword => throw UnimplementedError();

  @override
  // TODO: implement newPasswordController
  TextEditingController? get newPasswordController => throw UnimplementedError();

  @override
  // TODO: implement oldPasswordController
  TextEditingController? get oldPasswordController => throw UnimplementedError();

  @override
  // TODO: implement resetPasswordKey
  GlobalKey<FormState>? get resetPasswordKey => throw UnimplementedError();


}
