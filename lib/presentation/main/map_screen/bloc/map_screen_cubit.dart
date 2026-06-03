import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:eagle_eye/core/utils/app_prefrence.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:sliding_up_panel_custom/sliding_up_panel_custom.dart';

import '../../../../core/constant/app_constant.dart';
import '../../../../core/utils/map_utils.dart';
import '../../../../data/models/event_news_detail_model.dart';
import '../../../../data/models/response_model.dart';
import '../../../../data/models/selected_area_event_post_model.dart';
import '../../../../data/repositories/main_repo.dart';
import '../map_screen.dart';

part 'map_screen_cubit.freezed.dart';
part 'map_screen_state.dart';

class MapScreenCubit extends Cubit<MapScreenState> {
  MapScreenCubit() : super(const MapScreenState()) {
    defaultCameraView();
    startLocationUpdateTimer();
  }

  setProfilePic() {
    emit(state.copyWith(profilePic: PrefService.getString(PrefService.profileUrl)));
  }

  Timer? _locationUpdateTimer;

  double? zoom;

  // Add flag to track marker creation process
  bool isCreatingMarkers = false;
  // Add flag to track current tab
  int currentTabIndex = 0;

  // Add flag to track full screen state
  bool isFullScreenTransitioning = false;

  // Add method to cancel marker creation
  void cancelMarkerCreation() {
    isCreatingMarkers = false;
  }

  // Add method to handle full screen transition
  void setFullScreenTransitioning(bool value) {
    isFullScreenTransitioning = value;
  }

  void startLocationUpdateTimer() {
    _locationUpdateTimer = Timer.periodic(Duration(minutes: 5), (timer) async {
      List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        if (PrefService.getString(PrefService.accessToken).isNotEmpty) {
          await updateUserCurrentLocation();
        }
      } else if (connectivityResult.contains(ConnectivityResult.none)) {
        log('No internet connection for update useState');
      }
    });
  }

  @override
  Future<void> close() {
    _locationUpdateTimer?.cancel();
    return super.close();
  }

  Future<void> updateUserCurrentLocation() async {
    await MapUtils.getUserCurrentLocationNormal(isOnTap: true);
    try {
      ResponseModel response = await MainRepository.updateUserCurrentLocation(
          data: {"longitude": MapUtils.position?.longitude, "latitude": MapUtils.position?.latitude});
      getAddressFromLatLang(MapUtils.position?.latitude ?? 0.0, MapUtils.position?.longitude ?? 0.0);
      if (response.status == true) {
        log('User location updated');
      } else {
        log('User location not updated');
      }
    } catch (e) {
      emit(state.copyWith());
      log('Cache Error ${e.toString()}');
    }
  }

  Future<void> getAddressFromLatLang(double latitude, double longitude) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(latitude, longitude);

      String currentCity = placeMarks.last.locality ?? 'Default City';

      log('Current location city:${placeMarks.last.locality}');
      emit(state.copyWith(
        currentCity: currentCity,
      ));
      PrefService.setValue(
        PrefService.currentCity,
        currentCity,
      );
      PrefService.setValue(PrefService.currentAddress, placeMarks[0].street ?? 'Default City');
    } catch (e) {
      log('Error getting location: $e');
    }
  }

// Default camera view
  defaultCameraView() {
    emit(state.copyWith(
        camera: CameraOptions(
            center: Point(
                coordinates:
                    Position(MapUtils.position?.longitude ?? defaultLang, MapUtils.position?.latitude ?? defaultLat)),
            zoom: zoom ?? 14,
            bearing: 0,
            pitch: 0)));
  }

// map created function
  onMapCreated(MapboxMap mapboxMap, material.BuildContext context) async {
    emit(state.copyWith(mapboxMap: mapboxMap));
    // Hide compass
    mapboxMap.compass.updateSettings(CompassSettings(enabled: false));
    // Hide scale bar
    mapboxMap.scaleBar.updateSettings(ScaleBarSettings(
      enabled: false,
    ));
    // Hide logo
    mapboxMap.logo.updateSettings(LogoSettings(
      enabled: false,
    ));
    // Hide info button
    mapboxMap.attribution.updateSettings(AttributionSettings(
      enabled: false,
    ));
    mapboxMap.location.updateSettings(
        LocationComponentSettings(enabled: true, pulsingEnabled: true, puckBearingEnabled: true, pulsingMaxRadius: 50));
    // Update gesture settings
    mapboxMap.gestures.updateSettings(GesturesSettings(
      quickZoomEnabled: false,
      simultaneousRotateAndPinchToZoomEnabled: false,
    ));
    // Set zoom limits
    await mapboxMap.setBounds(CameraBoundsOptions(
      minZoom: 11.00, // Minimum zoom level
      maxZoom: 20.00, // Maximum zoom level
    ));
    mapboxMap.annotations.createPointAnnotationManager().then((value) async {
      emit(state.copyWith(pointAnnotationManager: value));
      state.pointAnnotationManager?.addOnPointAnnotationClickListener(AnnotationClickListener(
        context: context,
      ));
      state.pointAnnotationManager?.setIconSize(Platform.isIOS ? 0.46.sp : 0.45.sp);
    });
    await MapUtils.getUserCurrentLocation(context);
    state.mapboxMap?.easeTo(
        CameraOptions(
            center: Point(
                coordinates:
                    Position(MapUtils.position?.longitude ?? defaultLang, MapUtils.position?.latitude ?? defaultLat)),
            zoom: 16,
            bearing: 0,
            pitch: 0),
        MapAnimationOptions(duration: 1000));
  }

// Modify createOneAnnotation to handle cancellation and improve performance
  void createOneAnnotation(material.BuildContext context, List<SelectedAreaEventPostData> eventPostList,
      CameraChangedEventData cameraEventData) async {
    // Set flag to indicate marker creation has started
    isCreatingMarkers = true;

    // Clear existing markers
    await clearAllMarkers();

    final double zoom = cameraEventData.cameraState.zoom;
    final double centerLat = cameraEventData.cameraState.center.coordinates.lat.toDouble();
    final double centerLng = cameraEventData.cameraState.center.coordinates.lng.toDouble();

    // Create a batch of markers to add at once
    List<PointAnnotationOptions> batchMarkers = [];
    Map<String, dynamic> focusedMarkerData = {};

    // Process markers in batches
    for (int i = 0; i < eventPostList.length; i++) {
      if (!isCreatingMarkers) {
        log("Marker creation cancelled");
        return;
      }

      final event = eventPostList[i];
      final double eventLat = event.latitude?.toDouble() ?? 0.0;
      final double eventLng = event.longitude?.toDouble() ?? 0.0;

      double distance = gl.Geolocator.distanceBetween(
        centerLat,
        centerLng,
        eventLat,
        eventLng,
      );

      // Only process markers within a reasonable distance
      if (distance > 5000) continue; // Skip markers too far away

      // Get marker icon data
      dynamic iconData = await getMarkerIcon(event.postCategoryName ?? '', event.postCategory ?? '');

      if (!isCreatingMarkers) {
        log("Marker creation cancelled during icon creation");
        return;
      }

      final circularImage = await addCircularBorder(iconData['list'], iconData['color']);

      if (!isCreatingMarkers) {
        log("Marker creation cancelled before adding marker");
        return;
      }

      // Add marker to batch
      batchMarkers.add(
        PointAnnotationOptions(
          image: circularImage,
          iconSize: state.iconSize,
          geometry: Point(coordinates: Position(eventLng, eventLat)),
          textField: event.id ?? "",
          textSize: 0.0,
          iconOffset: [0.0, -5.0],
          symbolSortKey: 10,
        ),
      );

      // Check for focused marker
      if (distance < 150 && (zoom >= 13.0 && zoom <= 17.0)) {
        focusedMarkerData = {
          'lat': eventLat,
          'lang': eventLng,
        };
      }
    }

    // Add all markers in a single batch operation
    if (batchMarkers.isNotEmpty && isCreatingMarkers) {
      PointAnnotationManager pointAnnotationManager =
          await state.mapboxMap!.annotations.createPointAnnotationManager(id: DateTime.now().toIso8601String());

      await pointAnnotationManager.createMulti(batchMarkers);

      emit(state.copyWith(
        pointAnnotationManager: pointAnnotationManager,
        focusedMarker: focusedMarkerData,
      ));

      annotationMarkerId.add(pointAnnotationManager.id);
    }

    // Reset flag when done
    isCreatingMarkers = false;
  }

  List<String> annotationMarkerId = [];

  Future<void> addMarker(
      Uint8List imageBytes, Position position, String uniqueId, material.BuildContext context) async {
    // state.pointAnnotationManager?.deleteAll();

    PointAnnotationManager pointAnnotationManager =
        await state.mapboxMap!.annotations.createPointAnnotationManager(id: DateTime.now().toIso8601String());
    pointAnnotationManager.create(
      PointAnnotationOptions(
        image: imageBytes,
        iconSize: state.iconSize,
        geometry: Point(coordinates: position),
        textField: uniqueId,
        textSize: 0.0,
        iconOffset: [0.0, -5.0],
        symbolSortKey: 10,
      ),
    );
    emit(state.copyWith(pointAnnotationManager: pointAnnotationManager));
    annotationMarkerId.add(pointAnnotationManager.id);
    log("Total Markers on Map: ${annotationMarkerId.length}");
  }

  // Add icon cache
  final Map<String, Map<String, dynamic>> _iconCache = {};

  Future<Map<String, dynamic>> getMarkerIcon(String eventType, String iconImage) async {
    // Check cache first
    final cacheKey = '$eventType-$iconImage';
    if (_iconCache.containsKey(cacheKey)) {
      return _iconCache[cacheKey]!;
    }

    try {
      final result = await loadNetworkImage(iconImage);
      final cachedResult = {"list": result["list"], "color": material.Colors.grey};
      _iconCache[cacheKey] = cachedResult;
      return cachedResult;
    } catch (e) {
      log('Error loading marker icon: $e');
      // Return a default icon if loading fails
      return {"list": Uint8List(0), "color": material.Colors.grey};
    }
  }

  // Optimize image loading
  Future<Map<String, dynamic>> loadNetworkImage(String iconUrl) async {
    try {
      final response = await http.get(Uri.parse(iconUrl));

      if (response.statusCode == 200) {
        final Uint8List originalBytes = response.bodyBytes;

        // Decode the image
        final codec = await ui.instantiateImageCodec(originalBytes);
        final frame = await codec.getNextFrame();
        final ui.Image originalImage = frame.image;

        // Create a new image with smaller size
        final double targetWidth = 124.w; // Reduced size for better performance
        final double targetHeight = 124.w;

        final pictureRecorder = ui.PictureRecorder();
        final canvas = ui.Canvas(pictureRecorder);

        // Draw the resized image
        canvas.drawImageRect(
          originalImage,
          ui.Rect.fromLTWH(0, 0, originalImage.width.toDouble(), originalImage.height.toDouble()),
          ui.Rect.fromLTWH(0, 0, targetWidth, targetHeight),
          ui.Paint()..filterQuality = ui.FilterQuality.medium, // Reduced quality for better performance
        );

        // Convert to final image
        final picture = pictureRecorder.endRecording();
        final ui.Image resizedImage = await picture.toImage(targetWidth.toInt(), targetHeight.toInt());
        final ByteData? resizedBytes = await resizedImage.toByteData(format: ui.ImageByteFormat.png);

        return {"list": resizedBytes!.buffer.asUint8List(), "color": material.Colors.grey};
      } else {
        throw Exception('Failed to load network image');
      }
    } catch (e) {
      log('Error in loadNetworkImage: $e');
      rethrow;
    }
  }

// Create border around markers
  Future<Uint8List> addCircularBorder(Uint8List originalImage, ui.Color ringColor) async {
    final codec = await ui.instantiateImageCodec(originalImage);
    final frame = await codec.getNextFrame();
    final ui.Image originalUiImage = frame.image;

    final double borderWidth = 8;
    final double padding = 5;
    final double triangleHeight = 25;
    final double scaleFactor = 0.85; // Slightly reduced to ensure image fits within circle

    final double originalSize = originalUiImage.width.toDouble();
    final double newImageSize = originalSize * scaleFactor;
    final double canvasSize = originalSize + (borderWidth + padding) * 2;

    final pictureRecorder = ui.PictureRecorder();
    final canvas = ui.Canvas(pictureRecorder);

    final double center = canvasSize / 2;

    // Draw black background circle
    final paintBackground = ui.Paint()
      // ..color = ui.Color(0xFF000000) // Black marker BG color
      ..color = ui.Color(0xFFFFFFFF) // white marker BG color
      ..style = ui.PaintingStyle.fill;
    canvas.drawCircle(ui.Offset(center, center), center, paintBackground);

    // Draw border ring
    final paintBorder = ui.Paint()
      ..color = ringColor
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..isAntiAlias = true;
    canvas.drawCircle(ui.Offset(center, center), center - borderWidth / 2, paintBorder);

    // Create a circular clip path for the image
    final imageClipPath = ui.Path()
      ..addOval(ui.Rect.fromCircle(
        center: ui.Offset(center, center),
        radius: newImageSize / 2,
      ));
    canvas.clipPath(imageClipPath);

    // Draw scaled image inside the border
    final double imageStart = center - newImageSize / 2;
    canvas.drawImageRect(
      originalUiImage,
      ui.Rect.fromLTWH(0, 0, originalUiImage.width.toDouble(), originalUiImage.height.toDouble()),
      ui.Rect.fromLTWH(imageStart, imageStart, newImageSize, newImageSize),
      ui.Paint()..isAntiAlias = true,
    );

    // Draw triangle at the bottom
    final paintTriangle = ui.Paint()..color = const ui.Color(0xFF808080);
    final trianglePath = ui.Path()
      ..moveTo(center - triangleHeight, canvasSize + 5)
      ..lineTo(center + triangleHeight, canvasSize + 5)
      ..lineTo(center, canvasSize + triangleHeight + 5)
      ..close();
    canvas.drawPath(trianglePath, paintTriangle);

    // Convert to final image
    final picture = pictureRecorder.endRecording();
    final ui.Image finalImage = await picture.toImage(
      canvasSize.toInt(),
      (canvasSize + triangleHeight + 5).toInt(),
    );
    final byteData = await finalImage.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

// Modify onCameraChange to handle tab switching
  onCameraChange(CameraChangedEventData cameraEvent, material.BuildContext context, int tabControllerIndex) async {
    // Skip API calls during full screen transition
    if (isFullScreenTransitioning) {
      return;
    }

    // Cancel any ongoing marker creation when switching tabs
    if (currentTabIndex != tabControllerIndex) {
      await clearAllMarkers();
      cancelMarkerCreation();
      currentTabIndex = tabControllerIndex;
    }

    final double zoom = cameraEvent.cameraState.zoom;
    if (zoom > 15) {
      emit(state.copyWith(iconSize: Platform.isIOS ? 0.45.sp : 0.44.sp));
    } else if (zoom > 13) {
      emit(state.copyWith(iconSize: Platform.isIOS ? 0.46.sp : 0.45.sp));
    } else {
      emit(state.copyWith(iconSize: Platform.isIOS ? 0.46.sp : 0.45.sp));
    }

    emit(state.copyWith(focusedMarker: {}, markerPositions: {}));

    if (state.debounceTimer?.isActive ?? false) {
      state.debounceTimer?.cancel();
      emit(state.copyWith(isScrolling: true));
    }

    emit(state.copyWith(
        debounceTimer: Timer(const Duration(milliseconds: 500), () async {
      await getScreenLatLng(cameraEvent, context, tabControllerIndex);
    })));
  }

  isScrollingValueChange(bool isScrolling) {
    emit(state.copyWith(isScrolling: isScrolling));
  }

  focusedMarkerEmpty() {
    emit(state.copyWith(focusedMarker: {}));
  }

  Future<void> getScreenLatLng(
      CameraChangedEventData cameraEventData, material.BuildContext context, int tabControllerIndex) async {
    if (state.mapboxMap == null) {
      log('MapboxMap is not initialized yet.');
      return;
    }
    try {
      if (Platform.isIOS) {
        material.Size mapSize = material.MediaQuery.of(context).size;
        // Get precise screen coordinates
        ScreenCoordinate topLeftScreen = ScreenCoordinate(x: 0.0, y: 0.0);
        ScreenCoordinate topRightScreen = ScreenCoordinate(x: mapSize.width - 1, y: 0.0);
        ScreenCoordinate bottomLeftScreen = ScreenCoordinate(x: 0.0, y: mapSize.height - 1);
        ScreenCoordinate bottomRightScreen = ScreenCoordinate(x: mapSize.width - 1, y: mapSize.height - 1);

        Point? tLeft = await state.mapboxMap?.coordinateForPixel(topLeftScreen);
        Point? tRight = await state.mapboxMap?.coordinateForPixel(topRightScreen);
        Point? bLeft = await state.mapboxMap?.coordinateForPixel(bottomLeftScreen);
        Point? bRight = await state.mapboxMap?.coordinateForPixel(bottomRightScreen);

        if (tLeft != null && tRight != null && bLeft != null && bRight != null) {
          emit(state.copyWith(
            topLeft: tLeft,
            topRight: tRight,
            bottomLeft: bLeft,
            bottomRight: bRight,
          ));

          log('Top Left: ${tLeft.coordinates.lat}, ${tLeft.coordinates.lng}');
          log('Top Right: ${tRight.coordinates.lat}, ${tRight.coordinates.lng}');
          log('Bottom Left: ${bLeft.coordinates.lat}, ${bLeft.coordinates.lng}');
          log('Bottom Right: ${bRight.coordinates.lat}, ${bRight.coordinates.lng}');

          // await clearAllMarkers();

          if (tabControllerIndex == 0) {
            getInThisAreaPostList(
              topLeftLat: tLeft.coordinates.lat.toDouble(),
              topLeftLon: tLeft.coordinates.lng.toDouble(),
              topRightLat: tRight.coordinates.lat.toDouble(),
              topRightLon: tRight.coordinates.lng.toDouble(),
              bottomLeftLat: bLeft.coordinates.lat.toDouble(),
              bottomLeftLon: bLeft.coordinates.lng.toDouble(),
              bottomRightLat: bRight.coordinates.lat.toDouble(),
              bottomRightLon: bRight.coordinates.lng.toDouble(),
              context: context,
              cameraEventData: cameraEventData,
            );
          } else if (tabControllerIndex == 1) {
            getInThisAreaGeneralList(
              topLeftLat: tLeft.coordinates.lat.toDouble(),
              topLeftLon: tLeft.coordinates.lng.toDouble(),
              topRightLat: tRight.coordinates.lat.toDouble(),
              topRightLon: tRight.coordinates.lng.toDouble(),
              bottomLeftLat: bLeft.coordinates.lat.toDouble(),
              bottomLeftLon: bLeft.coordinates.lng.toDouble(),
              bottomRightLat: bRight.coordinates.lat.toDouble(),
              bottomRightLon: bRight.coordinates.lng.toDouble(),
              context: context,
              cameraEventData: cameraEventData,
            );
          } else {
            getInThisAreaRescueList(
              topLeftLat: tLeft.coordinates.lat.toDouble(),
              topLeftLon: tLeft.coordinates.lng.toDouble(),
              topRightLat: tRight.coordinates.lat.toDouble(),
              topRightLon: tRight.coordinates.lng.toDouble(),
              bottomLeftLat: bLeft.coordinates.lat.toDouble(),
              bottomLeftLon: bLeft.coordinates.lng.toDouble(),
              bottomRightLat: bRight.coordinates.lat.toDouble(),
              bottomRightLon: bRight.coordinates.lng.toDouble(),
              context: context,
              cameraEventData: cameraEventData,
            );
          }
        } else {
          log('Error: Unable to get lat/lng from screen coordinates.');
        }
      } else {
        Size? mapSize = await state.mapboxMap?.getSize();

        if (mapSize == null) {
          log('Map size is null');
          return;
        }
        // Get precise screen coordinates
        ScreenCoordinate topLeftScreen = ScreenCoordinate(x: 0.0, y: 0.0);
        ScreenCoordinate topRightScreen = ScreenCoordinate(x: mapSize.width - 1, y: 0.0);
        ScreenCoordinate bottomLeftScreen = ScreenCoordinate(x: 0.0, y: mapSize.height - 1);
        ScreenCoordinate bottomRightScreen = ScreenCoordinate(x: mapSize.width - 1, y: mapSize.height - 1);

        Point? tLeft = await state.mapboxMap?.coordinateForPixel(topLeftScreen);
        Point? tRight = await state.mapboxMap?.coordinateForPixel(topRightScreen);
        Point? bLeft = await state.mapboxMap?.coordinateForPixel(bottomLeftScreen);
        Point? bRight = await state.mapboxMap?.coordinateForPixel(bottomRightScreen);

        if (tLeft != null && tRight != null && bLeft != null && bRight != null) {
          emit(state.copyWith(
            topLeft: tLeft,
            topRight: tRight,
            bottomLeft: bLeft,
            bottomRight: bRight,
          ));

          log('Top Left: ${tLeft.coordinates.lat}, ${tLeft.coordinates.lng}');
          log('Top Right: ${tRight.coordinates.lat}, ${tRight.coordinates.lng}');
          log('Bottom Left: ${bLeft.coordinates.lat}, ${bLeft.coordinates.lng}');
          log('Bottom Right: ${bRight.coordinates.lat}, ${bRight.coordinates.lng}');

          // await clearAllMarkers();

          if (tabControllerIndex == 0) {
            getInThisAreaPostList(
              topLeftLat: tLeft.coordinates.lat.toDouble(),
              topLeftLon: tLeft.coordinates.lng.toDouble(),
              topRightLat: tRight.coordinates.lat.toDouble(),
              topRightLon: tRight.coordinates.lng.toDouble(),
              bottomLeftLat: bLeft.coordinates.lat.toDouble(),
              bottomLeftLon: bLeft.coordinates.lng.toDouble(),
              bottomRightLat: bRight.coordinates.lat.toDouble(),
              bottomRightLon: bRight.coordinates.lng.toDouble(),
              context: context,
              cameraEventData: cameraEventData,
            );
          } else if (tabControllerIndex == 1) {
            getInThisAreaGeneralList(
              topLeftLat: tLeft.coordinates.lat.toDouble(),
              topLeftLon: tLeft.coordinates.lng.toDouble(),
              topRightLat: tRight.coordinates.lat.toDouble(),
              topRightLon: tRight.coordinates.lng.toDouble(),
              bottomLeftLat: bLeft.coordinates.lat.toDouble(),
              bottomLeftLon: bLeft.coordinates.lng.toDouble(),
              bottomRightLat: bRight.coordinates.lat.toDouble(),
              bottomRightLon: bRight.coordinates.lng.toDouble(),
              context: context,
              cameraEventData: cameraEventData,
            );
          } else {
            getInThisAreaRescueList(
              topLeftLat: tLeft.coordinates.lat.toDouble(),
              topLeftLon: tLeft.coordinates.lng.toDouble(),
              topRightLat: tRight.coordinates.lat.toDouble(),
              topRightLon: tRight.coordinates.lng.toDouble(),
              bottomLeftLat: bLeft.coordinates.lat.toDouble(),
              bottomLeftLon: bLeft.coordinates.lng.toDouble(),
              bottomRightLat: bRight.coordinates.lat.toDouble(),
              bottomRightLon: bRight.coordinates.lng.toDouble(),
              context: context,
              cameraEventData: cameraEventData,
            );
          }
        } else {
          log('Error: Unable to get lat/lng from screen coordinates.');
        }
      }
    } catch (e, stackTrace) {
      log('Error in getScreenLatLng: $e\n$stackTrace');
    }
  }

// Cancel debounce timer
  void debounceTimerCancel() {
    state.debounceTimer?.cancel();
  }

  void dispose() {
    debounceTimerCancel();
    state.mapboxMap!.dispose();
  }

// Change map view to place
  navigateToPlaceView({required num lat, required num long, double? zoom, double? bearing, double? pitch}) {
    state.mapboxMap!.easeTo(
      CameraOptions(
        center: Point(
          coordinates: Position(long, lat),
        ),
        zoom: zoom,
        bearing: bearing,
        pitch: pitch,
      ),
      MapAnimationOptions(duration: 1000), // Smooth animation for 1 second
    );
    this.zoom = zoom;
    // state.mapboxMap!.setCamera(
    //   CameraOptions(
    //     center: Point(
    //       coordinates: Position(long, lat),
    //     ),
    //     zoom: zoom ?? 13,
    //     bearing: bearing,
    //     pitch: pitch,
    //   ),
    // );
  }

// Modify getInThisAreaPostList to handle cancellation
  getInThisAreaPostList(
      {required double topLeftLat,
      required double topLeftLon,
      required double topRightLat,
      required double topRightLon,
      required double bottomLeftLat,
      required double bottomLeftLon,
      required double bottomRightLat,
      required double bottomRightLon,
      required material.BuildContext context,
      required CameraChangedEventData cameraEventData}) async {
    // Cancel any ongoing marker creation
    cancelMarkerCreation();

    emit(state.copyWith(isLoading: true));

    try {
      ResponseModel response = await MainRepository.selectedAreaPostEvents(data: {
        "polygonCoords": [
          [topLeftLat, topLeftLon],
          [topRightLat, topRightLon],
          [bottomLeftLat, bottomLeftLon],
          [bottomRightLat, bottomRightLon]
        ],
        "postType": "incident"
      });

      if (response.status == true && response.body != null) {
        SelectedAreaEventPostModel selectedAreaEventPostModel = SelectedAreaEventPostModel.fromJson(response.toJson());
        List<SelectedAreaEventPostData> tempList = selectedAreaEventPostModel.body?.data ?? [];
        emit(state.copyWith(
            isLoading: false,
            selectedAreaEventPostData: tempList,
            eventCounts: selectedAreaEventPostModel.body?.eventCounts ?? 0));

        // Only create markers if this is still the current tab
        if (currentTabIndex == 0) {
          createOneAnnotation(context, tempList, cameraEventData);
        }
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      log('Cache Error ${e.toString()}');
    }
  }

  PanelController panelController = PanelController();

  closeSlidePanel() {
    if (panelController.isAttached) {
      panelController.close();
    }
  }

  getInThisAreaRescueList(
      {required double topLeftLat,
      required double topLeftLon,
      required double topRightLat,
      required double topRightLon,
      required double bottomLeftLat,
      required double bottomLeftLon,
      required double bottomRightLat,
      required double bottomRightLon,
      required material.BuildContext context,
      required CameraChangedEventData cameraEventData}) async {
    // Cancel any ongoing marker creation
    cancelMarkerCreation();

    emit(state.copyWith(isLoading: true));

    try {
      ResponseModel response = await MainRepository.selectedAreaPostEvents(data: {
        "polygonCoords": [
          [topLeftLat, topLeftLon],
          [topRightLat, topRightLon],
          [bottomLeftLat, bottomLeftLon],
          [bottomRightLat, bottomRightLon]
        ],
        "postType": "rescue"
      });

      if (response.status == true && response.body != null) {
        SelectedAreaEventPostModel selectedAreaEventPostModel = SelectedAreaEventPostModel.fromJson(response.toJson());
        List<SelectedAreaEventPostData> tempList = selectedAreaEventPostModel.body?.data ?? [];
        emit(state.copyWith(
            isLoading: false,
            selectedAreaRescuePostData: tempList,
            rescueEventCounts: selectedAreaEventPostModel.body?.eventCounts ?? 0));

        // Only create markers if this is still the current tab
        if (currentTabIndex == 2) {
          createOneAnnotation(context, tempList, cameraEventData);
        }
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      log('Cache Error ${e.toString()}');
    }
  }

  getInThisAreaGeneralList(
      {required double topLeftLat,
      required double topLeftLon,
      required double topRightLat,
      required double topRightLon,
      required double bottomLeftLat,
      required double bottomLeftLon,
      required double bottomRightLat,
      required double bottomRightLon,
      required material.BuildContext context,
      required CameraChangedEventData cameraEventData}) async {
    // Cancel any ongoing marker creation
    cancelMarkerCreation();

    emit(state.copyWith(isLoading: true));

    try {
      ResponseModel response = await MainRepository.selectedAreaPostEvents(data: {
        "polygonCoords": [
          [topLeftLat, topLeftLon],
          [topRightLat, topRightLon],
          [bottomLeftLat, bottomLeftLon],
          [bottomRightLat, bottomRightLon]
        ],
        "postType": "general_category"
      });

      if (response.status == true && response.body != null) {
        SelectedAreaEventPostModel selectedAreaEventPostModel = SelectedAreaEventPostModel.fromJson(response.toJson());
        List<SelectedAreaEventPostData> tempList = selectedAreaEventPostModel.body?.data ?? [];
        emit(state.copyWith(
            isLoading: false,
            selectedAreaGeneralPostData: tempList,
            generalEventCounts: selectedAreaEventPostModel.body?.eventCounts ?? 0));

        // Only create markers if this is still the current tab
        if (currentTabIndex == 1) {
          createOneAnnotation(context, tempList, cameraEventData);
        }
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      log('Cache Error ${e.toString()}');
    }
  }

  Future<EventNewsDetailModel?> getRescueNewsDetailData({required String id}) async {
    emit(state.copyWith(isLoading: true));
    try {
      ResponseModel response = await MainRepository.getEventNewsDetailData(postId: id);
      if (response.status == true && response.body != null) {
        emit(state.copyWith(isLoading: false));
        EventNewsDetailModel eventNewsDetailModel = EventNewsDetailModel.fromJson(response.toJson());
        return eventNewsDetailModel;
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      log('Cache Error ${e.toString()}');
    }
    return null;
  }

  Future<void> clearAllMarkers() async {
    try {
      if (state.mapboxMap == null) return;

      // Clear all annotation managers in parallel
      final futures = annotationMarkerId.map((id) {
        final future = state.mapboxMap?.annotations.removeAnnotationManagerById(id);
        return future ?? Future.value();
      });

      await Future.wait(futures);
      annotationMarkerId.clear();
      log("Cleared all markers from map");
    } catch (e) {
      log('Error clearing markers: $e');
    }
  }
}
