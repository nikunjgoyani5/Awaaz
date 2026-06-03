part of 'verify_otp_cubit.dart';

@freezed
class VerifyOtpState with _$VerifyOtpState {
  const VerifyOtpState._();

  const factory VerifyOtpState.initial({
    @Default(0) int resendRemainingSeconds,
    TextEditingController? otpController,
    @Default(false) bool enableResend,
    @Default(false) bool isLoading,
}) = _Initial;

  @override
  // TODO: implement enableResend
  bool get enableResend => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement otpController
  TextEditingController? get otpController => throw UnimplementedError();

  @override
  // TODO: implement resendRemainingSeconds
  int get resendRemainingSeconds => throw UnimplementedError();
}
