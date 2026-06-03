part of 'search_location_cubit.dart';

@freezed
class SearchLocationState with _$SearchLocationState {
  const SearchLocationState._();
  const factory SearchLocationState({
    @Default(null) MapboxMap? mapboxMap,
    @Default(null) PointAnnotationManager? pointAnnotationManager,
    @Default(null) PointAnnotation? selectedMarker,
    @Default(null) CameraOptions? camera,
  }) = _Initial;

  @override
  // TODO: implement camera
  CameraOptions? get camera => throw UnimplementedError();

  @override
  // TODO: implement mapboxMap
  MapboxMap? get mapboxMap => throw UnimplementedError();

  @override
  // TODO: implement pointAnnotationManager
  PointAnnotationManager? get pointAnnotationManager => throw UnimplementedError();

  @override
  // TODO: implement selectedMarker
  PointAnnotation? get selectedMarker => throw UnimplementedError();

}