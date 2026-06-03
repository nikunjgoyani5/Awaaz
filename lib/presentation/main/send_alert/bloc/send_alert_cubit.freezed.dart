// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'send_alert_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SendAlertState {
  File? get profilePicture;
  File? get videoFile;
  Uint8List? get videoThumbnailImage;
  File? get videoThumbnailImageFile;
  TextEditingController? get fullNameController;
  TextEditingController? get locationController;
  TextEditingController? get descriptionController;
  TextEditingController? get phoneNumberController;
  TextEditingController? get dateTimeController;
  DateTime? get postTime;
  num get userLatitude;
  num get userLongitude;
  bool get isLoading;
  String get countryCode;

  /// Create a copy of SendAlertState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SendAlertStateCopyWith<SendAlertState> get copyWith =>
      _$SendAlertStateCopyWithImpl<SendAlertState>(
          this as SendAlertState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SendAlertState &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.videoFile, videoFile) ||
                other.videoFile == videoFile) &&
            const DeepCollectionEquality()
                .equals(other.videoThumbnailImage, videoThumbnailImage) &&
            (identical(
                    other.videoThumbnailImageFile, videoThumbnailImageFile) ||
                other.videoThumbnailImageFile == videoThumbnailImageFile) &&
            (identical(other.fullNameController, fullNameController) ||
                other.fullNameController == fullNameController) &&
            (identical(other.locationController, locationController) ||
                other.locationController == locationController) &&
            (identical(other.descriptionController, descriptionController) ||
                other.descriptionController == descriptionController) &&
            (identical(other.phoneNumberController, phoneNumberController) ||
                other.phoneNumberController == phoneNumberController) &&
            (identical(other.dateTimeController, dateTimeController) ||
                other.dateTimeController == dateTimeController) &&
            (identical(other.postTime, postTime) ||
                other.postTime == postTime) &&
            (identical(other.userLatitude, userLatitude) ||
                other.userLatitude == userLatitude) &&
            (identical(other.userLongitude, userLongitude) ||
                other.userLongitude == userLongitude) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      profilePicture,
      videoFile,
      const DeepCollectionEquality().hash(videoThumbnailImage),
      videoThumbnailImageFile,
      fullNameController,
      locationController,
      descriptionController,
      phoneNumberController,
      dateTimeController,
      postTime,
      userLatitude,
      userLongitude,
      isLoading,
      countryCode);

  @override
  String toString() {
    return 'SendAlertState(profilePicture: $profilePicture, videoFile: $videoFile, videoThumbnailImage: $videoThumbnailImage, videoThumbnailImageFile: $videoThumbnailImageFile, fullNameController: $fullNameController, locationController: $locationController, descriptionController: $descriptionController, phoneNumberController: $phoneNumberController, dateTimeController: $dateTimeController, postTime: $postTime, userLatitude: $userLatitude, userLongitude: $userLongitude, isLoading: $isLoading, countryCode: $countryCode)';
  }
}

/// @nodoc
abstract mixin class $SendAlertStateCopyWith<$Res> {
  factory $SendAlertStateCopyWith(
          SendAlertState value, $Res Function(SendAlertState) _then) =
      _$SendAlertStateCopyWithImpl;
  @useResult
  $Res call(
      {File? profilePicture,
      File? videoFile,
      Uint8List? videoThumbnailImage,
      File? videoThumbnailImageFile,
      TextEditingController? fullNameController,
      TextEditingController? locationController,
      TextEditingController? descriptionController,
      TextEditingController? phoneNumberController,
      TextEditingController? dateTimeController,
      DateTime? postTime,
      num userLatitude,
      num userLongitude,
      bool isLoading,
      String countryCode});
}

/// @nodoc
class _$SendAlertStateCopyWithImpl<$Res>
    implements $SendAlertStateCopyWith<$Res> {
  _$SendAlertStateCopyWithImpl(this._self, this._then);

  final SendAlertState _self;
  final $Res Function(SendAlertState) _then;

  /// Create a copy of SendAlertState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profilePicture = freezed,
    Object? videoFile = freezed,
    Object? videoThumbnailImage = freezed,
    Object? videoThumbnailImageFile = freezed,
    Object? fullNameController = freezed,
    Object? locationController = freezed,
    Object? descriptionController = freezed,
    Object? phoneNumberController = freezed,
    Object? dateTimeController = freezed,
    Object? postTime = freezed,
    Object? userLatitude = null,
    Object? userLongitude = null,
    Object? isLoading = null,
    Object? countryCode = null,
  }) {
    return _then(_self.copyWith(
      profilePicture: freezed == profilePicture
          ? _self.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as File?,
      videoFile: freezed == videoFile
          ? _self.videoFile
          : videoFile // ignore: cast_nullable_to_non_nullable
              as File?,
      videoThumbnailImage: freezed == videoThumbnailImage
          ? _self.videoThumbnailImage
          : videoThumbnailImage // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      videoThumbnailImageFile: freezed == videoThumbnailImageFile
          ? _self.videoThumbnailImageFile
          : videoThumbnailImageFile // ignore: cast_nullable_to_non_nullable
              as File?,
      fullNameController: freezed == fullNameController
          ? _self.fullNameController
          : fullNameController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      locationController: freezed == locationController
          ? _self.locationController
          : locationController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      descriptionController: freezed == descriptionController
          ? _self.descriptionController
          : descriptionController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      phoneNumberController: freezed == phoneNumberController
          ? _self.phoneNumberController
          : phoneNumberController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      dateTimeController: freezed == dateTimeController
          ? _self.dateTimeController
          : dateTimeController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      postTime: freezed == postTime
          ? _self.postTime
          : postTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userLatitude: null == userLatitude
          ? _self.userLatitude
          : userLatitude // ignore: cast_nullable_to_non_nullable
              as num,
      userLongitude: null == userLongitude
          ? _self.userLongitude
          : userLongitude // ignore: cast_nullable_to_non_nullable
              as num,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      countryCode: null == countryCode
          ? _self.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _Initial extends SendAlertState {
  const _Initial(
      {this.profilePicture,
      this.videoFile,
      this.videoThumbnailImage,
      this.videoThumbnailImageFile,
      this.fullNameController,
      this.locationController,
      this.descriptionController,
      this.phoneNumberController,
      this.dateTimeController,
      this.postTime,
      this.userLatitude = 0.0,
      this.userLongitude = 0.0,
      this.isLoading = false,
      this.countryCode = '+91'})
      : super._();

  @override
  final File? profilePicture;
  @override
  final File? videoFile;
  @override
  final Uint8List? videoThumbnailImage;
  @override
  final File? videoThumbnailImageFile;
  @override
  final TextEditingController? fullNameController;
  @override
  final TextEditingController? locationController;
  @override
  final TextEditingController? descriptionController;
  @override
  final TextEditingController? phoneNumberController;
  @override
  final TextEditingController? dateTimeController;
  @override
  final DateTime? postTime;
  @override
  @JsonKey()
  final num userLatitude;
  @override
  @JsonKey()
  final num userLongitude;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String countryCode;

  /// Create a copy of SendAlertState
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
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.videoFile, videoFile) ||
                other.videoFile == videoFile) &&
            const DeepCollectionEquality()
                .equals(other.videoThumbnailImage, videoThumbnailImage) &&
            (identical(
                    other.videoThumbnailImageFile, videoThumbnailImageFile) ||
                other.videoThumbnailImageFile == videoThumbnailImageFile) &&
            (identical(other.fullNameController, fullNameController) ||
                other.fullNameController == fullNameController) &&
            (identical(other.locationController, locationController) ||
                other.locationController == locationController) &&
            (identical(other.descriptionController, descriptionController) ||
                other.descriptionController == descriptionController) &&
            (identical(other.phoneNumberController, phoneNumberController) ||
                other.phoneNumberController == phoneNumberController) &&
            (identical(other.dateTimeController, dateTimeController) ||
                other.dateTimeController == dateTimeController) &&
            (identical(other.postTime, postTime) ||
                other.postTime == postTime) &&
            (identical(other.userLatitude, userLatitude) ||
                other.userLatitude == userLatitude) &&
            (identical(other.userLongitude, userLongitude) ||
                other.userLongitude == userLongitude) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      profilePicture,
      videoFile,
      const DeepCollectionEquality().hash(videoThumbnailImage),
      videoThumbnailImageFile,
      fullNameController,
      locationController,
      descriptionController,
      phoneNumberController,
      dateTimeController,
      postTime,
      userLatitude,
      userLongitude,
      isLoading,
      countryCode);

  @override
  String toString() {
    return 'SendAlertState(profilePicture: $profilePicture, videoFile: $videoFile, videoThumbnailImage: $videoThumbnailImage, videoThumbnailImageFile: $videoThumbnailImageFile, fullNameController: $fullNameController, locationController: $locationController, descriptionController: $descriptionController, phoneNumberController: $phoneNumberController, dateTimeController: $dateTimeController, postTime: $postTime, userLatitude: $userLatitude, userLongitude: $userLongitude, isLoading: $isLoading, countryCode: $countryCode)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $SendAlertStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {File? profilePicture,
      File? videoFile,
      Uint8List? videoThumbnailImage,
      File? videoThumbnailImageFile,
      TextEditingController? fullNameController,
      TextEditingController? locationController,
      TextEditingController? descriptionController,
      TextEditingController? phoneNumberController,
      TextEditingController? dateTimeController,
      DateTime? postTime,
      num userLatitude,
      num userLongitude,
      bool isLoading,
      String countryCode});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of SendAlertState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? profilePicture = freezed,
    Object? videoFile = freezed,
    Object? videoThumbnailImage = freezed,
    Object? videoThumbnailImageFile = freezed,
    Object? fullNameController = freezed,
    Object? locationController = freezed,
    Object? descriptionController = freezed,
    Object? phoneNumberController = freezed,
    Object? dateTimeController = freezed,
    Object? postTime = freezed,
    Object? userLatitude = null,
    Object? userLongitude = null,
    Object? isLoading = null,
    Object? countryCode = null,
  }) {
    return _then(_Initial(
      profilePicture: freezed == profilePicture
          ? _self.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as File?,
      videoFile: freezed == videoFile
          ? _self.videoFile
          : videoFile // ignore: cast_nullable_to_non_nullable
              as File?,
      videoThumbnailImage: freezed == videoThumbnailImage
          ? _self.videoThumbnailImage
          : videoThumbnailImage // ignore: cast_nullable_to_non_nullable
              as Uint8List?,
      videoThumbnailImageFile: freezed == videoThumbnailImageFile
          ? _self.videoThumbnailImageFile
          : videoThumbnailImageFile // ignore: cast_nullable_to_non_nullable
              as File?,
      fullNameController: freezed == fullNameController
          ? _self.fullNameController
          : fullNameController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      locationController: freezed == locationController
          ? _self.locationController
          : locationController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      descriptionController: freezed == descriptionController
          ? _self.descriptionController
          : descriptionController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      phoneNumberController: freezed == phoneNumberController
          ? _self.phoneNumberController
          : phoneNumberController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      dateTimeController: freezed == dateTimeController
          ? _self.dateTimeController
          : dateTimeController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      postTime: freezed == postTime
          ? _self.postTime
          : postTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      userLatitude: null == userLatitude
          ? _self.userLatitude
          : userLatitude // ignore: cast_nullable_to_non_nullable
              as num,
      userLongitude: null == userLongitude
          ? _self.userLongitude
          : userLongitude // ignore: cast_nullable_to_non_nullable
              as num,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      countryCode: null == countryCode
          ? _self.countryCode
          : countryCode // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
