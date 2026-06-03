// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboard_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardState {
  bool get isLoading;
  TextEditingController? get nameController;
  TextEditingController? get dayController;
  TextEditingController? get monthController;
  TextEditingController? get yearController;
  TextEditingController? get mobileNumberController;
  TextEditingController? get userNameController;
  TextEditingController? get birthDateController;
  String get day;
  String get month;
  String get year;
  File? get profilePicture;
  DateTime? get dob;
  int get currentPage;
  PageController? get pageController;
  Country? get countryData;

  /// Create a copy of OnboardState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OnboardStateCopyWith<OnboardState> get copyWith =>
      _$OnboardStateCopyWithImpl<OnboardState>(
          this as OnboardState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OnboardState &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.nameController, nameController) ||
                other.nameController == nameController) &&
            (identical(other.dayController, dayController) ||
                other.dayController == dayController) &&
            (identical(other.monthController, monthController) ||
                other.monthController == monthController) &&
            (identical(other.yearController, yearController) ||
                other.yearController == yearController) &&
            (identical(other.mobileNumberController, mobileNumberController) ||
                other.mobileNumberController == mobileNumberController) &&
            (identical(other.userNameController, userNameController) ||
                other.userNameController == userNameController) &&
            (identical(other.birthDateController, birthDateController) ||
                other.birthDateController == birthDateController) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.dob, dob) || other.dob == dob) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.pageController, pageController) ||
                other.pageController == pageController) &&
            (identical(other.countryData, countryData) ||
                other.countryData == countryData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      nameController,
      dayController,
      monthController,
      yearController,
      mobileNumberController,
      userNameController,
      birthDateController,
      day,
      month,
      year,
      profilePicture,
      dob,
      currentPage,
      pageController,
      countryData);

  @override
  String toString() {
    return 'OnboardState(isLoading: $isLoading, nameController: $nameController, dayController: $dayController, monthController: $monthController, yearController: $yearController, mobileNumberController: $mobileNumberController, userNameController: $userNameController, birthDateController: $birthDateController, day: $day, month: $month, year: $year, profilePicture: $profilePicture, dob: $dob, currentPage: $currentPage, pageController: $pageController, countryData: $countryData)';
  }
}

/// @nodoc
abstract mixin class $OnboardStateCopyWith<$Res> {
  factory $OnboardStateCopyWith(
          OnboardState value, $Res Function(OnboardState) _then) =
      _$OnboardStateCopyWithImpl;
  @useResult
  $Res call(
      {bool isLoading,
      TextEditingController? nameController,
      TextEditingController? dayController,
      TextEditingController? monthController,
      TextEditingController? yearController,
      TextEditingController? mobileNumberController,
      TextEditingController? userNameController,
      TextEditingController? birthDateController,
      String day,
      String month,
      String year,
      File? profilePicture,
      DateTime? dob,
      int currentPage,
      PageController? pageController,
      Country? countryData});
}

/// @nodoc
class _$OnboardStateCopyWithImpl<$Res> implements $OnboardStateCopyWith<$Res> {
  _$OnboardStateCopyWithImpl(this._self, this._then);

  final OnboardState _self;
  final $Res Function(OnboardState) _then;

  /// Create a copy of OnboardState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? nameController = freezed,
    Object? dayController = freezed,
    Object? monthController = freezed,
    Object? yearController = freezed,
    Object? mobileNumberController = freezed,
    Object? userNameController = freezed,
    Object? birthDateController = freezed,
    Object? day = null,
    Object? month = null,
    Object? year = null,
    Object? profilePicture = freezed,
    Object? dob = freezed,
    Object? currentPage = null,
    Object? pageController = freezed,
    Object? countryData = freezed,
  }) {
    return _then(_self.copyWith(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      nameController: freezed == nameController
          ? _self.nameController
          : nameController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      dayController: freezed == dayController
          ? _self.dayController
          : dayController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      monthController: freezed == monthController
          ? _self.monthController
          : monthController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      yearController: freezed == yearController
          ? _self.yearController
          : yearController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      mobileNumberController: freezed == mobileNumberController
          ? _self.mobileNumberController
          : mobileNumberController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      userNameController: freezed == userNameController
          ? _self.userNameController
          : userNameController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      birthDateController: freezed == birthDateController
          ? _self.birthDateController
          : birthDateController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      day: null == day
          ? _self.day
          : day // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
      profilePicture: freezed == profilePicture
          ? _self.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as File?,
      dob: freezed == dob
          ? _self.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageController: freezed == pageController
          ? _self.pageController
          : pageController // ignore: cast_nullable_to_non_nullable
              as PageController?,
      countryData: freezed == countryData
          ? _self.countryData
          : countryData // ignore: cast_nullable_to_non_nullable
              as Country?,
    ));
  }
}

/// @nodoc

class _Initial extends OnboardState {
  const _Initial(
      {this.isLoading = false,
      this.nameController,
      this.dayController,
      this.monthController,
      this.yearController,
      this.mobileNumberController,
      this.userNameController,
      this.birthDateController,
      this.day = '',
      this.month = '',
      this.year = '',
      this.profilePicture,
      this.dob,
      this.currentPage = 0,
      this.pageController,
      this.countryData})
      : super._();

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final TextEditingController? nameController;
  @override
  final TextEditingController? dayController;
  @override
  final TextEditingController? monthController;
  @override
  final TextEditingController? yearController;
  @override
  final TextEditingController? mobileNumberController;
  @override
  final TextEditingController? userNameController;
  @override
  final TextEditingController? birthDateController;
  @override
  @JsonKey()
  final String day;
  @override
  @JsonKey()
  final String month;
  @override
  @JsonKey()
  final String year;
  @override
  final File? profilePicture;
  @override
  final DateTime? dob;
  @override
  @JsonKey()
  final int currentPage;
  @override
  final PageController? pageController;
  @override
  final Country? countryData;

  /// Create a copy of OnboardState
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
            (identical(other.nameController, nameController) ||
                other.nameController == nameController) &&
            (identical(other.dayController, dayController) ||
                other.dayController == dayController) &&
            (identical(other.monthController, monthController) ||
                other.monthController == monthController) &&
            (identical(other.yearController, yearController) ||
                other.yearController == yearController) &&
            (identical(other.mobileNumberController, mobileNumberController) ||
                other.mobileNumberController == mobileNumberController) &&
            (identical(other.userNameController, userNameController) ||
                other.userNameController == userNameController) &&
            (identical(other.birthDateController, birthDateController) ||
                other.birthDateController == birthDateController) &&
            (identical(other.day, day) || other.day == day) &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.dob, dob) || other.dob == dob) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.pageController, pageController) ||
                other.pageController == pageController) &&
            (identical(other.countryData, countryData) ||
                other.countryData == countryData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isLoading,
      nameController,
      dayController,
      monthController,
      yearController,
      mobileNumberController,
      userNameController,
      birthDateController,
      day,
      month,
      year,
      profilePicture,
      dob,
      currentPage,
      pageController,
      countryData);

  @override
  String toString() {
    return 'OnboardState.initial(isLoading: $isLoading, nameController: $nameController, dayController: $dayController, monthController: $monthController, yearController: $yearController, mobileNumberController: $mobileNumberController, userNameController: $userNameController, birthDateController: $birthDateController, day: $day, month: $month, year: $year, profilePicture: $profilePicture, dob: $dob, currentPage: $currentPage, pageController: $pageController, countryData: $countryData)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $OnboardStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      TextEditingController? nameController,
      TextEditingController? dayController,
      TextEditingController? monthController,
      TextEditingController? yearController,
      TextEditingController? mobileNumberController,
      TextEditingController? userNameController,
      TextEditingController? birthDateController,
      String day,
      String month,
      String year,
      File? profilePicture,
      DateTime? dob,
      int currentPage,
      PageController? pageController,
      Country? countryData});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of OnboardState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isLoading = null,
    Object? nameController = freezed,
    Object? dayController = freezed,
    Object? monthController = freezed,
    Object? yearController = freezed,
    Object? mobileNumberController = freezed,
    Object? userNameController = freezed,
    Object? birthDateController = freezed,
    Object? day = null,
    Object? month = null,
    Object? year = null,
    Object? profilePicture = freezed,
    Object? dob = freezed,
    Object? currentPage = null,
    Object? pageController = freezed,
    Object? countryData = freezed,
  }) {
    return _then(_Initial(
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      nameController: freezed == nameController
          ? _self.nameController
          : nameController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      dayController: freezed == dayController
          ? _self.dayController
          : dayController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      monthController: freezed == monthController
          ? _self.monthController
          : monthController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      yearController: freezed == yearController
          ? _self.yearController
          : yearController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      mobileNumberController: freezed == mobileNumberController
          ? _self.mobileNumberController
          : mobileNumberController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      userNameController: freezed == userNameController
          ? _self.userNameController
          : userNameController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      birthDateController: freezed == birthDateController
          ? _self.birthDateController
          : birthDateController // ignore: cast_nullable_to_non_nullable
              as TextEditingController?,
      day: null == day
          ? _self.day
          : day // ignore: cast_nullable_to_non_nullable
              as String,
      month: null == month
          ? _self.month
          : month // ignore: cast_nullable_to_non_nullable
              as String,
      year: null == year
          ? _self.year
          : year // ignore: cast_nullable_to_non_nullable
              as String,
      profilePicture: freezed == profilePicture
          ? _self.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as File?,
      dob: freezed == dob
          ? _self.dob
          : dob // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      pageController: freezed == pageController
          ? _self.pageController
          : pageController // ignore: cast_nullable_to_non_nullable
              as PageController?,
      countryData: freezed == countryData
          ? _self.countryData
          : countryData // ignore: cast_nullable_to_non_nullable
              as Country?,
    ));
  }
}

// dart format on
