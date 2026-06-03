part of 'send_alert_cubit.dart';

@freezed
class SendAlertState with _$SendAlertState {
  const SendAlertState._();
  const factory SendAlertState({
    File? profilePicture,
    File? videoFile,
    Uint8List? videoThumbnailImage,
    File? videoThumbnailImageFile,
    TextEditingController? fullNameController,
    TextEditingController? locationController,
    TextEditingController? descriptionController,
    TextEditingController? phoneNumberController,
    TextEditingController? dateTimeController,
    DateTime? postTime,
    @Default(0.0) num userLatitude,
    @Default(0.0) num userLongitude,
    @Default(false) bool isLoading,
    @Default('+91') String countryCode,
  }) = _Initial;

  @override
  // TODO: implement countryCode
  String get countryCode => throw UnimplementedError();

  @override
  // TODO: implement dateTimeController
  TextEditingController? get dateTimeController => throw UnimplementedError();

  @override
  // TODO: implement descriptionController
  TextEditingController? get descriptionController => throw UnimplementedError();

  @override
  // TODO: implement fullNameController
  TextEditingController? get fullNameController => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement locationController
  TextEditingController? get locationController => throw UnimplementedError();

  @override
  // TODO: implement phoneNumberController
  TextEditingController? get phoneNumberController => throw UnimplementedError();

  @override
  // TODO: implement postTime
  DateTime? get postTime => throw UnimplementedError();

  @override
  // TODO: implement profilePicture
  File? get profilePicture => throw UnimplementedError();

  @override
  // TODO: implement userLatitude
  num get userLatitude => throw UnimplementedError();

  @override
  // TODO: implement userLongitude
  num get userLongitude => throw UnimplementedError();

  @override
  // TODO: implement videoFile
  File? get videoFile => throw UnimplementedError();

  @override
  // TODO: implement videoThumbnailImage
  Uint8List? get videoThumbnailImage => throw UnimplementedError();

  @override
  // TODO: implement videoThumbnailImageFile
  File? get videoThumbnailImageFile => throw UnimplementedError();

}