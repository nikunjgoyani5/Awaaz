part of 'edit_profile_cubit.dart';

@freezed
class EditProfileState with _$EditProfileState {
  const EditProfileState._();
  const factory EditProfileState({
    File? profilePicture,
    TextEditingController? nameController,
    TextEditingController? userNameController,
    TextEditingController? dobNameController,
    String? profilePictureUrl,
    DateTime? dob,
    @Default(false) bool isLoading,
  }) = _Initial;

  @override
  // TODO: implement dob
  DateTime? get dob => throw UnimplementedError();

  @override
  // TODO: implement dobNameController
  TextEditingController? get dobNameController => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement nameController
  TextEditingController? get nameController => throw UnimplementedError();

  @override
  // TODO: implement profilePicture
  File? get profilePicture => throw UnimplementedError();

  @override
  // TODO: implement profilePictureUrl
  String? get profilePictureUrl => throw UnimplementedError();

  @override
  // TODO: implement userNameController
  TextEditingController? get userNameController => throw UnimplementedError();

}