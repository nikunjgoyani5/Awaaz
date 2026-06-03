// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'go_live_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoLiveState {
  bool get isLoading;
  bool get shareAnonymous;
  Category? get selectedPostCategory;
  List<String> get hashtagList;
  List<Category> get categoryList;
  TextEditingController? get descriptionController;
  TextEditingController? get hashTagController;
  TextEditingController?
      get titleController; // TextEditingController? addressController,
  StringTagController? get stringTagController;
  num get userLatitude;
  num get userLongitude;
  DateTime? get postTime;
  int get totalUsers;
  GoogleAddressData? get googleAddressData;
  bool get isShowWatermarkAddress;
  File? get videoFile;
  File? get videoThumbImageFile;

  /// Create a copy of GoLiveState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoLiveStateCopyWith<GoLiveState> get copyWith =>
      _$GoLiveStateCopyWithImpl<GoLiveState>(this as GoLiveState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoLiveState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.shareAnonymous, shareAnonymous) ||
                other.shareAnonymous == shareAnonymous) &&
            (identical(other.selectedPostCategory, selectedPostCategory) ||
                other.selectedPostCategory == selectedPostCategory) &&
            const DeepCollectionEquality()
                .equals(other.hashtagList, hashtagList) &&
            const DeepCollectionEquality()
                .equals(other.categoryList, categoryList) &&
            (identical(other.descriptionController, descriptionController) ||
                other.descriptionController == descriptionController) &&
            (identical(other.hashTagController, hashTagController) ||
                other.hashTagController == hashTagController) &&
            (identical(other.titleController, titleController) ||
                other.titleController == titleController) &&
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
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      shareAnonymous,
      selectedPostCategory,
      const DeepCollectionEquality().hash(hashtagList),
      const DeepCollectionEquality().hash(categoryList),
      descriptionController,
      hashTagController,
      titleController,
      stringTagController,
      userLatitude,
      userLongitude,
      postTime,
      totalUsers,
      googleAddressData,
      isShowWatermarkAddress,
      videoFile,
      videoThumbImageFile);

  @override
  String toString() {
    return 'GoLiveState(isLoading: $isLoading, shareAnonymous: $shareAnonymous, selectedPostCategory: $selectedPostCategory, hashtagList: $hashtagList, categoryList: $categoryList, descriptionController: $descriptionController, hashTagController: $hashTagController, titleController: $titleController, stringTagController: $stringTagController, userLatitude: $userLatitude, userLongitude: $userLongitude, postTime: $postTime, totalUsers: $totalUsers, googleAddressData: $googleAddressData, isShowWatermarkAddress: $isShowWatermarkAddress, videoFile: $videoFile, videoThumbImageFile: $videoThumbImageFile)';
  }
}

/// @nodoc
abstract mixin class $GoLiveStateCopyWith<$Res> {
  factory $GoLiveStateCopyWith(
          GoLiveState value, $Res Function(GoLiveState) _then) =
      _$GoLiveStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      bool shareAnonymous,
      Category? selectedPostCategory,
      List<String> hashtagList,
      List<Category> categoryList,
      TextEditingController? descriptionController,
      TextEditingController? hashTagController,
      TextEditingController? titleController,
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
class _$GoLiveStateCopyWithImpl<$Res> implements $GoLiveStateCopyWith<$Res> {
  _$GoLiveStateCopyWithImpl(this._self, this._then);

  final GoLiveState _self;
  final $Res Function(GoLiveState) _then;

  /// Create a copy of GoLiveState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? shareAnonymous = null,
    Object? selectedPostCategory = freezed,
    Object? hashtagList = null,
    Object? categoryList = null,
    Object? descriptionController = freezed,
    Object? hashTagController = freezed,
    Object? titleController = freezed,
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
      selectedPostCategory: freezed == selectedPostCategory
          ? _self.selectedPostCategory
          : selectedPostCategory // ignore: cast_nullable_to_non_nullable
              as Category?,
      hashtagList: null == hashtagList
          ? _self.hashtagList
          : hashtagList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categoryList: null == categoryList
          ? _self.categoryList
          : categoryList // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      descriptionController: freezed == descriptionController
          ? _self.descriptionController
          : descriptionController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      hashTagController: freezed == hashTagController
          ? _self.hashTagController
          : hashTagController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      titleController: freezed == titleController
          ? _self.titleController
          : titleController // ignore: cast_nullable_to_non_nullable
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

class _Initial extends GoLiveState {
  const _Initial(
      {this.isLoading = false,
      this.shareAnonymous = false,
      this.selectedPostCategory,
      final List<String> hashtagList = const <String>[],
      final List<Category> categoryList = const <Category>[],
      this.descriptionController,
      this.hashTagController,
      this.titleController,
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
        super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool shareAnonymous;
  @override
  final Category? selectedPostCategory;
  final List<String> _hashtagList;
  @override
  @JsonKey()
  List<String> get hashtagList {
    if (_hashtagList is EqualUnmodifiableListView) return _hashtagList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hashtagList);
  }

  final List<Category> _categoryList;
  @override
  @JsonKey()
  List<Category> get categoryList {
    if (_categoryList is EqualUnmodifiableListView) return _categoryList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categoryList);
  }

  @override
  final TextEditingController? descriptionController;
  @override
  final TextEditingController? hashTagController;
  @override
  final TextEditingController? titleController;
// TextEditingController? addressController,
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

  /// Create a copy of GoLiveState
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
            (identical(other.selectedPostCategory, selectedPostCategory) ||
                other.selectedPostCategory == selectedPostCategory) &&
            const DeepCollectionEquality()
                .equals(other._hashtagList, _hashtagList) &&
            const DeepCollectionEquality()
                .equals(other._categoryList, _categoryList) &&
            (identical(other.descriptionController, descriptionController) ||
                other.descriptionController == descriptionController) &&
            (identical(other.hashTagController, hashTagController) ||
                other.hashTagController == hashTagController) &&
            (identical(other.titleController, titleController) ||
                other.titleController == titleController) &&
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
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      shareAnonymous,
      selectedPostCategory,
      const DeepCollectionEquality().hash(_hashtagList),
      const DeepCollectionEquality().hash(_categoryList),
      descriptionController,
      hashTagController,
      titleController,
      stringTagController,
      userLatitude,
      userLongitude,
      postTime,
      totalUsers,
      googleAddressData,
      isShowWatermarkAddress,
      videoFile,
      videoThumbImageFile);

  @override
  String toString() {
    return 'GoLiveState(isLoading: $isLoading, shareAnonymous: $shareAnonymous, selectedPostCategory: $selectedPostCategory, hashtagList: $hashtagList, categoryList: $categoryList, descriptionController: $descriptionController, hashTagController: $hashTagController, titleController: $titleController, stringTagController: $stringTagController, userLatitude: $userLatitude, userLongitude: $userLongitude, postTime: $postTime, totalUsers: $totalUsers, googleAddressData: $googleAddressData, isShowWatermarkAddress: $isShowWatermarkAddress, videoFile: $videoFile, videoThumbImageFile: $videoThumbImageFile)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $GoLiveStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      bool shareAnonymous,
      Category? selectedPostCategory,
      List<String> hashtagList,
      List<Category> categoryList,
      TextEditingController? descriptionController,
      TextEditingController? hashTagController,
      TextEditingController? titleController,
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

  /// Create a copy of GoLiveState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? shareAnonymous = null,
    Object? selectedPostCategory = freezed,
    Object? hashtagList = null,
    Object? categoryList = null,
    Object? descriptionController = freezed,
    Object? hashTagController = freezed,
    Object? titleController = freezed,
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
      selectedPostCategory: freezed == selectedPostCategory
          ? _self.selectedPostCategory
          : selectedPostCategory // ignore: cast_nullable_to_non_nullable
              as Category?,
      hashtagList: null == hashtagList
          ? _self._hashtagList
          : hashtagList // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categoryList: null == categoryList
          ? _self._categoryList
          : categoryList // ignore: cast_nullable_to_non_nullable
              as List<Category>,
      descriptionController: freezed == descriptionController
          ? _self.descriptionController
          : descriptionController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      hashTagController: freezed == hashTagController
          ? _self.hashTagController
          : hashTagController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      titleController: freezed == titleController
          ? _self.titleController
          : titleController // ignore: cast_nullable_to_non_nullable
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
