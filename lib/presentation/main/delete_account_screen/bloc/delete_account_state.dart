part of 'delete_account_cubit.dart';

@freezed
class DeleteAccountState with _$DeleteAccountState {
  const DeleteAccountState._();
  const factory DeleteAccountState.initial({
    @Default([
      {
        'reason': 'I’m not using the app.',
        'isSelected': false,
      },
      {
        'reason': 'I found a better alternative.',
        'isSelected': false,
      },
      {
        'reason': 'The App Contains Feature that is Non of My Use.',
        'isSelected': false,
      },
      {
        'reason':
        'The app didn’t have the features of functionality I were looking for.',
        'isSelected': false,
      },
      {
        'reason': 'l’m not satisfied with the quality of content.',
        'isSelected': false,
      },
      {
        'reason': 'The app was difficult to navigate.',
        'isSelected': false,
      },
      {
        'reason': 'Other.',
        'isSelected': false,
      },
    ]) List<Map<String, dynamic>> reasonList,
    @Default(false) bool isLoading,
  }) = _Initial;

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement reasonList
  List<Map<String, dynamic>> get reasonList => throw UnimplementedError();

}