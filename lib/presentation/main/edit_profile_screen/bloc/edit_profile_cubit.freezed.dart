// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EditProfileState {
  File? get profilePicture;
  TextEditingController? get nameController;
  TextEditingController? get userNameController;
  TextEditingController? get dobNameController;
  String? get profilePictureUrl;
  DateTime? get dob;
  bool get isLoading;

  /// Create a copy of EditProfileState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EditProfileStateCopyWith<EditProfileState> get copyWith =>
      _$EditProfileStateCopyWithImpl<EditProfileState>(
          this as EditProfileState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EditProfileState &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.nameController, nameController) ||
                other.nameController == nameController) &&
            (identical(other.userNameController, userNameController) ||
                other.userNameController == userNameController) &&
            (identical(other.dobNameController, dobNameController) ||
                other.dobNameController == dobNameController) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl) &&
            (identical(other.dob, dob) || other.dob == dob) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profilePicture, nameController,
      userNameController, dobNameController, profilePictureUrl, dob, isLoading);

  @override
  String toString() {
    return 'EditProfileState(profilePicture: $profilePicture, nameController: $nameController, userNameController: $userNameController, dobNameController: $dobNameController, profilePictureUrl: $profilePictureUrl, dob: $dob, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class $EditProfileStateCopyWith<$Res> {
  factory $EditProfileStateCopyWith(
          EditProfileState value, $Res Function(EditProfileState) _then) =
      _$EditProfileStateCopyWithImpl;
  @useResult
  $Res call(
      {File? profilePicture,
      TextEditingController? nameController,
      TextEditingController? userNameController,
      TextEditingController? dobNameController,
      String? profilePictureUrl,
      DateTime? dob,
      bool isLoading});
}

/// @nodoc
class _$EditProfileStateCopyWithImpl<$Res>
    implements $EditProfileStateCopyWith<$Res> {
  _$EditProfileStateCopyWithImpl(this._self, this._then);

  final EditProfileState _self;
  final $Res Function(EditProfileState) _then;

  /// Create a copy of EditProfileState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profilePicture = freezed,
    Object? nameController = freezed,
    Object? userNameController = freezed,
    Object? dobNameController = freezed,
    Object? profilePictureUrl = freezed,
    Object? dob = freezed,
    Object? isLoading = null,
  }) {
    return _then(_self.copyWith(
      profilePicture: freezed == profilePicture
          ? _self.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as File?,
      nameController: freezed == nameController
          ? _self.nameController
          : nameController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      userNameController: freezed == userNameController
          ? _self.userNameController
          : userNameController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      dobNameController: freezed == dobNameController
          ? _self.dobNameController
          : dobNameController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      profilePictureUrl: freezed == profilePictureUrl
          ? _self.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dob: freezed == dob
          ? _self.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _Initial extends EditProfileState {
  const _Initial(
      {this.profilePicture,
      this.nameController,
      this.userNameController,
      this.dobNameController,
      this.profilePictureUrl,
      this.dob,
      this.isLoading = false})
      : super._();

  @override
  final File? profilePicture;
  @override
  final TextEditingController? nameController;
  @override
  final TextEditingController? userNameController;
  @override
  final TextEditingController? dobNameController;
  @override
  final String? profilePictureUrl;
  @override
  final DateTime? dob;
  @override
  @JsonKey()
  final bool isLoading;

  /// Create a copy of EditProfileState
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
            (identical(other.nameController, nameController) ||
                other.nameController == nameController) &&
            (identical(other.userNameController, userNameController) ||
                other.userNameController == userNameController) &&
            (identical(other.dobNameController, dobNameController) ||
                other.dobNameController == dobNameController) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl) &&
            (identical(other.dob, dob) || other.dob == dob) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profilePicture, nameController,
      userNameController, dobNameController, profilePictureUrl, dob, isLoading);

  @override
  String toString() {
    return 'EditProfileState(profilePicture: $profilePicture, nameController: $nameController, userNameController: $userNameController, dobNameController: $dobNameController, profilePictureUrl: $profilePictureUrl, dob: $dob, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $EditProfileStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {File? profilePicture,
      TextEditingController? nameController,
      TextEditingController? userNameController,
      TextEditingController? dobNameController,
      String? profilePictureUrl,
      DateTime? dob,
      bool isLoading});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of EditProfileState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? profilePicture = freezed,
    Object? nameController = freezed,
    Object? userNameController = freezed,
    Object? dobNameController = freezed,
    Object? profilePictureUrl = freezed,
    Object? dob = freezed,
    Object? isLoading = null,
  }) {
    return _then(_Initial(
      profilePicture: freezed == profilePicture
          ? _self.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as File?,
      nameController: freezed == nameController
          ? _self.nameController
          : nameController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      userNameController: freezed == userNameController
          ? _self.userNameController
          : userNameController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      dobNameController: freezed == dobNameController
          ? _self.dobNameController
          : dobNameController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      profilePictureUrl: freezed == profilePictureUrl
          ? _self.profilePictureUrl
          : profilePictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      dob: freezed == dob
          ? _self.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
