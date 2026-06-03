part of 'onboard_cubit.dart';

@freezed
class OnboardState with _$OnboardState {
  const OnboardState._();

  const factory OnboardState.initial({
    @Default(false) bool isLoading,
    TextEditingController? nameController,
    TextEditingController? dayController,
    TextEditingController? monthController,
    TextEditingController? yearController,
    TextEditingController? mobileNumberController,
    TextEditingController? userNameController,
    TextEditingController? birthDateController,
    @Default('') String day,
    @Default('') String month,
    @Default('') String year,
    File? profilePicture,
    DateTime? dob,
    @Default(0) int currentPage,
    PageController? pageController,
    Country? countryData,
}) = _Initial;

  @override
  // TODO: implement countryData
  get countryData => throw UnimplementedError();

  @override
  // TODO: implement currentPage
  int get currentPage => throw UnimplementedError();

  @override
  // TODO: implement day
  String get day => throw UnimplementedError();

  @override
  // TODO: implement dayController
  get dayController => throw UnimplementedError();

  @override
  // TODO: implement dob
  DateTime? get dob => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement mobileNumberController
  get mobileNumberController => throw UnimplementedError();
  @override
  // TODO: implement mobileNumberController
  get birthDateController => throw UnimplementedError();

  @override
  // TODO: implement month
  String get month => throw UnimplementedError();

  @override
  // TODO: implement monthController
  get monthController => throw UnimplementedError();

  @override
  // TODO: implement nameController
  get nameController => throw UnimplementedError();

  @override
  // TODO: implement pageController
  get pageController => throw UnimplementedError();

  @override
  // TODO: implement profilePicture
  get profilePicture => throw UnimplementedError();

  @override
  // TODO: implement userNameController
  get userNameController => throw UnimplementedError();

  @override
  // TODO: implement year
  String get year => throw UnimplementedError();

  @override
  // TODO: implement yearController
  get yearController => throw UnimplementedError();
}
