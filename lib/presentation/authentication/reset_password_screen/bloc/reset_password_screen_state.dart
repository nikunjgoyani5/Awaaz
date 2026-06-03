part of 'reset_password_screen_cubit.dart';

@freezed
class ResetPasswordState with _$ResetPasswordState {
  const ResetPasswordState._();
  const factory ResetPasswordState({
    TextEditingController? newPasswordController,
    TextEditingController? confirmPasswordController,
    @Default(false) bool isLoading,
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
  // TODO: implement isShowPassword
  bool get isShowPassword => throw UnimplementedError();

  @override
  // TODO: implement newPasswordController
  TextEditingController? get newPasswordController => throw UnimplementedError();

  @override
  // TODO: implement resetPasswordKey
  GlobalKey<FormState>? get resetPasswordKey => throw UnimplementedError();

}
