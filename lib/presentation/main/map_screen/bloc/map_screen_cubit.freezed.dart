// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'map_screen_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MapScreenState {
  PointAnnotationManager? get pointAnnotationManager;
  PointAnnotation? get pointAnnotation;
  double get iconSize;
  CircleAnnotationManager? get circleAnnotationManager;
  MapboxMap? get mapboxMap;
  int get selectedIndex;
  int get eventCounts;
  bool get is3DEnabled;
  bool get isScrolling;
  bool get shouldCallApi;
  String get profilePic;
  Map<String, dynamic> get focusedMarker;
  Map<String, dynamic> get annotationPostIdMap;
  Map<String, dynamic> get markerPositions;
  String get currentCity;
  Timer? get debounceTimer;
  CameraOptions? get camera;
  Point? get topLeft;
  Point? get topRight;
  Point? get bottomLeft;
  Point? get bottomRight;
  List<SelectedAreaEventPostData>? get selectedAreaEventPostData;
  List<SelectedAreaEventPostData>? get selectedAreaRescuePostData;
  List<SelectedAreaEventPostData>? get selectedAreaGeneralPostData;
  int get rescueEventCounts;
  int get generalEventCounts;
  bool get isLoading;

  /// Create a copy of MapScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MapScreenStateCopyWith<MapScreenState> get copyWith =>
      _$MapScreenStateCopyWithImpl<MapScreenState>(
          this as MapScreenState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MapScreenState &&
            (identical(other.pointAnnotationManager, pointAnnotationManager) ||
                other.pointAnnotationManager == pointAnnotationManager) &&
            (identical(other.pointAnnotation, pointAnnotation) ||
                other.pointAnnotation == pointAnnotation) &&
            (identical(other.iconSize, iconSize) ||
                other.iconSize == iconSize) &&
            (identical(
                    other.circleAnnotationManager, circleAnnotationManager) ||
                other.circleAnnotationManager == circleAnnotationManager) &&
            (identical(other.mapboxMap, mapboxMap) ||
                other.mapboxMap == mapboxMap) &&
            (identical(other.selectedIndex, selectedIndex) ||
                other.selectedIndex == selectedIndex) &&
            (identical(other.eventCounts, eventCounts) ||
                other.eventCounts == eventCounts) &&
            (identical(other.is3DEnabled, is3DEnabled) ||
                other.is3DEnabled == is3DEnabled) &&
            (identical(other.isScrolling, isScrolling) ||
                other.isScrolling == isScrolling) &&
            (identical(other.shouldCallApi, shouldCallApi) ||
                other.shouldCallApi == shouldCallApi) &&
            (identical(other.profilePic, profilePic) ||
                other.profilePic == profilePic) &&
            const DeepCollectionEquality()
                .equals(other.focusedMarker, focusedMarker) &&
            const DeepCollectionEquality()
                .equals(other.annotationPostIdMap, annotationPostIdMap) &&
            const DeepCollectionEquality()
                .equals(other.markerPositions, markerPositions) &&
            (identical(other.currentCity, currentCity) ||
                other.currentCity == currentCity) &&
            (identical(other.debounceTimer, debounceTimer) ||
                other.debounceTimer == debounceTimer) &&
            (identical(other.camera, camera) || other.camera == camera) &&
            (identical(other.topLeft, topLeft) || other.topLeft == topLeft) &&
            (identical(other.topRight, topRight) ||
                other.topRight == topRight) &&
            (identical(other.bottomLeft, bottomLeft) ||
                other.bottomLeft == bottomLeft) &&
            (identical(other.bottomRight, bottomRight) ||
                other.bottomRight == bottomRight) &&
            const DeepCollectionEquality().equals(
                other.selectedAreaEventPostData, selectedAreaEventPostData) &&
            const DeepCollectionEquality().equals(
                other.selectedAreaRescuePostData, selectedAreaRescuePostData) &&
            const DeepCollectionEquality().equals(
                other.selectedAreaGeneralPostData,
                selectedAreaGeneralPostData) &&
            (identical(other.rescueEventCounts, rescueEventCounts) ||
                other.rescueEventCounts == rescueEventCounts) &&
            (identical(other.generalEventCounts, generalEventCounts) ||
                other.generalEventCounts == generalEventCounts) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        pointAnnotationManager,
        pointAnnotation,
        iconSize,
        circleAnnotationManager,
        mapboxMap,
        selectedIndex,
        eventCounts,
        is3DEnabled,
        isScrolling,
        shouldCallApi,
        profilePic,
        const DeepCollectionEquality().hash(focusedMarker),
        const DeepCollectionEquality().hash(annotationPostIdMap),
        const DeepCollectionEquality().hash(markerPositions),
        currentCity,
        debounceTimer,
        camera,
        topLeft,
        topRight,
        bottomLeft,
        bottomRight,
        const DeepCollectionEquality().hash(selectedAreaEventPostData),
        const DeepCollectionEquality().hash(selectedAreaRescuePostData),
        const DeepCollectionEquality().hash(selectedAreaGeneralPostData),
        rescueEventCounts,
        generalEventCounts,
        isLoading
      ]);

  @override
  String toString() {
    return 'MapScreenState(pointAnnotationManager: $pointAnnotationManager, pointAnnotation: $pointAnnotation, iconSize: $iconSize, circleAnnotationManager: $circleAnnotationManager, mapboxMap: $mapboxMap, selectedIndex: $selectedIndex, eventCounts: $eventCounts, is3DEnabled: $is3DEnabled, isScrolling: $isScrolling, shouldCallApi: $shouldCallApi, profilePic: $profilePic, focusedMarker: $focusedMarker, annotationPostIdMap: $annotationPostIdMap, markerPositions: $markerPositions, currentCity: $currentCity, debounceTimer: $debounceTimer, camera: $camera, topLeft: $topLeft, topRight: $topRight, bottomLeft: $bottomLeft, bottomRight: $bottomRight, selectedAreaEventPostData: $selectedAreaEventPostData, selectedAreaRescuePostData: $selectedAreaRescuePostData, selectedAreaGeneralPostData: $selectedAreaGeneralPostData, rescueEventCounts: $rescueEventCounts, generalEventCounts: $generalEventCounts, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class $MapScreenStateCopyWith<$Res> {
  factory $MapScreenStateCopyWith(
          MapScreenState value, $Res Function(MapScreenState) _then) =
      _$MapScreenStateCopyWithImpl;
  @useResult
  $Res call(
      {PointAnnotationManager? pointAnnotationManager,
      PointAnnotation? pointAnnotation,
      double iconSize,
      CircleAnnotationManager? circleAnnotationManager,
      MapboxMap? mapboxMap,
      int selectedIndex,
      int eventCounts,
      bool is3DEnabled,
      bool isScrolling,
      bool shouldCallApi,
      String profilePic,
      Map<String, dynamic> focusedMarker,
      Map<String, dynamic> annotationPostIdMap,
      Map<String, dynamic> markerPositions,
      String currentCity,
      Timer? debounceTimer,
      CameraOptions? camera,
      Point? topLeft,
      Point? topRight,
      Point? bottomLeft,
      Point? bottomRight,
      List<SelectedAreaEventPostData>? selectedAreaEventPostData,
      List<SelectedAreaEventPostData>? selectedAreaRescuePostData,
      List<SelectedAreaEventPostData>? selectedAreaGeneralPostData,
      int rescueEventCounts,
      int generalEventCounts,
      bool isLoading});
}

/// @nodoc
class _$MapScreenStateCopyWithImpl<$Res>
    implements $MapScreenStateCopyWith<$Res> {
  _$MapScreenStateCopyWithImpl(this._self, this._then);

  final MapScreenState _self;
  final $Res Function(MapScreenState) _then;

  /// Create a copy of MapScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pointAnnotationManager = freezed,
    Object? pointAnnotation = freezed,
    Object? iconSize = null,
    Object? circleAnnotationManager = freezed,
    Object? mapboxMap = freezed,
    Object? selectedIndex = null,
    Object? eventCounts = null,
    Object? is3DEnabled = null,
    Object? isScrolling = null,
    Object? shouldCallApi = null,
    Object? profilePic = null,
    Object? focusedMarker = null,
    Object? annotationPostIdMap = null,
    Object? markerPositions = null,
    Object? currentCity = null,
    Object? debounceTimer = freezed,
    Object? camera = freezed,
    Object? topLeft = freezed,
    Object? topRight = freezed,
    Object? bottomLeft = freezed,
    Object? bottomRight = freezed,
    Object? selectedAreaEventPostData = freezed,
    Object? selectedAreaRescuePostData = freezed,
    Object? selectedAreaGeneralPostData = freezed,
    Object? rescueEventCounts = null,
    Object? generalEventCounts = null,
    Object? isLoading = null,
  }) {
    return _then(_self.copyWith(
      pointAnnotationManager: freezed == pointAnnotationManager
          ? _self.pointAnnotationManager
          : pointAnnotationManager // ignore: cast_nullable_to_non_nullable
              as PointAnnotationManager?,
      pointAnnotation: freezed == pointAnnotation
          ? _self.pointAnnotation
          : pointAnnotation // ignore: cast_nullable_to_non_nullable
              as PointAnnotation?,
      iconSize: null == iconSize
          ? _self.iconSize
          : iconSize // ignore: cast_nullable_to_non_nullable
              as double,
      circleAnnotationManager: freezed == circleAnnotationManager
          ? _self.circleAnnotationManager
          : circleAnnotationManager // ignore: cast_nullable_to_non_nullable
              as CircleAnnotationManager?,
      mapboxMap: freezed == mapboxMap
          ? _self.mapboxMap
          : mapboxMap // ignore: cast_nullable_to_non_nullable
              as MapboxMap?,
      selectedIndex: null == selectedIndex
          ? _self.selectedIndex
          : selectedIndex // ignore: cast_nullable_to_non_nullable
              as int,
      eventCounts: null == eventCounts
          ? _self.eventCounts
          : eventCounts // ignore: cast_nullable_to_non_nullable
              as int,
      is3DEnabled: null == is3DEnabled
          ? _self.is3DEnabled
          : is3DEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isScrolling: null == isScrolling
          ? _self.isScrolling
          : isScrolling // ignore: cast_nullable_to_non_nullable
              as bool,
      shouldCallApi: null == shouldCallApi
          ? _self.shouldCallApi
          : shouldCallApi // ignore: cast_nullable_to_non_nullable
              as bool,
      profilePic: null == profilePic
          ? _self.profilePic
          : profilePic // ignore: cast_nullable_to_non_nullable
              as String,
      focusedMarker: null == focusedMarker
          ? _self.focusedMarker
          : focusedMarker // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      annotationPostIdMap: null == annotationPostIdMap
          ? _self.annotationPostIdMap
          : annotationPostIdMap // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      markerPositions: null == markerPositions
          ? _self.markerPositions
          : markerPositions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      currentCity: null == currentCity
          ? _self.currentCity
          : currentCity // ignore: cast_nullable_to_non_nullable
              as String,
      debounceTimer: freezed == debounceTimer
          ? _self.debounceTimer
          : debounceTimer // ignore: cast_nullable_to_non_nullable
              as Timer?,
      camera: freezed == camera
          ? _self.camera
          : camera // ignore: cast_nullable_to_non_nullable
              as CameraOptions?,
      topLeft: freezed == topLeft
          ? _self.topLeft
          : topLeft // ignore: cast_nullable_to_non_nullable
              as Point?,
      topRight: freezed == topRight
          ? _self.topRight
          : topRight // ignore: cast_nullable_to_non_nullable
              as Point?,
      bottomLeft: freezed == bottomLeft
          ? _self.bottomLeft
          : bottomLeft // ignore: cast_nullable_to_non_nullable
              as Point?,
      bottomRight: freezed == bottomRight
          ? _self.bottomRight
          : bottomRight // ignore: cast_nullable_to_non_nullable
              as Point?,
      selectedAreaEventPostData: freezed == selectedAreaEventPostData
          ? _self.selectedAreaEventPostData
          : selectedAreaEventPostData // ignore: cast_nullable_to_non_nullable
              as List<SelectedAreaEventPostData>?,
      selectedAreaRescuePostData: freezed == selectedAreaRescuePostData
          ? _self.selectedAreaRescuePostData
          : selectedAreaRescuePostData // ignore: cast_nullable_to_non_nullable
              as List<SelectedAreaEventPostData>?,
      selectedAreaGeneralPostData: freezed == selectedAreaGeneralPostData
          ? _self.selectedAreaGeneralPostData
          : selectedAreaGeneralPostData // ignore: cast_nullable_to_non_nullable
              as List<SelectedAreaEventPostData>?,
      rescueEventCounts: null == rescueEventCounts
          ? _self.rescueEventCounts
          : rescueEventCounts // ignore: cast_nullable_to_non_nullable
              as int,
      generalEventCounts: null == generalEventCounts
          ? _self.generalEventCounts
          : generalEventCounts // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _Initial extends MapScreenState {
  const _Initial(
      {this.pointAnnotationManager,
      this.pointAnnotation,
      this.iconSize = 0.0,
      this.circleAnnotationManager,
      this.mapboxMap,
      this.selectedIndex = 0,
      this.eventCounts = 0,
      this.is3DEnabled = false,
      this.isScrolling = false,
      this.shouldCallApi = true,
      this.profilePic = '',
      final Map<String, dynamic> focusedMarker = const {},
      final Map<String, dynamic> annotationPostIdMap = const {},
      final Map<String, dynamic> markerPositions = const {},
      this.currentCity = 'AWAAZ',
      this.debounceTimer,
      this.camera,
      this.topLeft,
      this.topRight,
      this.bottomLeft,
      this.bottomRight,
      final List<SelectedAreaEventPostData>? selectedAreaEventPostData,
      final List<SelectedAreaEventPostData>? selectedAreaRescuePostData,
      final List<SelectedAreaEventPostData>? selectedAreaGeneralPostData,
      this.rescueEventCounts = 0,
      this.generalEventCounts = 0,
      this.isLoading = false})
      : _focusedMarker = focusedMarker,
        _annotationPostIdMap = annotationPostIdMap,
        _markerPositions = markerPositions,
        _selectedAreaEventPostData = selectedAreaEventPostData,
        _selectedAreaRescuePostData = selectedAreaRescuePostData,
        _selectedAreaGeneralPostData = selectedAreaGeneralPostData,
        super._();

  @override
  final PointAnnotationManager? pointAnnotationManager;
  @override
  final PointAnnotation? pointAnnotation;
  @override
  @JsonKey()
  final double iconSize;
  @override
  final CircleAnnotationManager? circleAnnotationManager;
  @override
  final MapboxMap? mapboxMap;
  @override
  @JsonKey()
  final int selectedIndex;
  @override
  @JsonKey()
  final int eventCounts;
  @override
  @JsonKey()
  final bool is3DEnabled;
  @override
  @JsonKey()
  final bool isScrolling;
  @override
  @JsonKey()
  final bool shouldCallApi;
  @override
  @JsonKey()
  final String profilePic;
  final Map<String, dynamic> _focusedMarker;
  @override
  @JsonKey()
  Map<String, dynamic> get focusedMarker {
    if (_focusedMarker is EqualUnmodifiableMapView) return _focusedMarker;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_focusedMarker);
  }

  final Map<String, dynamic> _annotationPostIdMap;
  @override
  @JsonKey()
  Map<String, dynamic> get annotationPostIdMap {
    if (_annotationPostIdMap is EqualUnmodifiableMapView)
      return _annotationPostIdMap;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_annotationPostIdMap);
  }

  final Map<String, dynamic> _markerPositions;
  @override
  @JsonKey()
  Map<String, dynamic> get markerPositions {
    if (_markerPositions is EqualUnmodifiableMapView) return _markerPositions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_markerPositions);
  }

  @override
  @JsonKey()
  final String currentCity;
  @override
  final Timer? debounceTimer;
  @override
  final CameraOptions? camera;
  @override
  final Point? topLeft;
  @override
  final Point? topRight;
  @override
  final Point? bottomLeft;
  @override
  final Point? bottomRight;
  final List<SelectedAreaEventPostData>? _selectedAreaEventPostData;
  @override
  List<SelectedAreaEventPostData>? get selectedAreaEventPostData {
    final value = _selectedAreaEventPostData;
    if (value == null) return null;
    if (_selectedAreaEventPostData is EqualUnmodifiableListView)
      return _selectedAreaEventPostData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SelectedAreaEventPostData>? _selectedAreaRescuePostData;
  @override
  List<SelectedAreaEventPostData>? get selectedAreaRescuePostData {
    final value = _selectedAreaRescuePostData;
    if (value == null) return null;
    if (_selectedAreaRescuePostData is EqualUnmodifiableListView)
      return _selectedAreaRescuePostData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SelectedAreaEventPostData>? _selectedAreaGeneralPostData;
  @override
  List<SelectedAreaEventPostData>? get selectedAreaGeneralPostData {
    final value = _selectedAreaGeneralPostData;
    if (value == null) return null;
    if (_selectedAreaGeneralPostData is EqualUnmodifiableListView)
      return _selectedAreaGeneralPostData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey()
  final int rescueEventCounts;
  @override
  @JsonKey()
  final int generalEventCounts;
  @override
  @JsonKey()
  final bool isLoading;

  /// Create a copy of MapScreenState
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
            (identical(other.pointAnnotationManager, pointAnnotationManager) ||
                other.pointAnnotationManager == pointAnnotationManager) &&
            (identical(other.pointAnnotation, pointAnnotation) ||
                other.pointAnnotation == pointAnnotation) &&
            (identical(other.iconSize, iconSize) ||
                other.iconSize == iconSize) &&
            (identical(
                    other.circleAnnotationManager, circleAnnotationManager) ||
                other.circleAnnotationManager == circleAnnotationManager) &&
            (identical(other.mapboxMap, mapboxMap) ||
                other.mapboxMap == mapboxMap) &&
            (identical(other.selectedIndex, selectedIndex) ||
                other.selectedIndex == selectedIndex) &&
            (identical(other.eventCounts, eventCounts) ||
                other.eventCounts == eventCounts) &&
            (identical(other.is3DEnabled, is3DEnabled) ||
                other.is3DEnabled == is3DEnabled) &&
            (identical(other.isScrolling, isScrolling) ||
                other.isScrolling == isScrolling) &&
            (identical(other.shouldCallApi, shouldCallApi) ||
                other.shouldCallApi == shouldCallApi) &&
            (identical(other.profilePic, profilePic) ||
                other.profilePic == profilePic) &&
            const DeepCollectionEquality()
                .equals(other._focusedMarker, _focusedMarker) &&
            const DeepCollectionEquality()
                .equals(other._annotationPostIdMap, _annotationPostIdMap) &&
            const DeepCollectionEquality()
                .equals(other._markerPositions, _markerPositions) &&
            (identical(other.currentCity, currentCity) ||
                other.currentCity == currentCity) &&
            (identical(other.debounceTimer, debounceTimer) ||
                other.debounceTimer == debounceTimer) &&
            (identical(other.camera, camera) || other.camera == camera) &&
            (identical(other.topLeft, topLeft) || other.topLeft == topLeft) &&
            (identical(other.topRight, topRight) ||
                other.topRight == topRight) &&
            (identical(other.bottomLeft, bottomLeft) ||
                other.bottomLeft == bottomLeft) &&
            (identical(other.bottomRight, bottomRight) ||
                other.bottomRight == bottomRight) &&
            const DeepCollectionEquality().equals(
                other._selectedAreaEventPostData, _selectedAreaEventPostData) &&
            const DeepCollectionEquality().equals(
                other._selectedAreaRescuePostData,
                _selectedAreaRescuePostData) &&
            const DeepCollectionEquality().equals(
                other._selectedAreaGeneralPostData,
                _selectedAreaGeneralPostData) &&
            (identical(other.rescueEventCounts, rescueEventCounts) ||
                other.rescueEventCounts == rescueEventCounts) &&
            (identical(other.generalEventCounts, generalEventCounts) ||
                other.generalEventCounts == generalEventCounts) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        pointAnnotationManager,
        pointAnnotation,
        iconSize,
        circleAnnotationManager,
        mapboxMap,
        selectedIndex,
        eventCounts,
        is3DEnabled,
        isScrolling,
        shouldCallApi,
        profilePic,
        const DeepCollectionEquality().hash(_focusedMarker),
        const DeepCollectionEquality().hash(_annotationPostIdMap),
        const DeepCollectionEquality().hash(_markerPositions),
        currentCity,
        debounceTimer,
        camera,
        topLeft,
        topRight,
        bottomLeft,
        bottomRight,
        const DeepCollectionEquality().hash(_selectedAreaEventPostData),
        const DeepCollectionEquality().hash(_selectedAreaRescuePostData),
        const DeepCollectionEquality().hash(_selectedAreaGeneralPostData),
        rescueEventCounts,
        generalEventCounts,
        isLoading
      ]);

  @override
  String toString() {
    return 'MapScreenState(pointAnnotationManager: $pointAnnotationManager, pointAnnotation: $pointAnnotation, iconSize: $iconSize, circleAnnotationManager: $circleAnnotationManager, mapboxMap: $mapboxMap, selectedIndex: $selectedIndex, eventCounts: $eventCounts, is3DEnabled: $is3DEnabled, isScrolling: $isScrolling, shouldCallApi: $shouldCallApi, profilePic: $profilePic, focusedMarker: $focusedMarker, annotationPostIdMap: $annotationPostIdMap, markerPositions: $markerPositions, currentCity: $currentCity, debounceTimer: $debounceTimer, camera: $camera, topLeft: $topLeft, topRight: $topRight, bottomLeft: $bottomLeft, bottomRight: $bottomRight, selectedAreaEventPostData: $selectedAreaEventPostData, selectedAreaRescuePostData: $selectedAreaRescuePostData, selectedAreaGeneralPostData: $selectedAreaGeneralPostData, rescueEventCounts: $rescueEventCounts, generalEventCounts: $generalEventCounts, isLoading: $isLoading)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $MapScreenStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {PointAnnotationManager? pointAnnotationManager,
      PointAnnotation? pointAnnotation,
      double iconSize,
      CircleAnnotationManager? circleAnnotationManager,
      MapboxMap? mapboxMap,
      int selectedIndex,
      int eventCounts,
      bool is3DEnabled,
      bool isScrolling,
      bool shouldCallApi,
      String profilePic,
      Map<String, dynamic> focusedMarker,
      Map<String, dynamic> annotationPostIdMap,
      Map<String, dynamic> markerPositions,
      String currentCity,
      Timer? debounceTimer,
      CameraOptions? camera,
      Point? topLeft,
      Point? topRight,
      Point? bottomLeft,
      Point? bottomRight,
      List<SelectedAreaEventPostData>? selectedAreaEventPostData,
      List<SelectedAreaEventPostData>? selectedAreaRescuePostData,
      List<SelectedAreaEventPostData>? selectedAreaGeneralPostData,
      int rescueEventCounts,
      int generalEventCounts,
      bool isLoading});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of MapScreenState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? pointAnnotationManager = freezed,
    Object? pointAnnotation = freezed,
    Object? iconSize = null,
    Object? circleAnnotationManager = freezed,
    Object? mapboxMap = freezed,
    Object? selectedIndex = null,
    Object? eventCounts = null,
    Object? is3DEnabled = null,
    Object? isScrolling = null,
    Object? shouldCallApi = null,
    Object? profilePic = null,
    Object? focusedMarker = null,
    Object? annotationPostIdMap = null,
    Object? markerPositions = null,
    Object? currentCity = null,
    Object? debounceTimer = freezed,
    Object? camera = freezed,
    Object? topLeft = freezed,
    Object? topRight = freezed,
    Object? bottomLeft = freezed,
    Object? bottomRight = freezed,
    Object? selectedAreaEventPostData = freezed,
    Object? selectedAreaRescuePostData = freezed,
    Object? selectedAreaGeneralPostData = freezed,
    Object? rescueEventCounts = null,
    Object? generalEventCounts = null,
    Object? isLoading = null,
  }) {
    return _then(_Initial(
      pointAnnotationManager: freezed == pointAnnotationManager
          ? _self.pointAnnotationManager
          : pointAnnotationManager // ignore: cast_nullable_to_non_nullable
              as PointAnnotationManager?,
      pointAnnotation: freezed == pointAnnotation
          ? _self.pointAnnotation
          : pointAnnotation // ignore: cast_nullable_to_non_nullable
              as PointAnnotation?,
      iconSize: null == iconSize
          ? _self.iconSize
          : iconSize // ignore: cast_nullable_to_non_nullable
              as double,
      circleAnnotationManager: freezed == circleAnnotationManager
          ? _self.circleAnnotationManager
          : circleAnnotationManager // ignore: cast_nullable_to_non_nullable
              as CircleAnnotationManager?,
      mapboxMap: freezed == mapboxMap
          ? _self.mapboxMap
          : mapboxMap // ignore: cast_nullable_to_non_nullable
              as MapboxMap?,
      selectedIndex: null == selectedIndex
          ? _self.selectedIndex
          : selectedIndex // ignore: cast_nullable_to_non_nullable
              as int,
      eventCounts: null == eventCounts
          ? _self.eventCounts
          : eventCounts // ignore: cast_nullable_to_non_nullable
              as int,
      is3DEnabled: null == is3DEnabled
          ? _self.is3DEnabled
          : is3DEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isScrolling: null == isScrolling
          ? _self.isScrolling
          : isScrolling // ignore: cast_nullable_to_non_nullable
              as bool,
      shouldCallApi: null == shouldCallApi
          ? _self.shouldCallApi
          : shouldCallApi // ignore: cast_nullable_to_non_nullable
              as bool,
      profilePic: null == profilePic
          ? _self.profilePic
          : profilePic // ignore: cast_nullable_to_non_nullable
              as String,
      focusedMarker: null == focusedMarker
          ? _self._focusedMarker
          : focusedMarker // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      annotationPostIdMap: null == annotationPostIdMap
          ? _self._annotationPostIdMap
          : annotationPostIdMap // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      markerPositions: null == markerPositions
          ? _self._markerPositions
          : markerPositions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      currentCity: null == currentCity
          ? _self.currentCity
          : currentCity // ignore: cast_nullable_to_non_nullable
              as String,
      debounceTimer: freezed == debounceTimer
          ? _self.debounceTimer
          : debounceTimer // ignore: cast_nullable_to_non_nullable
              as Timer?,
      camera: freezed == camera
          ? _self.camera
          : camera // ignore: cast_nullable_to_non_nullable
              as CameraOptions?,
      topLeft: freezed == topLeft
          ? _self.topLeft
          : topLeft // ignore: cast_nullable_to_non_nullable
              as Point?,
      topRight: freezed == topRight
          ? _self.topRight
          : topRight // ignore: cast_nullable_to_non_nullable
              as Point?,
      bottomLeft: freezed == bottomLeft
          ? _self.bottomLeft
          : bottomLeft // ignore: cast_nullable_to_non_nullable
              as Point?,
      bottomRight: freezed == bottomRight
          ? _self.bottomRight
          : bottomRight // ignore: cast_nullable_to_non_nullable
              as Point?,
      selectedAreaEventPostData: freezed == selectedAreaEventPostData
          ? _self._selectedAreaEventPostData
          : selectedAreaEventPostData // ignore: cast_nullable_to_non_nullable
              as List<SelectedAreaEventPostData>?,
      selectedAreaRescuePostData: freezed == selectedAreaRescuePostData
          ? _self._selectedAreaRescuePostData
          : selectedAreaRescuePostData // ignore: cast_nullable_to_non_nullable
              as List<SelectedAreaEventPostData>?,
      selectedAreaGeneralPostData: freezed == selectedAreaGeneralPostData
          ? _self._selectedAreaGeneralPostData
          : selectedAreaGeneralPostData // ignore: cast_nullable_to_non_nullable
              as List<SelectedAreaEventPostData>?,
      rescueEventCounts: null == rescueEventCounts
          ? _self.rescueEventCounts
          : rescueEventCounts // ignore: cast_nullable_to_non_nullable
              as int,
      generalEventCounts: null == generalEventCounts
          ? _self.generalEventCounts
          : generalEventCounts // ignore: cast_nullable_to_non_nullable
              as int,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
