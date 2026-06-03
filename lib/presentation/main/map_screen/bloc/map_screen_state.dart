part of 'map_screen_cubit.dart';

@freezed
class MapScreenState with _$MapScreenState {
  const MapScreenState._();

  const factory MapScreenState({
    PointAnnotationManager? pointAnnotationManager,
    PointAnnotation? pointAnnotation,
    @Default(0.0) double iconSize,
    CircleAnnotationManager? circleAnnotationManager,
    MapboxMap? mapboxMap,
    @Default(0) int selectedIndex,
    @Default(0) int eventCounts,
    @Default(false) bool is3DEnabled,
    @Default(false) bool isScrolling,
    @Default(true) bool shouldCallApi,
    @Default('') String profilePic,
    @Default({}) Map<String, dynamic> focusedMarker,
    @Default({}) Map<String, dynamic> annotationPostIdMap,
    @Default({}) Map<String, dynamic> markerPositions,
    @Default('AWAAZ') String currentCity,
    Timer? debounceTimer,
    CameraOptions? camera,
    Point? topLeft,
    Point? topRight,
    Point? bottomLeft,
    Point? bottomRight,
    List<SelectedAreaEventPostData>? selectedAreaEventPostData,
    List<SelectedAreaEventPostData>? selectedAreaRescuePostData,
    List<SelectedAreaEventPostData>? selectedAreaGeneralPostData,
    @Default(0) int rescueEventCounts,
    @Default(0) int generalEventCounts,
    @Default(false) bool isLoading,
  }) = _Initial;

  @override
  // TODO: implement annotationPostIdMap
  Map<String, dynamic> get annotationPostIdMap => throw UnimplementedError();

  @override
  // TODO: implement bottomLeft
  Point? get bottomLeft => throw UnimplementedError();

  @override
  // TODO: implement bottomRight
  Point? get bottomRight => throw UnimplementedError();

  @override
  // TODO: implement camera
  CameraOptions? get camera => throw UnimplementedError();

  @override
  // TODO: implement circleAnnotationManager
  CircleAnnotationManager? get circleAnnotationManager =>
      throw UnimplementedError();

  @override
  // TODO: implement currentCity
  String get currentCity => throw UnimplementedError();

  @override
  // TODO: implement debounceTimer
  Timer? get debounceTimer => throw UnimplementedError();

  @override
  // TODO: implement eventCounts
  int get eventCounts => throw UnimplementedError();

  @override
  // TODO: implement focusedMarker
  Map<String, dynamic> get focusedMarker => throw UnimplementedError();

  @override
  // TODO: implement iconSize
  double get iconSize => throw UnimplementedError();

  @override
  // TODO: implement is3DEnabled
  bool get is3DEnabled => throw UnimplementedError();

  @override
  // TODO: implement isLoading
  bool get isLoading => throw UnimplementedError();

  @override
  // TODO: implement isScrolling
  bool get isScrolling => throw UnimplementedError();

  @override
  // TODO: implement mapboxMap
  MapboxMap? get mapboxMap => throw UnimplementedError();

  @override
  // TODO: implement markerPositions
  Map<String, dynamic> get markerPositions => throw UnimplementedError();

  @override
  // TODO: implement pointAnnotation
  PointAnnotation? get pointAnnotation => throw UnimplementedError();

  @override
  // TODO: implement pointAnnotationManager
  PointAnnotationManager? get pointAnnotationManager =>
      throw UnimplementedError();

  @override
  // TODO: implement profilePic
  String get profilePic => throw UnimplementedError();

  @override
  // TODO: implement rescueEventCounts
  int get rescueEventCounts => throw UnimplementedError();

  @override
  // TODO: implement selectedAreaEventPostData
  List<SelectedAreaEventPostData>? get selectedAreaEventPostData =>
      throw UnimplementedError();

  @override
  // TODO: implement selectedAreaRescuePostData
  List<SelectedAreaEventPostData>? get selectedAreaRescuePostData =>
      throw UnimplementedError();

  @override
  // TODO: implement selectedIndex
  int get selectedIndex => throw UnimplementedError();

  @override
  // TODO: implement shouldCallApi
  bool get shouldCallApi => throw UnimplementedError();

  @override
  // TODO: implement topLeft
  Point? get topLeft => throw UnimplementedError();

  @override
  // TODO: implement topRight
  Point? get topRight => throw UnimplementedError();

  @override
  // TODO: implement generalEventCounts
  int get generalEventCounts => throw UnimplementedError();

  @override
  // TODO: implement selectedAreaGeneralPostData
  List<SelectedAreaEventPostData>? get selectedAreaGeneralPostData =>
      throw UnimplementedError();
}
