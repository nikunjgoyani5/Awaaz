import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_state.freezed.dart';

@freezed
class SplashState with _$SplashState {
  const SplashState._();

  const factory SplashState({
    @Default(false) bool isLoading,
  }) = _Initial;

  // TODO: implement isLoading
  @override
  bool get isLoading => throw UnimplementedError();
}
