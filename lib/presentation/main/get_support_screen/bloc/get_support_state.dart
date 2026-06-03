part of 'get_support_cubit.dart';

@freezed
class GetSupportState with _$GetSupportState {
  const GetSupportState._();
  const factory GetSupportState({
    @Default(0) int selectedSupportIndex,
    @Default(false) bool isLoading,
    List<SupportData>? supportDataList,
    TextEditingController? emailController,
    TextEditingController? subjectController,
    TextEditingController? descriptionController,
    File? file,
  }) = _Initial;

  @override
  // TODO: implement descriptionController
  TextEditingController? get descriptionController => throw UnimplementedError();

  @override
  // TODO: implement emailController
  TextEditingController? get emailController => throw UnimplementedError();

  @override
  // TODO: implement file
  File? get file => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement selectedSupportIndex
  int get selectedSupportIndex => throw UnimplementedError();

  @override
  // TODO: implement subjectController
  TextEditingController? get subjectController => throw UnimplementedError();

  @override
  // TODO: implement supportDataList
  List<SupportData>? get supportDataList => throw UnimplementedError();
}