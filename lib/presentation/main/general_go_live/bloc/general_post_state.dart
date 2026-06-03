part of 'general_post_cubit.dart';

@freezed
class GeneralPostState with _$GeneralPostState {
  GeneralPostState._();

  factory GeneralPostState.initial({
    @Default(false) bool isLoading,
    @Default(false) bool shareAnonymous,
    @Default("") String countryCode,
    CategorysModel? selectedCategory,
    SubCategory? selectedSubCategory,
    @Default(<String>[]) List<String> hashtagList,
    @Default(<CategorysModel>[]) List<CategorysModel> categoryList,
    @Default(<SubCategory>[]) List<SubCategory> subCategoryList,
    TextEditingController? descriptionController,
    TextEditingController? hashTagController,
    TextEditingController? phoneNumberController,
    TextEditingController? titleController,
    TextEditingController? addressController,
    StringTagController? stringTagController,
    @Default(0.0) num userLatitude,
    @Default(0.0) num userLongitude,
    DateTime? postTime,
    @Default(0) int totalUsers,
    GoogleAddressData? googleAddressData,
    @Default(true) bool isShowWatermarkAddress,
    File? videoFile,
    File? videoThumbImageFile,
  }) = _Initial;

  @override
  // TODO: implement addressController
  TextEditingController? get addressController => throw UnimplementedError();

  @override
  // TODO: implement categoryList
  List<CategorysModel> get categoryList => throw UnimplementedError();

  @override
  // TODO: implement countryCode
  String get countryCode => throw UnimplementedError();

  @override
  // TODO: implement descriptionController
  TextEditingController? get descriptionController =>
      throw UnimplementedError();

  @override
  // TODO: implement googleAddressData
  GoogleAddressData? get googleAddressData => throw UnimplementedError();

  @override
  // TODO: implement hashtagList
  List<String> get hashtagList => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement isShowWatermarkAddress
  bool get isShowWatermarkAddress => throw UnimplementedError();

  @override
  // TODO: implement phoneNumberController
  TextEditingController? get phoneNumberController =>
      throw UnimplementedError();

  @override
  // TODO: implement postTime
  DateTime? get postTime => throw UnimplementedError();

  @override
  // TODO: implement selectedCategory
  CategorysModel? get selectedCategory => throw UnimplementedError();

  @override
  // TODO: implement selectedSubCategory
  SubCategory? get selectedSubCategory => throw UnimplementedError();

  @override
  // TODO: implement shareAnonymous
  bool get shareAnonymous => throw UnimplementedError();

  @override
  // TODO: implement stringTagController
  StringTagController<String>? get stringTagController =>
      throw UnimplementedError();

  @override
  // TODO: implement subCategoryList
  List<SubCategory> get subCategoryList => throw UnimplementedError();

  @override
  // TODO: implement titleController
  TextEditingController? get titleController => throw UnimplementedError();

  @override
  // TODO: implement totalUsers
  int get totalUsers => throw UnimplementedError();

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
  // TODO: implement videoThumbImageFile
  File? get videoThumbImageFile => throw UnimplementedError();

  @override
  // TODO: implement hashTagController
  TextEditingController? get hashTagController => throw UnimplementedError();
}
