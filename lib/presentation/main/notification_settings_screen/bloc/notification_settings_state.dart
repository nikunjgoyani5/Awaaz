part of 'notification_settings_cubit.dart';

@freezed
class NotificationSettingsState with _$NotificationSettingsState {
  const NotificationSettingsState._();
  const factory NotificationSettingsState({
    @Default(0.0) double selectedRange,
    @Default(false) bool isLoading,
    @Default(true) bool dangerousNotification,
    @Default(true) bool trafficNotification,
    @Default(true) bool firearmIncidentNotification,
    @Default(true) bool physicalAltercationNotification,
    @Default(true) bool minorFiresNotification,
    @Default(true) bool majorBlazesNotification,
    @Default(true) bool lostPersonsNotification,
    @Default(true) bool lostPetsNotification,
    @Default(true) bool communityHealthNotification,
    @Default(true) bool serverWeatherNotification,
    @Default(true) bool localOffenderNotification,
    @Default(true) bool transportNotification,
    @Default(true) bool promotionalNotification,
    @Default(true) bool policeNotification,
    @Default(true) bool rallyNotification,
    @Default(true) bool massRunningNotification,
    @Default(true) bool goonsNotification,
    @Default(true) bool unknownEventNotification,
    @Default(true) bool otherNotification,
    MapboxMap? mapboxMap,
    CameraOptions? camera,
  }) = _Initial;

  @override
  // TODO: implement camera
  CameraOptions? get camera => throw UnimplementedError();

  @override
  // TODO: implement communityHealthNotification
  bool get communityHealthNotification => throw UnimplementedError();

  @override
  // TODO: implement dangerousNotification
  bool get dangerousNotification => throw UnimplementedError();

  @override
  // TODO: implement firearmIncidentNotification
  bool get firearmIncidentNotification => throw UnimplementedError();

  @override
  // TODO: implement goonsNotification
  bool get goonsNotification => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement localOffenderNotification
  bool get localOffenderNotification => throw UnimplementedError();

  @override
  // TODO: implement lostPersonsNotification
  bool get lostPersonsNotification => throw UnimplementedError();

  @override
  // TODO: implement lostPetsNotification
  bool get lostPetsNotification => throw UnimplementedError();

  @override
  // TODO: implement majorBlazesNotification
  bool get majorBlazesNotification => throw UnimplementedError();

  @override
  // TODO: implement mapboxMap
  MapboxMap? get mapboxMap => throw UnimplementedError();

  @override
  // TODO: implement massRunningNotification
  bool get massRunningNotification => throw UnimplementedError();

  @override
  // TODO: implement minorFiresNotification
  bool get minorFiresNotification => throw UnimplementedError();

  @override
  // TODO: implement otherNotification
  bool get otherNotification => throw UnimplementedError();

  @override
  // TODO: implement physicalAltercationNotification
  bool get physicalAltercationNotification => throw UnimplementedError();

  @override
  // TODO: implement policeNotification
  bool get policeNotification => throw UnimplementedError();

  @override
  // TODO: implement promotionalNotification
  bool get promotionalNotification => throw UnimplementedError();

  @override
  // TODO: implement rallyNotification
  bool get rallyNotification => throw UnimplementedError();

  @override
  // TODO: implement selectedRange
  double get selectedRange => throw UnimplementedError();

  @override
  // TODO: implement serverWeatherNotification
  bool get serverWeatherNotification => throw UnimplementedError();

  @override
  // TODO: implement trafficNotification
  bool get trafficNotification => throw UnimplementedError();

  @override
  // TODO: implement transportNotification
  bool get transportNotification => throw UnimplementedError();

  @override
  // TODO: implement unknownEventNotification
  bool get unknownEventNotification => throw UnimplementedError();

}