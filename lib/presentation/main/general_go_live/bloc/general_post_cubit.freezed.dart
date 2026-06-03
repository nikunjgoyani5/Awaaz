// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'general_post_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeneralPostState {
  bool get isLoading;
  bool get shareAnonymous;
  String get countryCode;
  CategorysModel? get selectedCategory;
  SubCategory? get selectedSubCategory;
  List<String> get hashtagList;
  List<CategorysModel> get categoryList;
  List<SubCategory> get subCategoryList;
  TextEditingController? get descriptionController;
  TextEditingController? get hashTagController;
  TextEditingController? get phoneNumberController;
  TextEditingController? get titleController;
  TextEditingController? get addressController;
  StringTagController? get stringTagController;
  num get userLatitude;
  num get userLongitude;
  DateTime? get postTime;
  int get totalUsers;
  GoogleAddressData? get googleAddressData;
  bool get isShowWatermarkAddress;
  File? get videoFile;
  File? get videoThumbImageFile;

  /// Create a copy of GeneralPostState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GeneralPostStateCopyWith<GeneralPostState> get copyWith =>
      _$GeneralPostStateCopyWithImpl<GeneralPostState>(
          this as GeneralPostState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GeneralPostState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.shareAnonymous, shareAnonymous) ||
                other.shareAnonymous == shareAnonymous) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedSubCategory, selectedSubCategory) ||
                other.selectedSubCategory == selectedSubCategory) &&
            const DeepCollectionEquality()
                .equals(other.hashtagList, hashtagList) &&
            const DeepCollectionEquality()
                .equals(other.categoryList, categoryList) &&
            const DeepCollectionEquality()
                .equals(other.subCategoryList, subCategoryList) &&
            (identical(other.descriptionController, descriptionController) ||
                other.descriptionController == descriptionController) &&
            (identical(other.hashTagController, hashTagController) ||
                other.hashTagController == hashTagController) &&
            (identical(other.phoneNumberController, phoneNumberController) ||
                other.phoneNumberController == phoneNumberController) &&
            (identical(other.titleController, titleController) ||
                other.titleController == titleController) &&
            (identical(other.addressController, addressController) ||
                other.addressController == addressController) &&
            (identical(other.stringTagController, stringTagController) ||
                other.stringTagController == stringTagController) &&
            (identical(other.userLatitude, userLatitude) ||
                other.userLatitude == userLatitude) &&
            (identical(other.userLongitude, userLongitude) ||
                other.userLongitude == userLongitude) &&
            (identical(other.postTime, postTime) ||
                other.postTime == postTime) &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.googleAddressData, googleAddressData) ||
                other.googleAddressData == googleAddressData) &&
            (identical(other.isShowWatermarkAddress, isShowWatermarkAddress) ||
                other.isShowWatermarkAddress == isShowWatermarkAddress) &&
            (identical(other.videoFile, videoFile) ||
                other.videoFile == videoFile) &&
            (identical(other.videoThumbImageFile, videoThumbImageFile) ||
                other.videoThumbImageFile == videoThumbImageFile));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        isLoading,
        shareAnonymous,
        countryCode,
        selectedCategory,
        selectedSubCategory,
        const DeepCollectionEquality().hash(hashtagList),
        const DeepCollectionEquality().hash(categoryList),
        const DeepCollectionEquality().hash(subCategoryList),
        descriptionController,
        hashTagController,
        phoneNumberController,
        titleController,
        addressController,
        stringTagController,
        userLatitude,
        userLongitude,
        postTime,
        totalUsers,
        googleAddressData,
        isShowWatermarkAddress,
        videoFile,
        videoThumbImageFile
      ]);

  @override
  String toString() {
    return 'GeneralPostState(isLoading: $isLoading, shareAnonymous: $shareAnonymous, countryCode: $countryCode, selectedCategory: $selectedCategory, selectedSubCategory: $selectedSubCategory, hashtagList: $hashtagList, categoryList: $categoryList, subCategoryList: $subCategoryList, descriptionController: $descriptionController, hashTagController: $hashTagController, phoneNumberController: $phoneNumberController, titleController: $titleController, addressController: $addressController, stringTagController: $stringTagController, userLatitude: $userLatitude, userLongitude: $userLongitude, postTime: $postTime, totalUsers: $totalUsers, googleAddressData: $googleAddressData, isShowWatermarkAddress: $isShowWatermarkAddress, videoFile: $videoFile, videoThumbImageFile: $videoThumbImageFile)';
  }
}

/// @nodoc
abstract mixin class $GeneralPostStateCopyWith<$Res> {
  factory $GeneralPostStateCopyWith(
          GeneralPostState value, $Res Function(GeneralPostState) _then) =
      _$GeneralPostStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      bool shareAnonymous,
      String countryCode,
      CategorysModel? selectedCategory,
      SubCategory? selectedSubCategory,
      List<String> hashtagList,
      List<CategorysModel> categoryList,
      List<SubCategory> subCategoryList,
      TextEditingController? descriptionController,
      TextEditingController? hashTagController,
      TextEditingController? phoneNumberController,
      TextEditingController? titleController,
      TextEditingController? addressController,
      StringTagController? stringTagController,
      num userLatitude,
      num userLongitude,
      DateTime? postTime,
      int totalUsers,
      GoogleAddressData? googleAddressData,
      bool isShowWatermarkAddress,
      File? videoFile,
      File? videoThumbImageFile});
}

/// @nodoc
class _$GeneralPostStateCopyWithImpl<$Res>
    implements $GeneralPostStateCopyWith<$Res> {
  _$GeneralPostStateCopyWithImpl(this._self, this._then);

  final GeneralPostState _self;
  final $Res Function(GeneralPostState) _then;

  /// Create a copy of GeneralPostState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? shareAnonymous = null,
    Object? countryCode = null,
    Object? selectedCategory = freezed,
    Object? selectedSubCategory = freezed,
    Object? hashtagList = null,
    Object? categoryList = null,
    Object? subCategoryList = null,
    Object? descriptionController = freezed,
    Object? hashTagController = freezed,
    Object? phoneNumberController = freezed,
    Object? titleController = freezed,
    Object? addressController = freezed,
    Object? stringTagController = freezed,
    Object? userLatitude = null,
    Object? userLongitude = null,
    Object? postTime = freezed,
    Object? totalUsers = null,
    Object? googleAddressData = freezed,
    Object? isShowWatermarkAddress = null,
    Object? videoFile = freezed,
    Object? videoThumbImageFile = freezed,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      shareAnonymous: null == shareAnonymous
          ? _self.shareAnonymous
          : shareAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      countryCode: null == countryCode
          ? _self.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategory: freezed == selectedCategory
          ? _self.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as CategorysModel?,
      selectedSubCategory: freezed == selectedSubCategory
          ? _self.selectedSubCategory
          : selectedSubCategory // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      hashtagList: null == hashtagList
          ? _self.hashtagList
          : hashtagList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categoryList: null == categoryList
          ? _self.categoryList
          : categoryList // ignore: cast_nullable_to_non_nullable
              as List<CategorysModel>,
      subCategoryList: null == subCategoryList
          ? _self.subCategoryList
          : subCategoryList // ignore: cast_nullable_to_non_nullable
              as List<SubCategory>,
      descriptionController: freezed == descriptionController
          ? _self.descriptionController
          : descriptionController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      hashTagController: freezed == hashTagController
          ? _self.hashTagController
          : hashTagController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      phoneNumberController: freezed == phoneNumberController
          ? _self.phoneNumberController
          : phoneNumberController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      titleController: freezed == titleController
          ? _self.titleController
          : titleController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      addressController: freezed == addressController
          ? _self.addressController
          : addressController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      stringTagController: freezed == stringTagController
          ? _self.stringTagController
          : stringTagController // ignore: cast_nullable_to_non_nullable
              as StringTagController?,
      userLatitude: null == userLatitude
          ? _self.userLatitude
          : userLatitude // ignore: cast_nullable_to_non_nullable
              as num,
      userLongitude: null == userLongitude
          ? _self.userLongitude
          : userLongitude // ignore: cast_nullable_to_non_nullable
              as num,
      postTime: freezed == postTime
          ? _self.postTime
          : postTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalUsers: null == totalUsers
          ? _self.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      googleAddressData: freezed == googleAddressData
          ? _self.googleAddressData
          : googleAddressData // ignore: cast_nullable_to_non_nullable
              as GoogleAddressData?,
      isShowWatermarkAddress: null == isShowWatermarkAddress
          ? _self.isShowWatermarkAddress
          : isShowWatermarkAddress // ignore: cast_nullable_to_non_nullable
              as bool,
      videoFile: freezed == videoFile
          ? _self.videoFile
          : videoFile // ignore: cast_nullable_to_non_nullable
              as File?,
      videoThumbImageFile: freezed == videoThumbImageFile
          ? _self.videoThumbImageFile
          : videoThumbImageFile // ignore: cast_nullable_to_non_nullable
              as File?,
    ));
  }
}

/// @nodoc

class _Initial extends GeneralPostState {
  _Initial(
      {this.isLoading = false,
      this.shareAnonymous = false,
      this.countryCode = "",
      this.selectedCategory,
      this.selectedSubCategory,
      final List<String> hashtagList = const <String>[],
      final List<CategorysModel> categoryList = const <CategorysModel>[],
      final List<SubCategory> subCategoryList = const <SubCategory>[],
      this.descriptionController,
      this.hashTagController,
      this.phoneNumberController,
      this.titleController,
      this.addressController,
      this.stringTagController,
      this.userLatitude = 0.0,
      this.userLongitude = 0.0,
      this.postTime,
      this.totalUsers = 0,
      this.googleAddressData,
      this.isShowWatermarkAddress = true,
      this.videoFile,
      this.videoThumbImageFile})
      : _hashtagList = hashtagList,
        _categoryList = categoryList,
        _subCategoryList = subCategoryList,
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool shareAnonymous;
  @override
  @JsonKey()
  final String countryCode;
  @override
  final CategorysModel? selectedCategory;
  @override
  final SubCategory? selectedSubCategory;
  final List<String> _hashtagList;
  @override
  @JsonKey()
  List<String> get hashtagList {
    if (_hashtagList is EqualUnmodifiableListView) return _hashtagList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hashtagList);
  }

  final List<CategorysModel> _categoryList;
  @override
  @JsonKey()
  List<CategorysModel> get categoryList {
    if (_categoryList is EqualUnmodifiableListView) return _categoryList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryList);
  }

  final List<SubCategory> _subCategoryList;
  @override
  @JsonKey()
  List<SubCategory> get subCategoryList {
    if (_subCategoryList is EqualUnmodifiableListView) return _subCategoryList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subCategoryList);
  }

  @override
  final TextEditingController? descriptionController;
  @override
  final TextEditingController? hashTagController;
  @override
  final TextEditingController? phoneNumberController;
  @override
  final TextEditingController? titleController;
  @override
  final TextEditingController? addressController;
  @override
  final StringTagController? stringTagController;
  @override
  @JsonKey()
  final num userLatitude;
  @override
  @JsonKey()
  final num userLongitude;
  @override
  final DateTime? postTime;
  @override
  @JsonKey()
  final int totalUsers;
  @override
  final GoogleAddressData? googleAddressData;
  @override
  @JsonKey()
  final bool isShowWatermarkAddress;
  @override
  final File? videoFile;
  @override
  final File? videoThumbImageFile;

  /// Create a copy of GeneralPostState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$InitialCopyWith<_Initial> get copyWith =>
      __$InitialCopyWithImpl<_Initial>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Initial &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.shareAnonymous, shareAnonymous) ||
                other.shareAnonymous == shareAnonymous) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.selectedSubCategory, selectedSubCategory) ||
                other.selectedSubCategory == selectedSubCategory) &&
            const DeepCollectionEquality()
                .equals(other._hashtagList, _hashtagList) &&
            const DeepCollectionEquality()
                .equals(other._categoryList, _categoryList) &&
            const DeepCollectionEquality()
                .equals(other._subCategoryList, _subCategoryList) &&
            (identical(other.descriptionController, descriptionController) ||
                other.descriptionController == descriptionController) &&
            (identical(other.hashTagController, hashTagController) ||
                other.hashTagController == hashTagController) &&
            (identical(other.phoneNumberController, phoneNumberController) ||
                other.phoneNumberController == phoneNumberController) &&
            (identical(other.titleController, titleController) ||
                other.titleController == titleController) &&
            (identical(other.addressController, addressController) ||
                other.addressController == addressController) &&
            (identical(other.stringTagController, stringTagController) ||
                other.stringTagController == stringTagController) &&
            (identical(other.userLatitude, userLatitude) ||
                other.userLatitude == userLatitude) &&
            (identical(other.userLongitude, userLongitude) ||
                other.userLongitude == userLongitude) &&
            (identical(other.postTime, postTime) ||
                other.postTime == postTime) &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.googleAddressData, googleAddressData) ||
                other.googleAddressData == googleAddressData) &&
            (identical(other.isShowWatermarkAddress, isShowWatermarkAddress) ||
                other.isShowWatermarkAddress == isShowWatermarkAddress) &&
            (identical(other.videoFile, videoFile) ||
                other.videoFile == videoFile) &&
            (identical(other.videoThumbImageFile, videoThumbImageFile) ||
                other.videoThumbImageFile == videoThumbImageFile));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        isLoading,
        shareAnonymous,
        countryCode,
        selectedCategory,
        selectedSubCategory,
        const DeepCollectionEquality().hash(_hashtagList),
        const DeepCollectionEquality().hash(_categoryList),
        const DeepCollectionEquality().hash(_subCategoryList),
        descriptionController,
        hashTagController,
        phoneNumberController,
        titleController,
        addressController,
        stringTagController,
        userLatitude,
        userLongitude,
        postTime,
        totalUsers,
        googleAddressData,
        isShowWatermarkAddress,
        videoFile,
        videoThumbImageFile
      ]);

  @override
  String toString() {
    return 'GeneralPostState.initial(isLoading: $isLoading, shareAnonymous: $shareAnonymous, countryCode: $countryCode, selectedCategory: $selectedCategory, selectedSubCategory: $selectedSubCategory, hashtagList: $hashtagList, categoryList: $categoryList, subCategoryList: $subCategoryList, descriptionController: $descriptionController, hashTagController: $hashTagController, phoneNumberController: $phoneNumberController, titleController: $titleController, addressController: $addressController, stringTagController: $stringTagController, userLatitude: $userLatitude, userLongitude: $userLongitude, postTime: $postTime, totalUsers: $totalUsers, googleAddressData: $googleAddressData, isShowWatermarkAddress: $isShowWatermarkAddress, videoFile: $videoFile, videoThumbImageFile: $videoThumbImageFile)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $GeneralPostStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool shareAnonymous,
      String countryCode,
      CategorysModel? selectedCategory,
      SubCategory? selectedSubCategory,
      List<String> hashtagList,
      List<CategorysModel> categoryList,
      List<SubCategory> subCategoryList,
      TextEditingController? descriptionController,
      TextEditingController? hashTagController,
      TextEditingController? phoneNumberController,
      TextEditingController? titleController,
      TextEditingController? addressController,
      StringTagController? stringTagController,
      num userLatitude,
      num userLongitude,
      DateTime? postTime,
      int totalUsers,
      GoogleAddressData? googleAddressData,
      bool isShowWatermarkAddress,
      File? videoFile,
      File? videoThumbImageFile});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of GeneralPostState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? shareAnonymous = null,
    Object? countryCode = null,
    Object? selectedCategory = freezed,
    Object? selectedSubCategory = freezed,
    Object? hashtagList = null,
    Object? categoryList = null,
    Object? subCategoryList = null,
    Object? descriptionController = freezed,
    Object? hashTagController = freezed,
    Object? phoneNumberController = freezed,
    Object? titleController = freezed,
    Object? addressController = freezed,
    Object? stringTagController = freezed,
    Object? userLatitude = null,
    Object? userLongitude = null,
    Object? postTime = freezed,
    Object? totalUsers = null,
    Object? googleAddressData = freezed,
    Object? isShowWatermarkAddress = null,
    Object? videoFile = freezed,
    Object? videoThumbImageFile = freezed,
  }) {
    return _then(_Initial(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      shareAnonymous: null == shareAnonymous
          ? _self.shareAnonymous
          : shareAnonymous // ignore: cast_nullable_to_non_nullable
              as bool,
      countryCode: null == countryCode
          ? _self.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCategory: freezed == selectedCategory
          ? _self.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as CategorysModel?,
      selectedSubCategory: freezed == selectedSubCategory
          ? _self.selectedSubCategory
          : selectedSubCategory // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      hashtagList: null == hashtagList
          ? _self._hashtagList
          : hashtagList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categoryList: null == categoryList
          ? _self._categoryList
          : categoryList // ignore: cast_nullable_to_non_nullable
              as List<CategorysModel>,
      subCategoryList: null == subCategoryList
          ? _self._subCategoryList
          : subCategoryList // ignore: cast_nullable_to_non_nullable
              as List<SubCategory>,
      descriptionController: freezed == descriptionController
          ? _self.descriptionController
          : descriptionController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      hashTagController: freezed == hashTagController
          ? _self.hashTagController
          : hashTagController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      phoneNumberController: freezed == phoneNumberController
          ? _self.phoneNumberController
          : phoneNumberController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      titleController: freezed == titleController
          ? _self.titleController
          : titleController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      addressController: freezed == addressController
          ? _self.addressController
          : addressController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      stringTagController: freezed == stringTagController
          ? _self.stringTagController
          : stringTagController // ignore: cast_nullable_to_non_nullable
              as StringTagController?,
      userLatitude: null == userLatitude
          ? _self.userLatitude
          : userLatitude // ignore: cast_nullable_to_non_nullable
              as num,
      userLongitude: null == userLongitude
          ? _self.userLongitude
          : userLongitude // ignore: cast_nullable_to_non_nullable
              as num,
      postTime: freezed == postTime
          ? _self.postTime
          : postTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalUsers: null == totalUsers
          ? _self.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      googleAddressData: freezed == googleAddressData
          ? _self.googleAddressData
          : googleAddressData // ignore: cast_nullable_to_non_nullable
              as GoogleAddressData?,
      isShowWatermarkAddress: null == isShowWatermarkAddress
          ? _self.isShowWatermarkAddress
          : isShowWatermarkAddress // ignore: cast_nullable_to_non_nullable
              as bool,
      videoFile: freezed == videoFile
          ? _self.videoFile
          : videoFile // ignore: cast_nullable_to_non_nullable
              as File?,
      videoThumbImageFile: freezed == videoThumbImageFile
          ? _self.videoThumbImageFile
          : videoThumbImageFile // ignore: cast_nullable_to_non_nullable
              as File?,
    ));
  }
}

// dart format on
