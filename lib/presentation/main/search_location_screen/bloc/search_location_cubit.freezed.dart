// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_location_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchLocationState {
  MapboxMap? get mapboxMap;
  PointAnnotationManager? get pointAnnotationManager;
  PointAnnotation? get selectedMarker;
  CameraOptions? get camera;

  /// Create a copy of SearchLocationState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchLocationStateCopyWith<SearchLocationState> get copyWith =>
      _$SearchLocationStateCopyWithImpl<SearchLocationState>(
          this as SearchLocationState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchLocationState &&
            (identical(other.mapboxMap, mapboxMap) ||
                other.mapboxMap == mapboxMap) &&
            (identical(other.pointAnnotationManager, pointAnnotationManager) ||
                other.pointAnnotationManager == pointAnnotationManager) &&
            (identical(other.selectedMarker, selectedMarker) ||
                other.selectedMarker == selectedMarker) &&
            (identical(other.camera, camera) || other.camera == camera));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, mapboxMap, pointAnnotationManager, selectedMarker, camera);

  @override
  String toString() {
    return 'SearchLocationState(mapboxMap: $mapboxMap, pointAnnotationManager: $pointAnnotationManager, selectedMarker: $selectedMarker, camera: $camera)';
  }
}

/// @nodoc
abstract mixin class $SearchLocationStateCopyWith<$Res> {
  factory $SearchLocationStateCopyWith(
          SearchLocationState value, $Res Function(SearchLocationState) _then) =
      _$SearchLocationStateCopyWithImpl;
  @useResult
  $Res call(
      {MapboxMap? mapboxMap,
      PointAnnotationManager? pointAnnotationManager,
      PointAnnotation? selectedMarker,
      CameraOptions? camera});
}

/// @nodoc
class _$SearchLocationStateCopyWithImpl<$Res>
    implements $SearchLocationStateCopyWith<$Res> {
  _$SearchLocationStateCopyWithImpl(this._self, this._then);

  final SearchLocationState _self;
  final $Res Function(SearchLocationState) _then;

  /// Create a copy of SearchLocationState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapboxMap = freezed,
    Object? pointAnnotationManager = freezed,
    Object? selectedMarker = freezed,
    Object? camera = freezed,
  }) {
    return _then(_self.copyWith(
      mapboxMap: freezed == mapboxMap
          ? _self.mapboxMap
          : mapboxMap // ignore: cast_nullable_to_non_nullable
              as MapboxMap?,
      pointAnnotationManager: freezed == pointAnnotationManager
          ? _self.pointAnnotationManager
          : pointAnnotationManager // ignore: cast_nullable_to_non_nullable
              as PointAnnotationManager?,
      selectedMarker: freezed == selectedMarker
          ? _self.selectedMarker
          : selectedMarker // ignore: cast_nullable_to_non_nullable
              as PointAnnotation?,
      camera: freezed == camera
          ? _self.camera
          : camera // ignore: cast_nullable_to_non_nullable
              as CameraOptions?,
    ));
  }
}

/// @nodoc

class _Initial extends SearchLocationState {
  const _Initial(
      {this.mapboxMap = null,
      this.pointAnnotationManager = null,
      this.selectedMarker = null,
      this.camera = null})
      : super._();

  @override
  @JsonKey()
  final MapboxMap? mapboxMap;
  @override
  @JsonKey()
  final PointAnnotationManager? pointAnnotationManager;
  @override
  @JsonKey()
  final PointAnnotation? selectedMarker;
  @override
  @JsonKey()
  final CameraOptions? camera;

  /// Create a copy of SearchLocationState
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
            (identical(other.mapboxMap, mapboxMap) ||
                other.mapboxMap == mapboxMap) &&
            (identical(other.pointAnnotationManager, pointAnnotationManager) ||
                other.pointAnnotationManager == pointAnnotationManager) &&
            (identical(other.selectedMarker, selectedMarker) ||
                other.selectedMarker == selectedMarker) &&
            (identical(other.camera, camera) || other.camera == camera));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, mapboxMap, pointAnnotationManager, selectedMarker, camera);

  @override
  String toString() {
    return 'SearchLocationState(mapboxMap: $mapboxMap, pointAnnotationManager: $pointAnnotationManager, selectedMarker: $selectedMarker, camera: $camera)';
  }
}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res>
    implements $SearchLocationStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) =
      __$InitialCopyWithImpl;
  @override
  @useResult
  $Res call(
      {MapboxMap? mapboxMap,
      PointAnnotationManager? pointAnnotationManager,
      PointAnnotation? selectedMarker,
      CameraOptions? camera});
}

/// @nodoc
class __$InitialCopyWithImpl<$Res> implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

  /// Create a copy of SearchLocationState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? mapboxMap = freezed,
    Object? pointAnnotationManager = freezed,
    Object? selectedMarker = freezed,
    Object? camera = freezed,
  }) {
    return _then(_Initial(
      mapboxMap: freezed == mapboxMap
          ? _self.mapboxMap
          : mapboxMap // ignore: cast_nullable_to_non_nullable
              as MapboxMap?,
      pointAnnotationManager: freezed == pointAnnotationManager
          ? _self.pointAnnotationManager
          : pointAnnotationManager // ignore: cast_nullable_to_non_nullable
              as PointAnnotationManager?,
      selectedMarker: freezed == selectedMarker
          ? _self.selectedMarker
          : selectedMarker // ignore: cast_nullable_to_non_nullable
              as PointAnnotation?,
      camera: freezed == camera
          ? _self.camera
          : camera // ignore: cast_nullable_to_non_nullable
              as CameraOptions?,
    ));
  }
}

// dart format on
