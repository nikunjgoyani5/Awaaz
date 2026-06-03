// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_settings_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationSettingsState {
  double get selectedRange;
  bool get isLoading;
  bool get dangerousNotification;
  bool get trafficNotification;
  bool get firearmIncidentNotification;
  bool get physicalAltercationNotification;
  bool get minorFiresNotification;
  bool get majorBlazesNotification;
  bool get lostPersonsNotification;
  bool get lostPetsNotification;
  bool get communityHealthNotification;
  bool get serverWeatherNotification;
  bool get localOffenderNotification;
  bool get transportNotification;
  bool get promotionalNotification;
  bool get policeNotification;
  bool get rallyNotification;
  bool get massRunningNotification;
  bool get goonsNotification;
  bool get unknownEventNotification;
  bool get otherNotification;
  MapboxMap? get mapboxMap;
  CameraOptions? get camera;

  /// Create a copy of NotificationSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationSettingsStateCopyWith<NotificationSettingsState> get copyWith =>
      _$NotificationSettingsStateCopyWithImpl<NotificationSettingsState>(
          this as NotificationSettingsState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationSettingsState &&
            (identical(other.selectedRange, selectedRange) ||
                other.selectedRange == selectedRange) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.dangerousNotification, dangerousNotification) ||
                other.dangerousNotification == dangerousNotification) &&
            (identical(other.trafficNotification, trafficNotification) ||
                other.trafficNotification == trafficNotification) &&
            (identical(other.firearmIncidentNotification, firearmIncidentNotification) ||
                other.firearmIncidentNotification ==
                    firearmIncidentNotification) &&
            (identical(other.physicalAltercationNotification, physicalAltercationNotification) ||
                other.physicalAltercationNotification ==
                    physicalAltercationNotification) &&
            (identical(other.minorFiresNotification, minorFiresNotification) ||
                other.minorFiresNotification == minorFiresNotification) &&
            (identical(other.majorBlazesNotification, majorBlazesNotification) ||
                other.majorBlazesNotification == majorBlazesNotification) &&
            (identical(other.lostPersonsNotification, lostPersonsNotification) ||
                other.lostPersonsNotification == lostPersonsNotification) &&
            (identical(other.lostPetsNotification, lostPetsNotification) ||
                other.lostPetsNotification == lostPetsNotification) &&
            (identical(other.communityHealthNotification, communityHealthNotification) ||
                other.communityHealthNotification ==
                    communityHealthNotification) &&
            (identical(other.serverWeatherNotification, serverWeatherNotification) ||
                other.serverWeatherNotification == serverWeatherNotification) &&
            (identical(other.localOffenderNotification, localOffenderNotification) ||
                other.localOffenderNotification == localOffenderNotification) &&
            (identical(other.transportNotification, transportNotification) ||
                other.transportNotification == transportNotification) &&
            (identical(other.promotionalNotification, promotionalNotification) ||
                other.promotionalNotification == promotionalNotification) &&
            (identical(other.policeNotification, policeNotification) ||
                other.policeNotification == policeNotification) &&
            (identical(other.rallyNotification, rallyNotification) ||
                other.rallyNotification == rallyNotification) &&
            (identical(other.massRunningNotification, massRunningNotification) ||
                other.massRunningNotification == massRunningNotification) &&
            (identical(other.goonsNotification, goonsNotification) ||
                other.goonsNotification == goonsNotification) &&
            (identical(other.unknownEventNotification, unknownEventNotification) ||
                other.unknownEventNotification == unknownEventNotification) &&
            (identical(other.otherNotification, otherNotification) ||
                other.otherNotification == otherNotification) &&
            (identical(other.mapboxMap, mapboxMap) ||
                other.mapboxMap == mapboxMap) &&
            (identical(other.camera, camera) || other.camera == camera));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        selectedRange,
        isLoading,
        dangerousNotification,
        trafficNotification,
        firearmIncidentNotification,
        physicalAltercationNotification,
        minorFiresNotification,
        majorBlazesNotification,
        lostPersonsNotification,
        lostPetsNotification,
        communityHealthNotification,
        serverWeatherNotification,
        localOffenderNotification,
        transportNotification,
        promotionalNotification,
        policeNotification,
        rallyNotification,
        massRunningNotification,
        goonsNotification,
        unknownEventNotification,
        otherNotification,
        mapboxMap,
        camera
      ]);

  @override
  String toString() {
    return 'NotificationSettingsState(selectedRange: $selectedRange, isLoading: $isLoading, dangerousNotification: $dangerousNotification, trafficNotification: $trafficNotification, firearmIncidentNotification: $firearmIncidentNotification, physicalAltercationNotification: $physicalAltercationNotification, minorFiresNotification: $minorFiresNotification, majorBlazesNotification: $majorBlazesNotification, lostPersonsNotification: $lostPersonsNotification, lostPetsNotification: $lostPetsNotification, communityHealthNotification: $communityHealthNotification, serverWeatherNotification: $serverWeatherNotification, localOffenderNotification: $localOffenderNotification, transportNotification: $transportNotification, promotionalNotification: $promotionalNotification, policeNotification: $policeNotification, rallyNotification: $rallyNotification, massRunningNotification: $massRunningNotification, goonsNotification: $goonsNotification, unknownEventNotification: $unknownEventNotification, otherNotification: $otherNotification, mapboxMap: $mapboxMap, camera: $camera)';
  }
}

/// @nodoc
abstract mixin class $NotificationSettingsStateCopyWith<$Res> {
  factory $NotificationSettingsStateCopyWith(NotificationSettingsState value,
          $Res Function(NotificationSettingsState) _then) =
      _$NotificationSettingsStateCopyWithImpl;
  @useResult
  $Res call(
      {double selectedRange,
      bool isLoading,
      bool dangerousNotification,
      bool trafficNotification,
      bool firearmIncidentNotification,
      bool physicalAltercationNotification,
      bool minorFiresNotification,
      bool majorBlazesNotification,
      bool lostPersonsNotification,
      bool lostPetsNotification,
      bool communityHealthNotification,
      bool serverWeatherNotification,
      bool localOffenderNotification,
      bool transportNotification,
      bool promotionalNotification,
      bool policeNotification,
      bool rallyNotification,
      bool massRunningNotification,
      bool goonsNotification,
      bool unknownEventNotification,
      bool otherNotification,
      MapboxMap? mapboxMap,
      CameraOptions? camera});
}

/// @nodoc
class _$NotificationSettingsStateCopyWithImpl<$Res>
    implements $NotificationSettingsStateCopyWith<$Res> {
  _$NotificationSettingsStateCopyWithImpl(this._self, this._then);

  final NotificationSettingsState _self;
  final $Res Function(NotificationSettingsState) _then;

  /// Create a copy of NotificationSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedRange = null,
    Object? isLoading = null,
    Object? dangerousNotification = null,
    Object? trafficNotification = null,
    Object? firearmIncidentNotification = null,
    Object? physicalAltercationNotification = null,
    Object? minorFiresNotification = null,
    Object? majorBlazesNotification = null,
    Object? lostPersonsNotification = null,
    Object? lostPetsNotification = null,
    Object? communityHealthNotification = null,
    Object? serverWeatherNotification = null,
    Object? localOffenderNotification = null,
    Object? transportNotification = null,
    Object? promotionalNotification = null,
    Object? policeNotification = null,
    Object? rallyNotification = null,
    Object? massRunningNotification = null,
    Object? goonsNotification = null,
    Object? unknownEventNotification = null,
    Object? otherNotification = null,
    Object? mapboxMap = freezed,
    Object? camera = freezed,
  }) {
    return _then(_self.copyWith(
      selectedRange: null == selectedRange
          ? _self.selectedRange
          : selectedRange // ignore: cast_nullable_to_non_nullable
              as double,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      dangerousNotification: null == dangerousNotification
          ? _self.dangerousNotification
          : dangerousNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      trafficNotification: null == trafficNotification
          ? _self.trafficNotification
          : trafficNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      firearmIncidentNotification: null == firearmIncidentNotification
          ? _self.firearmIncidentNotification
          : firearmIncidentNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      physicalAltercationNotification: null == physicalAltercationNotification
          ? _self.physicalAltercationNotification
          : physicalAltercationNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      minorFiresNotification: null == minorFiresNotification
          ? _self.minorFiresNotification
          : minorFiresNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      majorBlazesNotification: null == majorBlazesNotification
          ? _self.majorBlazesNotification
          : majorBlazesNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      lostPersonsNotification: null == lostPersonsNotification
          ? _self.lostPersonsNotification
          : lostPersonsNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      lostPetsNotification: null == lostPetsNotification
          ? _self.lostPetsNotification
          : lostPetsNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      communityHealthNotification: null == communityHealthNotification
          ? _self.communityHealthNotification
          : communityHealthNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      serverWeatherNotification: null == serverWeatherNotification
          ? _self.serverWeatherNotification
          : serverWeatherNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      localOffenderNotification: null == localOffenderNotification
          ? _self.localOffenderNotification
          : localOffenderNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      transportNotification: null == transportNotification
          ? _self.transportNotification
          : transportNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      promotionalNotification: null == promotionalNotification
          ? _self.promotionalNotification
          : promotionalNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      policeNotification: null == policeNotification
          ? _self.policeNotification
          : policeNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      rallyNotification: null == rallyNotification
          ? _self.rallyNotification
          : rallyNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      massRunningNotification: null == massRunningNotification
          ? _self.massRunningNotification
          : massRunningNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      goonsNotification: null == goonsNotification
          ? _self.goonsNotification
          : goonsNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      unknownEventNotification: null == unknownEventNotification
          ? _self.unknownEventNotification
          : unknownEventNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      otherNotification: null == otherNotification
          ? _self.otherNotification
          : otherNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      mapboxMap: freezed == mapboxMap
          ? _self.mapboxMap
          : mapboxMap // ignore: cast_nullable_to_non_nullable
              as MapboxMap?,
      camera: freezed == camera
          ? _self.camera
          : camera // ignore: cast_nullable_to_non_nullable
              as CameraOptions?,
    ));
  }
}

/// @nodoc

class _Initial extends NotificationSettingsState {
  const _Initial(
      {this.selectedRange = 0.0,
      this.isLoading = false,
      this.dangerousNotification = true,
      this.trafficNotification = true,
      this.firearmIncidentNotification = true,
      this.physicalAltercationNotification = true,
      this.minorFiresNotification = true,
      this.majorBlazesNotification = true,
      this.lostPersonsNotification = true,
      this.lostPetsNotification = true,
      this.communityHealthNotification = true,
      this.serverWeatherNotification = true,
      this.localOffenderNotification = true,
      this.transportNotification = true,
      this.promotionalNotification = true,
      this.policeNotification = true,
      this.rallyNotification = true,
      this.massRunningNotification = true,
      this.goonsNotification = true,
      this.unknownEventNotification = true,
      this.otherNotification = true,
      this.mapboxMap,
      this.camera})
      : super._();

  @override
  @JsonKey()
  final double selectedRange;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool dangerousNotification;
  @override
  @JsonKey()
  final bool trafficNotification;
  @override
  @JsonKey()
  final bool firearmIncidentNotification;
  @override
  @JsonKey()
  final bool physicalAltercationNotification;
  @override
  @JsonKey()
  final bool minorFiresNotification;
  @override
  @JsonKey()
  final bool majorBlazesNotification;
  @override
  @JsonKey()
  final bool lostPersonsNotification;
  @override
  @JsonKey()
  final bool lostPetsNotification;
  @override
  @JsonKey()
  final bool communityHealthNotification;
  @override
  @JsonKey()
  final bool serverWeatherNotification;
  @override
  @JsonKey()
  final bool localOffenderNotification;
  @override
  @JsonKey()
  final bool transportNotification;
  @override
  @JsonKey()
  final bool promotionalNotification;
  @override
  @JsonKey()
  final bool policeNotification;
  @override
  @JsonKey()
  final bool rallyNotification;
  @override
  @JsonKey()
  final bool massRunningNotification;
  @override
  @JsonKey()
  final bool goonsNotification;
  @override
  @JsonKey()
  final bool unknownEventNotification;
  @override
  @JsonKey()
  final bool otherNotification;
  @override
  final MapboxMap? mapboxMap;
  @override
  final CameraOptions? camera;

  /// Create a copy of NotificationSettingsState
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
            (identical(other.selectedRange, selectedRange) ||
                other.selectedRange == selectedRange) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.dangerousNotification, dangerousNotification) ||
                other.dangerousNotification == dangerousNotification) &&
            (identical(other.trafficNotification, trafficNotification) ||
                other.trafficNotification == trafficNotification) &&
            (identical(other.firearmIncidentNotification, firearmIncidentNotification) ||
                other.firearmIncidentNotification ==
                    firearmIncidentNotification) &&
            (identical(other.physicalAltercationNotification, physicalAltercationNotification) ||
                other.physicalAltercationNotification ==
                    physicalAltercationNotification) &&
            (identical(other.minorFiresNotification, minorFiresNotification) ||
                other.minorFiresNotification == minorFiresNotification) &&
            (identical(other.majorBlazesNotification, majorBlazesNotification) ||
                other.majorBlazesNotification == majorBlazesNotification) &&
            (identical(other.lostPersonsNotification, lostPersonsNotification) ||
                other.lostPersonsNotification == lostPersonsNotification) &&
            (identical(other.lostPetsNotification, lostPetsNotification) ||
                other.lostPetsNotification == lostPetsNotification) &&
            (identical(other.communityHealthNotification, communityHealthNotification) ||
                other.communityHealthNotification ==
                    communityHealthNotification) &&
            (identical(other.serverWeatherNotification, serverWeatherNotification) ||
                other.serverWeatherNotification == serverWeatherNotification) &&
            (identical(other.localOffenderNotification, localOffenderNotification) ||
                other.localOffenderNotification == localOffenderNotification) &&
            (identical(other.transportNotification, transportNotification) ||
                other.transportNotification == transportNotification) &&
            (identical(other.promotionalNotification, promotionalNotification) ||
                other.promotionalNotification == promotionalNotification) &&
            (identical(other.policeNotification, policeNotification) ||
                other.policeNotification == policeNotification) &&
            (identical(other.rallyNotification, rallyNotification) ||
                other.rallyNotification == rallyNotification) &&
            (identical(other.massRunningNotification, massRunningNotification) ||
                other.massRunningNotification == massRunningNotification) &&
            (identical(other.goonsNotification, goonsNotification) ||
                other.goonsNotification == goonsNotification) &&
            (identical(other.unknownEventNotification, unknownEventNotification) ||
                other.unknownEventNotification == unknownEventNotification) &&
            (identical(other.otherNotification, otherNotification) ||
                other.otherNotification == otherNotification) &&
            (identical(other.mapboxMap, mapboxMap) ||
                other.mapboxMap == mapboxMap) &&
            (identical(other.camera, camera) || other.camera == camera));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        selectedRange,
        isLoading,
        dangerousNotification,
        trafficNotification,
        firearmIncidentNotification,
        physicalAltercationNotification,
        minorFiresNotification,
        majorBlazesNotification,
        lostPersonsNotification,
        lostPetsNotification,
        communityHealthNotification,
        serverWeatherNotification,
        localOffenderNotification,
        transportNotification,
        promotionalNotification,
        policeNotification,
        rallyNotification,
        massRunningNotification,
        goonsNotification,
        unknownEventNotification,
        otherNotification,
        mapboxMap,
        camera
      ]);

  @override
  String toString() {
    return 'NotificationSettingsState(selectedRange: $selectedRange, isLoading: $isLoading, dangerousNotification: $dangerousNotification, trafficNotification: $trafficNotification, firearmIncidentNotification: $firearmIncidentNotification, physicalAltercationNotification: $physicalAltercationNotification, minorFiresNotification: $minorFiresNotification, majorBlazesNotification: $majorBlazesNotification, lostPersonsNotification: $lostPersonsNotification, lostPetsNotification: $lostPetsNotification, communityHealthNotification: $communityHealthNotification, serverWeatherNotification: $serverWeatherNotification, localOffenderNotification: $localOffenderNotification, transportNotification: $transportNotification, promotionalNotification: $promotionalNotification, policeNotification: $policeNotification, rallyNotification: $rallyNotification, massRunningNotification: $massRunningNotification, goonsNotification: $goonsNotification, unknownEventNotification: $unknownEventNotification, otherNotification: $otherNotification, mapboxMap: $mapboxMap, camera: $camera)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $NotificationSettingsStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {double selectedRange,
      bool isLoading,
      bool dangerousNotification,
      bool trafficNotification,
      bool firearmIncidentNotification,
      bool physicalAltercationNotification,
      bool minorFiresNotification,
      bool majorBlazesNotification,
      bool lostPersonsNotification,
      bool lostPetsNotification,
      bool communityHealthNotification,
      bool serverWeatherNotification,
      bool localOffenderNotification,
      bool transportNotification,
      bool promotionalNotification,
      bool policeNotification,
      bool rallyNotification,
      bool massRunningNotification,
      bool goonsNotification,
      bool unknownEventNotification,
      bool otherNotification,
      MapboxMap? mapboxMap,
      CameraOptions? camera});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of NotificationSettingsState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? selectedRange = null,
    Object? isLoading = null,
    Object? dangerousNotification = null,
    Object? trafficNotification = null,
    Object? firearmIncidentNotification = null,
    Object? physicalAltercationNotification = null,
    Object? minorFiresNotification = null,
    Object? majorBlazesNotification = null,
    Object? lostPersonsNotification = null,
    Object? lostPetsNotification = null,
    Object? communityHealthNotification = null,
    Object? serverWeatherNotification = null,
    Object? localOffenderNotification = null,
    Object? transportNotification = null,
    Object? promotionalNotification = null,
    Object? policeNotification = null,
    Object? rallyNotification = null,
    Object? massRunningNotification = null,
    Object? goonsNotification = null,
    Object? unknownEventNotification = null,
    Object? otherNotification = null,
    Object? mapboxMap = freezed,
    Object? camera = freezed,
  }) {
    return _then(_Initial(
      selectedRange: null == selectedRange
          ? _self.selectedRange
          : selectedRange // ignore: cast_nullable_to_non_nullable
              as double,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      dangerousNotification: null == dangerousNotification
          ? _self.dangerousNotification
          : dangerousNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      trafficNotification: null == trafficNotification
          ? _self.trafficNotification
          : trafficNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      firearmIncidentNotification: null == firearmIncidentNotification
          ? _self.firearmIncidentNotification
          : firearmIncidentNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      physicalAltercationNotification: null == physicalAltercationNotification
          ? _self.physicalAltercationNotification
          : physicalAltercationNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      minorFiresNotification: null == minorFiresNotification
          ? _self.minorFiresNotification
          : minorFiresNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      majorBlazesNotification: null == majorBlazesNotification
          ? _self.majorBlazesNotification
          : majorBlazesNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      lostPersonsNotification: null == lostPersonsNotification
          ? _self.lostPersonsNotification
          : lostPersonsNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      lostPetsNotification: null == lostPetsNotification
          ? _self.lostPetsNotification
          : lostPetsNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      communityHealthNotification: null == communityHealthNotification
          ? _self.communityHealthNotification
          : communityHealthNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      serverWeatherNotification: null == serverWeatherNotification
          ? _self.serverWeatherNotification
          : serverWeatherNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      localOffenderNotification: null == localOffenderNotification
          ? _self.localOffenderNotification
          : localOffenderNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      transportNotification: null == transportNotification
          ? _self.transportNotification
          : transportNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      promotionalNotification: null == promotionalNotification
          ? _self.promotionalNotification
          : promotionalNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      policeNotification: null == policeNotification
          ? _self.policeNotification
          : policeNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      rallyNotification: null == rallyNotification
          ? _self.rallyNotification
          : rallyNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      massRunningNotification: null == massRunningNotification
          ? _self.massRunningNotification
          : massRunningNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      goonsNotification: null == goonsNotification
          ? _self.goonsNotification
          : goonsNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      unknownEventNotification: null == unknownEventNotification
          ? _self.unknownEventNotification
          : unknownEventNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      otherNotification: null == otherNotification
          ? _self.otherNotification
          : otherNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      mapboxMap: freezed == mapboxMap
          ? _self.mapboxMap
          : mapboxMap // ignore: cast_nullable_to_non_nullable
              as MapboxMap?,
      camera: freezed == camera
          ? _self.camera
          : camera // ignore: cast_nullable_to_non_nullable
              as CameraOptions?,
    ));
  }
}

// dart format on
